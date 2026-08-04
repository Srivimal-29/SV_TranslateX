import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/providers/translator_provider.dart';
import 'package:translator_app/models/language.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TranslatorProvider', () {
    late TranslatorProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      provider = TranslatorProvider();
      // Allow async _loadHistory() to complete
      await Future.delayed(Duration.zero);
    });

    test('initial state is correct', () {
      expect(provider.inputText, equals(''));
      expect(provider.outputText, equals(''));
      expect(provider.status, equals(TranslationStatus.idle));
      expect(provider.isLoading, isFalse);
      expect(provider.isListening, isFalse);
      expect(provider.isSpeaking, isFalse);
      expect(provider.isOffline, isFalse);
      expect(provider.history, isEmpty);
    });

    test('setInputText updates inputText', () {
      provider.setInputText('Hello World');
      expect(provider.inputText, equals('Hello World'));
    });

    test('setInputText clears output when empty', () {
      provider.setInputText('Hello');
      provider.setInputText('');
      expect(provider.outputText, equals(''));
      expect(provider.status, equals(TranslationStatus.idle));
    });

    test('setSourceLang updates source language', () {
      final lang = Language.supportedLanguages.firstWhere((l) => l.code == 'es');
      provider.setSourceLang(lang);
      expect(provider.sourceLang.code, equals('es'));
    });

    test('setTargetLang updates target language', () {
      final lang = Language.supportedLanguages.firstWhere((l) => l.code == 'fr');
      provider.setTargetLang(lang);
      expect(provider.targetLang.code, equals('fr'));
    });

    test('swapLanguages does nothing when source is auto-detect', () {
      provider.setSourceLang(Language.autoDetect);
      provider.swapLanguages();
      expect(provider.sourceLang.code, equals('auto'));
    });

    test('swapLanguages swaps source and target correctly', () {
      final en = Language.supportedLanguages.firstWhere((l) => l.code == 'en');
      final fr = Language.supportedLanguages.firstWhere((l) => l.code == 'fr');
      provider.setSourceLang(en);
      provider.setTargetLang(fr);
      provider.swapLanguages();
      expect(provider.sourceLang.code, equals('fr'));
      expect(provider.targetLang.code, equals('en'));
    });

    test('setIsSpeaking updates speaking state', () {
      provider.setIsSpeaking(true);
      expect(provider.isSpeaking, isTrue);
      provider.setIsSpeaking(false);
      expect(provider.isSpeaking, isFalse);
    });

    test('translate does nothing for empty input', () async {
      provider.setInputText('');
      await provider.translate();
      expect(provider.status, equals(TranslationStatus.idle));
    });

    test('clearHistory removes all history entries', () async {
      await provider.clearHistory();
      expect(provider.history, isEmpty);
    });

    test('isOffline starts false', () {
      expect(provider.isOffline, isFalse);
    });

    test('history starts empty on fresh prefs', () {
      expect(provider.history, isEmpty);
    });
  });
}
