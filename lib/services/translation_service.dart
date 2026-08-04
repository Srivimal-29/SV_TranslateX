import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  // High quality Google Translate engine (free GTX endpoint)
  static const String _primaryUrl = 'https://translate.googleapis.com/translate_a/single';
  static const String _fallbackUrl = 'https://api.mymemory.translated.net/get';

  static Future<Map<String, String>> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      return {'translation': '', 'detectedLanguage': sourceLang};
    }

    // Try Google Translate GTX Engine first for top accuracy
    try {
      final uri = Uri.parse(_primaryUrl).replace(queryParameters: {
        'client': 'gtx',
        'sl': sourceLang,
        'tl': targetLang,
        'dt': 't',
        'q': cleanText,
      });

      final response = await http.get(uri).timeout(
        const Duration(seconds: 8),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0] is List) {
          final List<dynamic> sentences = data[0];
          final StringBuffer translationBuffer = StringBuffer();
          for (final sentence in sentences) {
            if (sentence is List && sentence.isNotEmpty && sentence[0] != null) {
              translationBuffer.write(sentence[0].toString());
            }
          }

          String detected = sourceLang;
          if (data.length > 2 && data[2] is String) {
            detected = data[2];
          }

          final resultText = translationBuffer.toString();
          if (resultText.isNotEmpty) {
            return {
              'translation': resultText,
              'detectedLanguage': detected,
            };
          }
        }
      }
    } catch (_) {
      // Continue to fallback
    }

    // Fallback engine: MyMemory
    try {
      final langPair = sourceLang == 'auto'
          ? 'en|$targetLang'
          : '$sourceLang|$targetLang';

      final fallbackUri = Uri.parse(_fallbackUrl).replace(queryParameters: {
        'q': cleanText,
        'langpair': langPair,
      });

      final response = await http.get(fallbackUri).timeout(
        const Duration(seconds: 8),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final responseData = data['responseData'] as Map<String, dynamic>?;
        if (responseData != null) {
          final fallbackResult = responseData['translatedText'] as String? ?? '';
          if (fallbackResult.isNotEmpty) {
            return {
              'translation': fallbackResult,
              'detectedLanguage': sourceLang,
            };
          }
        }
      }
    } catch (_) {}

    return {
      'translation': 'Translation unavailable. Please check your network connection.',
      'detectedLanguage': sourceLang,
    };
  }
}
