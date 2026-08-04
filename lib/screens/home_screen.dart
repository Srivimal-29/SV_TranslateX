import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/translator_provider.dart';
import '../widgets/language_selector.dart';
import '../widgets/translation_card.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showLanguageSelector({
    required BuildContext context,
    required bool isSource,
  }) {
    final provider = context.read<TranslatorProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LanguageSelectorSheet(
        selected: isSource ? provider.sourceLang : provider.targetLang,
        includeAutoDetect: isSource,
        onSelected: (lang) {
          if (isSource) {
            provider.setSourceLang(lang);
          } else {
            provider.setTargetLang(lang);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TranslatorProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background gradient blobs
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7C3AED).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF06B6D4).withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        // Logo + title
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.3), width: 1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Image.asset(
                                  'assets/logo.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),


                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SV TranslateX',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '70+ Languages',
                                  style: GoogleFonts.inter(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        // History button
                        Stack(
                          children: [
                            Material(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HistoryScreen(),
                                    ),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.history_rounded,
                                    color: Colors.white70,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            if (provider.history.isNotEmpty)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF7C3AED),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 28)),

                // Offline Banner
                if (provider.isOffline)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded, color: Color(0xFFDC2626), size: 18),
                            const SizedBox(width: 10),
                            Text(
                              'No internet connection',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFDC2626),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 300.ms),
                    ),
                  ),

                // Language selector row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Source language button
                        Expanded(
                          child: _LanguageButton(
                            name: provider.sourceLang.name,
                            isAuto: provider.sourceLang.code == 'auto',
                            onTap: () => _showLanguageSelector(
                                context: context, isSource: true),
                          ),
                        ),

                        // Swap button
                        GestureDetector(
                          onTap: provider.sourceLang.code != 'auto'
                              ? provider.swapLanguages
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: provider.sourceLang.code != 'auto'
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF7C3AED),
                                        Color(0xFF06B6D4)
                                      ],
                                    )
                                  : null,
                              color: provider.sourceLang.code == 'auto'
                                  ? Colors.white12
                                  : null,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.swap_horiz_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),

                        // Target language button
                        Expanded(
                          child: _LanguageButton(
                            name: provider.targetLang.name,
                            isAuto: false,
                            onTap: () => _showLanguageSelector(
                                context: context, isSource: false),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Source text card
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TranslationCard(isSource: true),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Output card
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TranslationCard(isSource: false),
                  ),
                ),

                // Recent history preview
                if (provider.history.isNotEmpty) ...[
                  const SliverToBoxAdapter(child: SizedBox(height: 28)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoryScreen(),
                              ),
                            ),
                            child: Text(
                              'See all',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF7C3AED),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = provider.history[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: _HistoryPreviewCard(
                            sourceText: item.sourceText,
                            translatedText: item.translatedText,
                            sourceLangName: item.sourceLangName,
                            targetLangName: item.targetLangName,
                          ),
                        ).animate().fadeIn(
                            duration: 300.ms,
                            delay: Duration(milliseconds: 50 * index));
                      },
                      childCount: provider.history.take(3).length,
                    ),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String name;
  final bool isAuto;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.name,
    required this.isAuto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A2240),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isAuto ? Icons.auto_awesome_rounded : Icons.language_rounded,
                color: isAuto ? const Color(0xFF06B6D4) : const Color(0xFF7C3AED),
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.white38, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryPreviewCard extends StatelessWidget {
  final String sourceText;
  final String translatedText;
  final String sourceLangName;
  final String targetLangName;

  const _HistoryPreviewCard({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLangName,
    required this.targetLangName,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2240).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$sourceLangName → $targetLangName',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7C3AED),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                sourceText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 13,
                ).copyWith(
                  fontFamilyFallback: const ['Noto Sans Tamil', 'Noto Sans', 'sans-serif'],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                translatedText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ).copyWith(
                  fontFamilyFallback: const ['Noto Sans Tamil', 'Noto Sans', 'sans-serif'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
