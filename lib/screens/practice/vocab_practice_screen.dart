import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';

class VocabPracticeScreen extends StatefulWidget {
  final VocabularyItem item;

  const VocabPracticeScreen({super.key, required this.item});

  @override
  State<VocabPracticeScreen> createState() => _VocabPracticeScreenState();
}

class _VocabPracticeScreenState extends State<VocabPracticeScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _cameraError;
  bool _showTips = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  @override
  Widget build(BuildContext context) {
    final sign = widget.item;
    final gifPath = SignGifMap.gif(sign.sign);

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Practice: ${sign.sign}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          sign.category,
                          style: const TextStyle(
                              color: Color(0xFF9E9E9E), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // Toggle tips
                  GestureDetector(
                    onTap: () => setState(() => _showTips = !_showTips),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _showTips
                            ? const Color(0xFF2196F3).withOpacity(0.15)
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _showTips
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF3A3A3A),
                        ),
                      ),
                      child: Text(
                        _showTips ? 'Hide Tips' : 'Show Tips',
                        style: TextStyle(
                          color: _showTips
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF9E9E9E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Reference GIF ─────────────────────────────────
                    _buildGifBox(sign.sign, gifPath),
                    const SizedBox(height: 16),

                    // ── Quick tips (collapsible) ───────────────────────
                    if (_showTips) ...[
                      _buildTipRow(Icons.pan_tool_outlined, 'Handshape', sign.handshape),
                      const SizedBox(height: 6),
                      _buildTipRow(Icons.swap_horiz, 'Movement', sign.movement),
                      const SizedBox(height: 6),
                      _buildTipRow(Icons.place, 'Placement', sign.placement),
                      const SizedBox(height: 16),
                    ],

                    // ── Live camera ───────────────────────────────────
                    Row(children: [
                      const Text('Your Camera',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      if (_isCameraReady)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6, height: 6,
                                decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50),
                                    shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 5),
                              const Text('LIVE',
                                  style: TextStyle(
                                      color: Color(0xFF4CAF50),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ]),
                    const SizedBox(height: 10),
                    _buildLiveCameraFeed(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Bottom: done button ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Done Practising'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGifBox(String signName, String? gifPath) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (gifPath != null)
              Image.asset(gifPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _gifPlaceholder(signName))
            else
              _gifPlaceholder(signName),

            Positioned(
              top: 10, left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('REFERENCE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
              ),
            ),
            Positioned(
              bottom: 10, left: 10,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(signName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gifPlaceholder(String signName) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pan_tool_outlined,
              color: Color(0xFF2196F3), size: 48),
          const SizedBox(height: 12),
          Text(signName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          const Text('GIF coming soon',
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTipRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2196F3), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Color(0xFF9E9E9E), fontSize: 11)),
                Text(value,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveCameraFeed() {
    return Container(
      width: double.infinity,
      height: 340,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: _isCameraReady && _cameraController != null
            ? CameraPreview(_cameraController!)
            : _cameraError != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off,
                  color: Color(0xFFE53935), size: 40),
              const SizedBox(height: 8),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: Text(_cameraError!,
                    style: const TextStyle(
                        color: Color(0xFF9E9E9E), fontSize: 13),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        )
            : const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                  color: Color(0xFF2196F3)),
              SizedBox(height: 12),
              Text('Starting camera...',
                  style: TextStyle(
                      color: Color(0xFF9E9E9E), fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}