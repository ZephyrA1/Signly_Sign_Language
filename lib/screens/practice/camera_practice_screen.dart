import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

class CameraPracticeScreen extends StatefulWidget {
  const CameraPracticeScreen({super.key});

  @override
  State<CameraPracticeScreen> createState() => _CameraPracticeScreenState();
}

class _CameraPracticeScreenState extends State<CameraPracticeScreen>
    with WidgetsBindingObserver {

  final List<String> _signs = () {
    const priority = ['Mother', 'Father', 'Sister'];
    final rest = VocabularyItem.sampleItems
        .map((v) => v.sign)
        .where((s) => !priority.contains(s))
        .toList();
    return [...priority, ...rest];
  }();

  static const _availableSigns = {'Mother', 'Father', 'Sister'};
  late String _selectedSign;

  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedSign = 'Mother';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Select a sign to practice',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
              ),
              const SizedBox(height: 12),

              // Sign selector
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: _signs.map((sign) {
                    final selected = sign == _selectedSign;
                    final available = _availableSigns.contains(sign);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Opacity(
                        opacity: available ? 1.0 : 0.35,
                        child: GestureDetector(
                          onTap: available
                              ? () => setState(() => _selectedSign = sign)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF2196F3).withOpacity(0.2)
                                  : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF2196F3)
                                    : const Color(0xFF3A3A3A),
                              ),
                            ),
                            child: Text(sign,
                                style: TextStyle(
                                  color: selected
                                      ? const Color(0xFF2196F3)
                                      : Colors.white,
                                  fontSize: 13,
                                )),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Model preview
                    _buildModelPreview(),
                    const SizedBox(height: 20),

                    // Live camera feed
                    _buildCameraFeed(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelPreview() {
    final videoPath = LessonVideoMap.correctVideo(_selectedSign);
    if (videoPath != null) {
      return Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(children: [
          SizedBox(
            width: 160,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13)),
              child: SignlyMiniVideoPlayer(
                key: ValueKey(_selectedSign),
                assetPath: videoPath,
                autoPlay: false,
                height: 140,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Model: $_selectedSign',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                const Text('Tap to watch',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
              ],
            ),
          ),
        ]),
      );
    }
    return VideoPlaceholder(height: 140, label: 'Model: $_selectedSign');
  }

  Widget _buildCameraFeed() {
    return Container(
      width: double.infinity,
      height: 320,
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
                    const Icon(Icons.videocam_off,
                        color: Color(0xFFE53935), size: 40),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(_cameraError!,
                          style: const TextStyle(
                              color: Color(0xFF9E9E9E), fontSize: 13),
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
                    CircularProgressIndicator(color: Color(0xFF2196F3)),
                    SizedBox(height: 12),
                    Text('Starting camera...',
                        style: TextStyle(
                            color: Color(0xFF9E9E9E), fontSize: 13)),
                  ],
                ),
              ),

            // LIVE badge
            if (_isCameraReady)
              Positioned(
                top: 10, right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    const Text('LIVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}