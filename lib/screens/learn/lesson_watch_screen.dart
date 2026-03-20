import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

/// RLO Type 1: Interactive Video Demonstration
/// A Reusable Learning Object that presents sign language demonstrations
/// with replay and slow-motion controls. Learners observe handshape,
/// placement, movement, and facial expression details.
/// Bloom's Taxonomy Level: Remember & Understand
/// UDL: Multiple means of representation (visual + text descriptions)
class LessonWatchScreen extends StatelessWidget {
  final String lessonTitle;
  final String lessonId;

  const LessonWatchScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    final hasVideo = LessonVideoMap.hasVideo(lessonId);
    final correctVideoPath = LessonVideoMap.correctVideo(lessonId);
    final extraVideoPath = LessonVideoMap.extraVideo(lessonId);

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 1 / 6,
              onClose: () => Navigator.popUntil(
                  context,
                  (route) =>
                      route.settings.name == '/main' || route.isFirst),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lessonTitle,
                  style: const TextStyle(
                      color: Color(0xFF9E9E9E), fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Watch & Notice',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // ── Primary video ──
                    if (hasVideo && correctVideoPath != null)
                      SignlyVideoPlayer(
                        assetPath: correctVideoPath,
                        height: 220,
                        label: 'Correct Sign',
                      )
                    else
                      Stack(
                        children: [
                          const VideoPlaceholder(
                              height: 220, label: 'Sign demonstration'),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Row(
                              children: [
                                _buildVideoControl(Icons.replay, 'Replay'),
                                const SizedBox(width: 8),
                                _buildVideoControl(
                                    Icons.slow_motion_video, 'Slow'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    // ── Extra video (e.g. Goodbye for u1l1) ──
                    if (extraVideoPath != null) ...[
                      const Text(
                        'Additional Sign',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      SignlyVideoPlayer(
                        assetPath: extraVideoPath,
                        height: 180,
                        label: _extraLabel,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Sign details ──
                    const Text(
                      'Sign Details',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.pan_tool, 'Handshape',
                        'Open hand, fingers together'),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.place, 'Placement',
                        'Starts near the forehead'),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.swap_horiz, 'Movement',
                        'Hand moves away from forehead'),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.face, 'Facial Expression',
                        'Friendly, eyebrows slightly raised'),
                    const SizedBox(height: 24),

                    // ── Observation prompt ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFF2196F3)
                                .withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Think about it',
                            style: TextStyle(
                                color: Color(0xFF2196F3),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'What do you notice first about this sign? Pay attention to the hand shape and where it starts.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SignlyBottomButton(
              label: 'Next',
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/lesson-recognition',
                    arguments: {
                      'lessonTitle': lessonTitle,
                      'lessonId': lessonId,
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Label shown on the extra video for the current lesson.
  String get _extraLabel {
    if (lessonId == 'u1l1') return 'Goodbye';
    return 'Extra Sign';
  }

  static Widget _buildVideoControl(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  static Widget _buildDetailRow(
      IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2196F3), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFF9E9E9E), fontSize: 12)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
