class TranslationHistory {
  final String id;
  final String sourceText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final String sourceLangName;
  final String targetLangName;
  final DateTime timestamp;

  TranslationHistory({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    required this.sourceLangName,
    required this.targetLangName,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceText': sourceText,
        'translatedText': translatedText,
        'sourceLang': sourceLang,
        'targetLang': targetLang,
        'sourceLangName': sourceLangName,
        'targetLangName': targetLangName,
        'timestamp': timestamp.toIso8601String(),
      };

  factory TranslationHistory.fromJson(Map<String, dynamic> json) =>
      TranslationHistory(
        id: json['id'] as String,
        sourceText: json['sourceText'] as String,
        translatedText: json['translatedText'] as String,
        sourceLang: json['sourceLang'] as String,
        targetLang: json['targetLang'] as String,
        sourceLangName: json['sourceLangName'] as String,
        targetLangName: json['targetLangName'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
