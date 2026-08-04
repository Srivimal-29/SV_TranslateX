import 'package:flutter_test/flutter_test.dart';
import 'package:translator_app/services/translation_service.dart';

void main() {
  group('TranslationService', () {
    test('returns empty string for empty input', () async {
      final result = await TranslationService.translate(
        text: '',
        sourceLang: 'en',
        targetLang: 'fr',
      );
      expect(result['translation'], equals(''));
    });

    test('returns empty string for whitespace-only input', () async {
      final result = await TranslationService.translate(
        text: '   ',
        sourceLang: 'en',
        targetLang: 'fr',
      );
      expect(result['translation'], equals(''));
    });

    test('returns a non-empty result for valid text', () async {
      final result = await TranslationService.translate(
        text: 'Hello',
        sourceLang: 'en',
        targetLang: 'es',
      );
      expect(result['translation'], isNotEmpty);
      expect(result['detectedLanguage'], isNotNull);
    }, timeout: const Timeout(Duration(seconds: 15)));

    test('handles auto-detect source language', () async {
      final result = await TranslationService.translate(
        text: 'Good morning',
        sourceLang: 'auto',
        targetLang: 'fr',
      );
      expect(result['translation'], isNotEmpty);
    }, timeout: const Timeout(Duration(seconds: 15)));
  });
}
