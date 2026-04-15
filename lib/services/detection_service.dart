import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Result of a sign language detection request.
class DetectionResult {
  final String detectedSign;
  final double confidence;
  final bool? isCorrect;
  final List<Map<String, dynamic>> allDetections;

  const DetectionResult({
    required this.detectedSign,
    required this.confidence,
    this.isCorrect,
    this.allDetections = const [],
  });

  /// Whether a sign was actually detected (not "none" or "error").
  bool get hasDetection =>
      detectedSign != 'none' && detectedSign != 'error';

  /// Confidence as a percentage string (e.g., "87%").
  String get confidencePercent =>
      '${(confidence * 100).toInt()}%';

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      detectedSign: json['detected_sign'] as String? ?? 'none',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      isCorrect: json['is_correct'] as bool?,
      allDetections: (json['all_detections'] as List<dynamic>?)
              ?.map((d) => Map<String, dynamic>.from(d as Map))
              .toList() ??
          [],
    );
  }

  /// Empty result for initial state.
  static const empty = DetectionResult(
    detectedSign: 'none',
    confidence: 0.0,
  );
}

/// Service that communicates with the Signly FastAPI backend
/// to perform sign language detection using YOLO11.
class DetectionService {
  final http.Client _client = http.Client();

  /// Check if the backend server is reachable and the model is loaded.
  Future<bool> checkHealth() async {
    try {
      final response = await _client
          .get(Uri.parse('${ApiConfig.baseUrl}/health'))
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'ok';
      }
      return false;
    } catch (e) {
      return false;
    }
  }


  Future<DetectionResult> detectSign(
    Uint8List imageBytes, {
    String? expectedSign,
  }) async {
    try {
      final base64Image = base64Encode(imageBytes);

      // Build request body
      final body = <String, dynamic>{
        'image': base64Image,
      };
      if (expectedSign != null) {
        body['expected_sign'] = expectedSign;
      }

      // POST to /detect
      final response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}/detect'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DetectionResult.fromJson(data);
      } else {
        return const DetectionResult(
          detectedSign: 'error',
          confidence: 0.0,
        );
      }
    } catch (e) {
      return const DetectionResult(
        detectedSign: 'error',
        confidence: 0.0,
      );
    }
  }

  // Clean up the HTTP client.
  void dispose() {
    _client.close();
  }
}
