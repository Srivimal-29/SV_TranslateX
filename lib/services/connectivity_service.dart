import 'dart:io';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  /// Returns true if internet is reachable.
  static Future<bool> isOnline() async {
    // Web platform always returns true (browser handles connectivity)
    if (kIsWeb) return true;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
