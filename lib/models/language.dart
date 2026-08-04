class Language {
  final String code;
  final String name;
  final String nativeName;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  static const Language autoDetect = Language(
    code: 'auto',
    name: 'Auto Detect',
    nativeName: 'Auto Detect',
  );

  static const List<Language> supportedLanguages = [
    Language(code: 'en', name: 'English', nativeName: 'English'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    Language(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം'),
    Language(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી'),
    Language(code: 'mr', name: 'Marathi', nativeName: 'मராठी'),
    Language(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ'),
    Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা'),
    Language(code: 'ur', name: 'Urdu', nativeName: 'اردو'),
    Language(code: 'es', name: 'Spanish', nativeName: 'Español'),
    Language(code: 'fr', name: 'French', nativeName: 'Français'),
    Language(code: 'de', name: 'German', nativeName: 'Deutsch'),
    Language(code: 'it', name: 'Italian', nativeName: 'Italiano'),
    Language(code: 'pt', name: 'Portuguese', nativeName: 'Português'),
    Language(code: 'ru', name: 'Russian', nativeName: 'Русский'),
    Language(code: 'zh-CN', name: 'Chinese (Simplified)', nativeName: '简体中文'),
    Language(code: 'zh-TW', name: 'Chinese (Traditional)', nativeName: '繁體中文'),
    Language(code: 'ja', name: 'Japanese', nativeName: '日本語'),
    Language(code: 'ko', name: 'Korean', nativeName: '한국어'),
    Language(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
    Language(code: 'tr', name: 'Turkish', nativeName: 'Türkçe'),
    Language(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt'),
    Language(code: 'th', name: 'Thai', nativeName: 'ภาษาไทย'),
    Language(code: 'pl', name: 'Polish', nativeName: 'Polski'),
    Language(code: 'nl', name: 'Dutch', nativeName: 'Nederlands'),
    Language(code: 'sv', name: 'Swedish', nativeName: 'Svenska'),
    Language(code: 'da', name: 'Danish', nativeName: 'Dansk'),
    Language(code: 'no', name: 'Norwegian', nativeName: 'Norsk'),
    Language(code: 'fi', name: 'Finnish', nativeName: 'Suomi'),
    Language(code: 'el', name: 'Greek', nativeName: 'Ελληνικά'),
    Language(code: 'cs', name: 'Czech', nativeName: 'Čeština'),
    Language(code: 'hu', name: 'Hungarian', nativeName: 'Magyar'),
    Language(code: 'ro', name: 'Romanian', nativeName: 'Română'),
    Language(code: 'uk', name: 'Ukrainian', nativeName: 'Українська'),
    Language(code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia'),
    Language(code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu'),
    Language(code: 'fa', name: 'Persian', nativeName: 'فارسی'),
    Language(code: 'he', name: 'Hebrew', nativeName: 'עברית'),
    Language(code: 'sw', name: 'Swahili', nativeName: 'Kiswahili'),
    Language(code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans'),
    Language(code: 'sq', name: 'Albanian', nativeName: 'Shqip'),
    Language(code: 'hy', name: 'Armenian', nativeName: 'Հայերեն'),
    Language(code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan'),
    Language(code: 'eu', name: 'Basque', nativeName: 'Euskara'),
    Language(code: 'be', name: 'Belarusian', nativeName: 'Беларуская'),
    Language(code: 'bs', name: 'Bosnian', nativeName: 'Bosanski'),
    Language(code: 'bg', name: 'Bulgarian', nativeName: 'Български'),
    Language(code: 'ca', name: 'Catalan', nativeName: 'Català'),
    Language(code: 'hr', name: 'Croatian', nativeName: 'Hrvatski'),
    Language(code: 'et', name: 'Estonian', nativeName: 'Eesti'),
    Language(code: 'gl', name: 'Galician', nativeName: 'Galego'),
    Language(code: 'ka', name: 'Georgian', nativeName: 'ქართული'),
    Language(code: 'ht', name: 'Haitian Creole', nativeName: 'Kreyòl ayisyen'),
    Language(code: 'is', name: 'Icelandic', nativeName: 'Íslenska'),
    Language(code: 'ga', name: 'Irish', nativeName: 'Gaeilge'),
    Language(code: 'lv', name: 'Latvian', nativeName: 'Latviešu'),
    Language(code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių'),
    Language(code: 'mk', name: 'Macedonian', nativeName: 'Македонски'),
    Language(code: 'mt', name: 'Maltese', nativeName: 'Malti'),
    Language(code: 'ne', name: 'Nepali', nativeName: 'नेपाली'),
    Language(code: 'sk', name: 'Slovak', nativeName: 'Slovenčina'),
    Language(code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina'),
    Language(code: 'sr', name: 'Serbian', nativeName: 'Српски'),
    Language(code: 'tl', name: 'Filipino', nativeName: 'Filipino'),
    Language(code: 'uz', name: 'Uzbek', nativeName: 'Oʻzbek'),
    Language(code: 'cy', name: 'Welsh', nativeName: 'Cymraeg'),
    Language(code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá'),
    Language(code: 'zu', name: 'Zulu', nativeName: 'isiZulu'),
  ];

  @override
  bool operator ==(Object other) => other is Language && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => name;
}
