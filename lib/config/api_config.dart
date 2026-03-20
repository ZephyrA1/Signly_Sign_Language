import 'package:flutter/foundation.dart' show kIsWeb;

/// Configuration for the Signly detection backend API.
///
/// For Android emulator: uses 10.0.2.2 (maps to host localhost).
/// For physical device on same WiFi: override with your PC's local IP.
/// For iOS simulator / Web / Desktop: uses localhost.
class ApiConfig {
  /// Base URL of the FastAPI detection server.
  /// Automatically picks the right host based on the platform.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8001';
    // For non-web, conditionally import dart:io
    return _nativeBaseUrl;
  }

  static String get _nativeBaseUrl {
    try {
      // Android emulator needs 10.0.2.2 to reach host localhost
      return 'http://10.0.2.2:8001';
    } catch (_) {
      return 'http://localhost:8001';
    }
  }

  /// How often to capture a frame and send for detection (milliseconds).
  static const int captureIntervalMs = 2000;

  /// Minimum confidence score to display a detection result.
  static const double confidenceThreshold = 0.4;

  /// Minimum confidence for a detection to count as "correct".
  static const double correctnessThreshold = 0.5;

  /// HTTP request timeout in seconds.
  static const int requestTimeoutSeconds = 10;
}
