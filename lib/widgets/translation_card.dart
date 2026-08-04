import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/translator_provider.dart';
import '../services/tts_service.dart';

class TranslationCard extends StatefulWidget {
  final bool isSource;

  const TranslationCard({super.key, required this.isSource});

  @override
  State<TranslationCard> createState() => _TranslationCardState();
}

class _TranslationCardState extends State<TranslationCard> {
  final TextEditingController _controller = TextEditingController();
  bool _isSpeaking = false;
  bool _copied = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _speak(String text, String langCode) async {
    if (text.isEmpty) return;
    setState(() => _isSpeaking = true);
    await TtsService.speak(text, langCode);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isSpeaking = false);
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TranslatorProvider>();
    final text = widget.isSource ? provider.inputText : provider.outputText;
    final langCode = widget.isSource
        ? provider.sourceLang.code
        : provider.targetLang.code;
    final isLoading = !widget.isSource && provider.isLoading;

    // Sync controller for source
    if (widget.isSource && _controller.text != provider.inputText) {
      _controller.value = _controller.value.copyWith(
        text: provider.inputText,
        selection: TextSelection.collapsed(offset: provider.inputText.length),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 160),
          decoration: BoxDecoration(
            color: widget.isSource
                ? const Color(0xFF1A2240).withValues(alpha: 0.85)
                : const Color(0xFF14103A).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSource
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFF7C3AED).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Text(
                  widget.isSource ? 'SOURCE TEXT' : 'TRANSLATION',
                  style: GoogleFonts.outfit(
                    color: widget.isSource
                        ? Colors.white38
                        : const Color(0xFF7C3AED).withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Text area
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: widget.isSource
                    ? TextField(
                        controller: _controller,
                        onChanged: (val) {
                          context.read<TranslatorProvider>().setInputText(val);
                        },
                        onSubmitted: (_) =>
                            context.read<TranslatorProvider>().translate(),
                        maxLines: null,
                        minLines: 4,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.5,
                        ).copyWith(
                          fontFamilyFallback: const ['Noto Sans Tamil', 'Noto Sans', 'sans-serif'],
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type or paste text here...',
                          hintStyle: GoogleFonts.inter(
                            color: Colors.white24,
                            fontSize: 16,
                          ).copyWith(
                            fontFamilyFallback: const ['Noto Sans Tamil', 'Noto Sans', 'sans-serif'],
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        cursorColor: const Color(0xFF7C3AED),
                      )
                    : isLoading
                        ? _buildLoadingDots()
                        : SelectableText(
                            text,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ).copyWith(
                              fontFamilyFallback: const ['Noto Sans Tamil', 'Noto Sans', 'sans-serif'],
                            ),
                            minLines: 4,
                          ).animate().fadeIn(duration: 300.ms),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  children: [
                    // Character count (source only)
                    if (widget.isSource)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '${provider.inputText.length}/5000',
                          style: GoogleFonts.inter(
                            color: Colors.white24,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    const Spacer(),

                    // Clear (source only)
                    if (widget.isSource && provider.inputText.isNotEmpty)
                      _ActionButton(
                        icon: Icons.close,
                        tooltip: 'Clear',
                        onTap: () {
                          _controller.clear();
                          context.read<TranslatorProvider>().setInputText('');
                        },
                      ),

                    // Copy
                    if (text.isNotEmpty)
                      _ActionButton(
                        icon: _copied ? Icons.check : Icons.copy_rounded,
                        tooltip: _copied ? 'Copied!' : 'Copy',
                        color: _copied ? const Color(0xFF06B6D4) : null,
                        onTap: () => _copyToClipboard(text),
                      ),

                    // TTS
                    if (text.isNotEmpty && langCode != 'auto')
                      _ActionButton(
                        icon: _isSpeaking
                            ? Icons.stop_circle_outlined
                            : Icons.volume_up_rounded,
                        tooltip: _isSpeaking ? 'Stop' : 'Listen',
                        color: _isSpeaking ? const Color(0xFF7C3AED) : null,
                        onTap: () {
                          if (_isSpeaking) {
                            TtsService.stop();
                            setState(() => _isSpeaking = false);
                          } else {
                            _speak(text, langCode);
                          }
                        },
                      ),

                    // Translate button (source only)
                    if (widget.isSource)
                      GestureDetector(
                        onTap: () => context.read<TranslatorProvider>().translate(),
                        child: Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.translate,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Translate',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return SizedBox(
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              borderRadius: BorderRadius.circular(5),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scaleXY(
                begin: 0.6,
                end: 1.2,
                duration: 600.ms,
                delay: Duration(milliseconds: i * 200),
                curve: Curves.easeInOut,
              )
              .then()
              .scaleXY(begin: 1.2, end: 0.6, duration: 600.ms),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: color ?? Colors.white38,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
