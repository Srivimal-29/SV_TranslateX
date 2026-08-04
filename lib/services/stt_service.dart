import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (error) => debugPrint('STT Error: $error'),
        onStatus: (status) => debugPrint('STT Status: $status'),
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('STT Initialization Failed: $e');
      return false;
    }
  }

  Future<void> startListening({
    required Function(String text) onResult,
    required VoidCallback onDone,
    String languageCode = 'en_US',
  }) async {
    final hasInitialized = await initialize();
    if (!hasInitialized) return;

    try {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
          if (result.finalResult) {
            onDone();
          }
        },
        localeId: languageCode,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('STT Listen Failed: $e');
      onDone();
    }
  }

  Future<void> stopListening() async {
    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
    } catch (e) {
      debugPrint('STT Stop Failed: $e');
    }
  }
}
