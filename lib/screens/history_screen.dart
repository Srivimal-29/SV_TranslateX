import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/translator_provider.dart';
import '../models/translation_history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TranslatorProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF7C3AED).withValues(alpha: 0.2),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white70, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'History',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (provider.history.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => _confirmClear(context, provider),
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 18),
                          label: Text(
                            'Clear all',
                            style: GoogleFonts.inter(
                              color: Colors.redAccent,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

                // History list
                Expanded(
                  child: provider.history.isEmpty
                      ? _buildEmpty()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                          itemCount: provider.history.length,
                          itemBuilder: (context, index) {
                            return _HistoryCard(
                              item: provider.history[index],
                              onDelete: () => provider
                                  .deleteHistoryItem(provider.history[index].id),
                            ).animate().fadeIn(
                                duration: 300.ms,
                                delay: Duration(milliseconds: 30 * index));
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2240),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.history_rounded,
                color: Colors.white24, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            'No history yet',
            style: GoogleFonts.outfit(
              color: Colors.white54,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your translations will appear here',
            style: GoogleFonts.inter(color: Colors.white24, fontSize: 13),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.9),
    );
  }

  void _confirmClear(BuildContext context, TranslatorProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A2240),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear History',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'All translation history will be permanently deleted.',
          style: GoogleFonts.inter(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(context);
            },
            child: Text('Delete All',
                style: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final TranslationHistory item;
  final VoidCallback onDelete;

  const _HistoryCard({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2240).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language pair + timestamp
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${item.sourceLangName} → ${item.targetLangName}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTime(item.timestamp),
                        style: GoogleFonts.inter(
                          color: Colors.white24,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Source text
                  Text(
                    item.sourceText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.4,
                    ).copyWith(
                      fontFamilyFallback: const ['Noto Sans Tamil', 'Noto Sans', 'sans-serif'],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  const SizedBox(height: 8),

                  // Translated text
                  Text(
                    item.translatedText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ).copyWith(
                      fontFamilyFallback: const ['Noto Sans Tamil', 'Noto Sans', 'sans-serif'],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Swipe left to delete',
                      style: GoogleFonts.inter(
                        color: Colors.white12,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
