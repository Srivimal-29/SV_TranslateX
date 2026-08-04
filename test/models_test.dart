import 'package:flutter_test/flutter_test.dart';
import 'package:translator_app/models/language.dart';
import 'package:translator_app/models/translation_history.dart';

void main() {
  group('Language Model', () {
    test('autoDetect has code "auto"', () {
      expect(Language.autoDetect.code, equals('auto'));
    });

    test('supportedLanguages is not empty', () {
      expect(Language.supportedLanguages, isNotEmpty);
    });

    test('supportedLanguages contains English', () {
      final en = Language.supportedLanguages.any((l) => l.code == 'en');
      expect(en, isTrue);
    });

    test('supportedLanguages contains 50+ languages', () {
      expect(Language.supportedLanguages.length, greaterThan(50));
    });
  });

  group('TranslationHistory Model', () {
    test('toJson and fromJson round-trip', () {
      final original = TranslationHistory(
        id: '1234',
        sourceText: 'Hello',
        translatedText: 'Bonjour',
        sourceLang: 'en',
        targetLang: 'fr',
        sourceLangName: 'English',
        targetLangName: 'French',
        timestamp: DateTime(2026, 1, 1, 12, 0),
      );

      final json = original.toJson();
      final restored = TranslationHistory.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.sourceText, equals(original.sourceText));
      expect(restored.translatedText, equals(original.translatedText));
      expect(restored.sourceLang, equals(original.sourceLang));
      expect(restored.targetLang, equals(original.targetLang));
      expect(restored.sourceLangName, equals(original.sourceLangName));
      expect(restored.targetLangName, equals(original.targetLangName));
    });

    test('timestamp is preserved across json round-trip', () {
      final now = DateTime(2026, 8, 4, 15, 0);
      final entry = TranslationHistory(
        id: 'ts-test',
        sourceText: 'test',
        translatedText: 'essai',
        sourceLang: 'en',
        targetLang: 'fr',
        sourceLangName: 'English',
        targetLangName: 'French',
        timestamp: now,
      );

      final restored = TranslationHistory.fromJson(entry.toJson());
      expect(restored.timestamp.millisecondsSinceEpoch,
          equals(now.millisecondsSinceEpoch));
    });
  });
}
