import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/language.dart';

class LanguageSelectorSheet extends StatefulWidget {
  final Language selected;
  final bool includeAutoDetect;
  final ValueChanged<Language> onSelected;

  const LanguageSelectorSheet({
    super.key,
    required this.selected,
    required this.onSelected,
    this.includeAutoDetect = false,
  });

  @override
  State<LanguageSelectorSheet> createState() => _LanguageSelectorSheetState();
}

class _LanguageSelectorSheetState extends State<LanguageSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Language> _filtered = [];
  List<Language> _allLanguages = [];

  @override
  void initState() {
    super.initState();
    _allLanguages = [
      if (widget.includeAutoDetect) Language.autoDetect,
      ...Language.supportedLanguages,
    ];
    _filtered = List.from(_allLanguages);
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _allLanguages
          .where((l) =>
              l.name.toLowerCase().contains(query) ||
              l.nativeName.toLowerCase().contains(query) ||
              l.code.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF0F1629),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'Select Language',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search language...',
                hintStyle: GoogleFonts.inter(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1A2240),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final lang = _filtered[index];
                final isSelected = lang.code == widget.selected.code;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      widget.onSelected(lang);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7C3AED).withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: const Color(0xFF7C3AED), width: 1)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.name,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                if (lang.nativeName != lang.name)
                                  Text(
                                    lang.nativeName,
                                    style: GoogleFonts.inter(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ).copyWith(
                                      fontFamilyFallback: const [
                                        'Noto Sans Tamil',
                                        'Noto Sans Devanagari',
                                        'Noto Sans Malayalam',
                                        'Noto Sans Telugu',
                                        'Noto Sans Bengali',
                                        'Noto Sans Gujarati',
                                        'Noto Sans Kannada',
                                        'Noto Sans Gurmukhi',
                                        'Noto Sans Arabic',
                                        'Noto Sans SC',
                                        'Noto Sans JP',
                                        'Noto Sans KR',
                                        'Noto Sans Thai',
                                        'Noto Sans',
                                        'sans-serif',
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Color(0xFF7C3AED), size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
