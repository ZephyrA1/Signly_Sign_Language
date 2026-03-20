import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

/// RLO Type 5: Camera-Based Production Practice
/// Uses the device camera to let students practice signing.
/// Bloom's Taxonomy Level: Apply & Create
/// UDL: Multiple means of action & expression (kinesthetic learning)
class LessonCameraScreen extends StatefulWidget {
  final String lessonTitle;
  final String lessonId;

  const LessonCameraScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  State<LessonCameraScreen> createState() => _LessonCameraScreenState();
}

class _LessonCameraScreenState extends State<LessonCameraScreen>
    with WidgetsBindingObserver {
  // Camera
  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _cameraError;

  // Recording state
  bool _isRecording = false;
  bool _signRecorded = false;

  // Lesson
  late final String? _expectedSign;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _expectedSign = LessonSignMap.getExpectedSign(widget.lessonId);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraError = 'No cameras available');
        return;
      }

      final resolutions = [ResolutionPreset.medium, ResolutionPreset.low];
      final sorted = [
        ...cameras.where((c) => c.lensDirection == CameraLensDirection.front),
        ...cameras.where((c) => c.lensDirection != CameraLensDirection.front),
      ];

      for (final cam in sorted) {
        for (final res in resolutions) {
          try {
            _cameraController = CameraController(cam, res, enableAudio: false);
            await _cameraController!.initialize();
            if (mounted) setState(() => _isCameraReady = true);
            return;
          } catch (_) {
            await _cameraController?.dispose();
            _cameraController = null;
          }
        }
      }
      if (mounted) setState(() => _cameraError = 'Could not open any camera');
    } catch (e) {
      if (mounted) setState(() => _cameraError = 'Camera error: $e');
    }
  }

  void _onRecordPressed() {
    if (_signRecorded) return;

    setState(() => _isRecording = true);

    // Simulate a brief recording period then mark as recorded
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isRecording = false;
          _signRecorded = true;
        });
      }
    });
  }

  void _resetRecording() {
    setState(() {
      _isRecording = false;
      _signRecorded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelVideoPath = LessonVideoMap.correctVideo(widget.lessonId);

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 5 / 6,
              onClose: () => Navigator.popUntil(context,
                  (route) => route.settings.name == '/main' || route.isFirst),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Try the Sign Yourself',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      _expectedSign != null
                          ? 'Perform the "$_expectedSign" sign for the camera'
                          : 'Watch the model, then record yourself performing the sign',
                      style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Model sign preview
                    if (modelVideoPath != null)
                      _buildVideoModelPreview(modelVideoPath)
                    else
                      _buildPlaceholderModelPreview(),
                    const SizedBox(height: 20),

                    // Camera preview
                    _buildCameraPreview(),
                    const SizedBox(height: 16),

                    // Controls
                    _buildControls(),

                    // Feedback
                    if (_signRecorded) ...[
                      const SizedBox(height: 24),
                      _buildFeedbackPanel(),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (_signRecorded)
              SignlyBottomButton(
                label: 'Continue',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/lesson-reflection',
                      arguments: {
                        'lessonTitle': widget.lessonTitle,
                        'lessonId': widget.lessonId,
                      });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _signRecorded
              ? const Color(0xFF4CAF50)
              : (_isRecording ? const Color(0xFFE53935) : const Color(0xFF3A3A3A)),
          width: _signRecorded || _isRecording ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isCameraReady && _cameraController != null)
              CameraPreview(_cameraController!)
            else if (_cameraError != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam_off, color: Color(0xFFE53935), size: 40),
                    const SizedBox(height: 8),
                    Text(_cameraError!, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13), textAlign: TextAlign.center),
                  ],
                ),
              )
            else
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF2196F3)),
                    SizedBox(height: 12),
                    Text('Starting camera...', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                  ],
                ),
              ),

            // Recording indicator
            if (_isRecording)
              Positioned(
                top: 10, right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fiber_manual_record, color: Colors.white, size: 10),
                      SizedBox(width: 4),
                      Text('RECORDING', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

            // Success badge
            if (_signRecorded)
              Positioned(
                top: 10, right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('RECORDED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

            // Recording overlay message
            if (_isRecording)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  color: Colors.black.withOpacity(0.6),
                  child: const Text('Recording your sign...', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                ),
              ),

            // Success overlay
            if (_signRecorded)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  color: const Color(0xFF4CAF50).withOpacity(0.85),
                  child: const Text('Sign recorded successfully!', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _signRecorded ? null : _onRecordPressed,
          child: Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: _signRecorded
                  ? const Color(0xFF4CAF50)
                  : (_isRecording ? const Color(0xFFFF9800) : const Color(0xFFE53935)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _signRecorded ? Icons.check : (_isRecording ? Icons.hourglass_top : Icons.fiber_manual_record),
              color: Colors.white, size: 32,
            ),
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: _resetRecording,
          child: Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: const Icon(Icons.replay, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
              SizedBox(width: 8),
              Text('Great job!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          if (_expectedSign case final sign?)
            FeedbackItem(label: 'Sign Practised', status: sign, isGood: true),
          const FeedbackItem(label: 'Status', status: 'Sign Recorded', isGood: true),
          const FeedbackItem(label: 'Tip', status: 'Keep practising to improve!', isGood: true),
        ],
      ),
    );
  }

  Widget _buildVideoModelPreview(String videoPath) {
    return Container(
      width: double.infinity, height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(13), bottomLeft: Radius.circular(13)),
              child: SignlyMiniVideoPlayer(assetPath: videoPath, autoPlay: false, height: 120),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Model Sign', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                if (_expectedSign != null)
                  Text('Sign: $_expectedSign', style: const TextStyle(color: Color(0xFF2196F3), fontSize: 13)),
                const Text('Tap to watch', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderModelPreview() {
    return Container(
      width: double.infinity, height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            decoration: const BoxDecoration(
              color: Color(0xFF3A3A3A),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
            ),
            child: const Center(child: Icon(Icons.play_circle_outline, color: Color(0xFF9E9E9E), size: 36)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Model Sign', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                if (_expectedSign != null)
                  Text('Sign: $_expectedSign', style: const TextStyle(color: Color(0xFF2196F3), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
