import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

class LessonCameraScreen extends StatefulWidget {
  final String unitTitle;
  final String lessonTitle;
  final String lessonId;
  final int signIndex;
  final bool isReview;

  const LessonCameraScreen({
    super.key,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonId,
    this.signIndex = 0,
    this.isReview = false,
  });

  @override
  State<LessonCameraScreen> createState() => _LessonCameraScreenState();
}

class _LessonCameraScreenState extends State<LessonCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _cameraError;

  late final String _signName;
  late final String? _detectionLabel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lesson = LessonUnit.findLesson(widget.lessonId);
    _signName = (lesson != null && widget.signIndex < lesson.signs.length)
        ? lesson.signs[widget.signIndex]
        : '';
    _detectionLabel = SignContent.forSign(_signName)?.detectionLabel;
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
      _isCameraReady = false;
      _cameraController?.dispose();
      _cameraController = null;
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _cameraError = 'No cameras available');
        return;
      }
      final sorted = [
        ...cameras.where((c) => c.lensDirection == CameraLensDirection.front),
        ...cameras.where((c) => c.lensDirection != CameraLensDirection.front),
      ];
      for (final cam in sorted) {
        for (final res in [ResolutionPreset.medium, ResolutionPreset.low]) {
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

  void _onContinue() {
    // In review mode, just pop back to the reflection screen
    if (widget.isReview) {
      Navigator.pop(context);
      return;
    }

    // Check if there is a next sign in this lesson
    final lesson = LessonUnit.findLesson(widget.lessonId);
    if (lesson != null && widget.signIndex + 1 < lesson.signs.length) {
      // Advance to the next sign's Watch screen
      Navigator.pushReplacementNamed(context, '/lesson-watch', arguments: {
        'unitTitle': widget.unitTitle,
        'lessonTitle': widget.lessonTitle,
        'lessonId': widget.lessonId,
        'signIndex': widget.signIndex + 1,
        'isReview': false,
      });
    } else {
      // All signs done — go to reflection
      Navigator.pushReplacementNamed(context, '/lesson-reflection', arguments: {
        'unitTitle': widget.unitTitle,
        'lessonTitle': widget.lessonTitle,
        'lessonId': widget.lessonId,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = LessonUnit.findLesson(widget.lessonId);
    final totalSigns = lesson?.signs.length ?? 1;
    final youtubeId = SignContent.youtubeIdForSign(_signName);

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: LessonProgressBar(
            progress: 5 / 5,
            onClose: () => Navigator.popUntil(
                context, (r) => r.settings.name == '/main' || r.isFirst),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [


            // Breadcrumb + sign indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.lessonTitle,
                        style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 13),
                        overflow: TextOverflow.ellipsis),
                  ),
                  if (totalSigns > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.isReview
                            ? const Color(0xFFFF9800).withOpacity(0.15)
                            : const Color(0xFF2196F3).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.isReview
                            ? 'Reviewing · $_signName'
                            : 'Sign ${widget.signIndex + 1} of $totalSigns · $_signName',
                        style: TextStyle(
                          color: widget.isReview
                              ? const Color(0xFFFF9800)
                              : const Color(0xFF2196F3),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Try it: $_signName',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _detectionLabel != null
                          ? 'Replicate the "$_signName" sign shown below'
                          : 'Replicate the sign shown below using the live camera',
                      style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Reference video
                    _buildGifBox(youtubeId),
                    const SizedBox(height: 20),

                    // Live camera
                    const Text('Your Camera',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    _buildLiveCameraFeed(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SignlyBottomButton(
              label: widget.isReview ? 'Done Reviewing' : 'Continue',
              onPressed: _onContinue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGifBox(String? youtubeId) {
    if (youtubeId != null) {
      return SignlyYouTubePlayer(
        videoId: youtubeId,
        label: '$_signName demonstration',
      );
    }
    return VideoPlaceholder(height: 220, label: '$_signName sign');
  }

  Widget _gifPlaceholder() {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pan_tool_outlined, color: const Color(0xFF2196F3), size: 48),
          const SizedBox(height: 12),
          Text(
            _signName.isNotEmpty ? '$_signName sign' : 'Sign demonstration',
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          const Text('GIF coming soon',
              style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLiveCameraFeed() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A)),
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
                    const Icon(Icons.videocam_off, color: const Color(0xFFE53935), size: 40),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(_cameraError!,
                          style: const TextStyle(
                              color: const Color(0xFF9E9E9E), fontSize: 13),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              )
            else
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: const Color(0xFF2196F3)),
                    SizedBox(height: 12),
                    Text('Starting camera...',
                        style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 13)),
                  ],
                ),
              ),
            if (_isCameraReady)
              Positioned(
                top: 10, right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                            color: const Color(0xFF4CAF50), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      const Text('LIVE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}