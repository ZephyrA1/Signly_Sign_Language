import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

/// RLO Type 5 (Reused): Camera-Based Production Practice
/// Independent practice mode — user picks any of the 10 signs to practice.
/// Camera feed lets students see themselves while practising.
class CameraPracticeScreen extends StatefulWidget {
  const CameraPracticeScreen({super.key});

  @override
  State<CameraPracticeScreen> createState() => _CameraPracticeScreenState();
}

class _CameraPracticeScreenState extends State<CameraPracticeScreen>
    with WidgetsBindingObserver {
  // Available signs
  final List<String> _signs =
      VocabularyItem.sampleItems.map((v) => v.sign).toList();
  late String _selectedSign;

  // Camera
  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _cameraError;

  // Recording state
  bool _isRecording = false;
  bool _signRecorded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedSign = _signs.isNotEmpty ? _signs.first : 'Hello';
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
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
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
    if (_signRecorded || _isRecording) return;

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
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Camera Practice', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select a sign to practice',
                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
              const SizedBox(height: 12),

              // Sign selector
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _signs.map((sign) {
                    final selected = sign == _selectedSign;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedSign = sign);
                          _resetRecording();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF2196F3).withOpacity(0.2) : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? const Color(0xFF2196F3) : const Color(0xFF3A3A3A)),
                          ),
                          child: Text(sign, style: TextStyle(color: selected ? const Color(0xFF2196F3) : Colors.white, fontSize: 13)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Model preview
              _buildModelPreview(),
              const SizedBox(height: 20),

              // Camera preview
              _buildCameraPreview(),
              const SizedBox(height: 16),

              // Controls
              _buildControls(),

              // Results
              if (_signRecorded) ...[
                const SizedBox(height: 20),
                _buildResultPanel(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => showSignlySnackBar(context, 'Result saved!'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2196F3),
                          side: const BorderSide(color: Color(0xFF2196F3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Save Result'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => showSignlySnackBar(context, 'Added to review!'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF9800),
                          side: const BorderSide(color: Color(0xFFFF9800)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Add to Review'),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelPreview() {
    final signToLesson = <String, String>{'Hello': 'u1l1'};
    final lessonId = signToLesson[_selectedSign];
    final videoPath = lessonId != null ? LessonVideoMap.correctVideo(lessonId) : null;

    if (videoPath != null) {
      return Container(
        width: double.infinity, height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 160,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(13), bottomLeft: Radius.circular(13)),
                child: SignlyMiniVideoPlayer(assetPath: videoPath, autoPlay: false, height: 140),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Model: $_selectedSign', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('Tap to watch', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return VideoPlaceholder(height: 140, label: 'Model sign: $_selectedSign');
  }

  Widget _buildCameraPreview() {
    return Container(
      width: double.infinity, height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _signRecorded ? const Color(0xFF4CAF50) : (_isRecording ? const Color(0xFFE53935) : const Color(0xFF3A3A3A)),
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
              Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.videocam_off, color: Color(0xFFE53935), size: 40),
                const SizedBox(height: 8),
                Text(_cameraError!, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13), textAlign: TextAlign.center),
              ]))
            else
              const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircularProgressIndicator(color: Color(0xFF2196F3)),
                SizedBox(height: 12),
                Text('Starting camera...', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
              ])),

            // Recording indicator
            if (_isRecording)
              Positioned(top: 10, right: 10, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE53935).withOpacity(0.8), borderRadius: BorderRadius.circular(6)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.fiber_manual_record, color: Colors.white, size: 10),
                  SizedBox(width: 4),
                  Text('RECORDING', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ]),
              )),

            // Success badge
            if (_signRecorded)
              Positioned(top: 10, right: 10, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.8), borderRadius: BorderRadius.circular(6)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('RECORDED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ]),
              )),

            // Recording overlay
            if (_isRecording)
              Positioned(bottom: 0, left: 0, right: 0, child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                color: Colors.black.withOpacity(0.6),
                child: Text('Recording "$_selectedSign"...', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              )),

            // Success overlay
            if (_signRecorded)
              Positioned(bottom: 0, left: 0, right: 0, child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                color: const Color(0xFF4CAF50).withOpacity(0.85),
                child: const Text('Sign recorded successfully!', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              )),
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
          onTap: () {
            if (_signRecorded) { _resetRecording(); return; }
            _onRecordPressed();
          },
          child: Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: _signRecorded ? const Color(0xFF4CAF50) : (_isRecording ? const Color(0xFFFF9800) : const Color(0xFFE53935)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _signRecorded ? Icons.check : (_isRecording ? Icons.hourglass_top : Icons.fiber_manual_record),
              color: Colors.white, size: 28,
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: _resetRecording,
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: const Color(0xFF2A2A2A), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF3A3A3A))),
            child: const Icon(Icons.replay, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildResultPanel() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
              SizedBox(width: 8),
              Text('Practice Complete', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          FeedbackItem(label: 'Sign Practised', status: _selectedSign, isGood: true),
          const FeedbackItem(label: 'Status', status: 'Sign Recorded', isGood: true),
          const FeedbackItem(label: 'Tip', status: 'Try another sign to keep practising!', isGood: true),
        ],
      ),
    );
  }
}
