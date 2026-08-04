import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;
  static bool _isSpeaking = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });
    _isInitialized = true;
  }

  static Future<void> speak(String text, String langCode) async {
    await initialize();
    if (_isSpeaking) {
      await stop();
    }
    await _flutterTts.setLanguage(_mapLangCode(langCode));
    _isSpeaking = true;
    await _flutterTts.speak(text);
  }

  static Future<void> stop() async {
    _isSpeaking = false;
    await _flutterTts.stop();
  }

  static bool get isSpeaking => _isSpeaking;

  static String _mapLangCode(String code) {
    const Map<String, String> localeMap = {
      'zh': 'zh-CN',
      'en': 'en-US',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'it': 'it-IT',
      'pt': 'pt-PT',
      'ru': 'ru-RU',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'ar': 'ar-SA',
      'hi': 'hi-IN',
      'tr': 'tr-TR',
      'vi': 'vi-VN',
      'th': 'th-TH',
      'pl': 'pl-PL',
      'nl': 'nl-NL',
      'sv': 'sv-SE',
      'da': 'da-DK',
      'no': 'nb-NO',
      'fi': 'fi-FI',
      'el': 'el-GR',
      'cs': 'cs-CZ',
      'hu': 'hu-HU',
      'ro': 'ro-RO',
      'uk': 'uk-UA',
      'id': 'id-ID',
      'ms': 'ms-MY',
      'he': 'he-IL',
    };
    return localeMap[code] ?? code;
  }
}
