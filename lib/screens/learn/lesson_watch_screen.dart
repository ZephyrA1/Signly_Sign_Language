import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

class LessonWatchScreen extends StatelessWidget {
  final String unitTitle;
  final String lessonTitle;
  final String lessonId;
  final int signIndex;
  final bool isReview;

  const LessonWatchScreen({
    super.key,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonId,
    this.signIndex = 0,
    this.isReview = false,
  });

  @override
  Widget build(BuildContext context) {
    final lesson = LessonUnit.findLesson(lessonId);
    final signName = (lesson != null && signIndex < lesson.signs.length)
        ? lesson.signs[signIndex]
        : '';
    final content = SignContent.forSign(signName);
    final totalSigns = lesson?.signs.length ?? 1;

    // Video: use lesson-level map for now; per-sign videos can be added later
    final videoPath = signIndex == 0 ? LessonVideoMap.correctVideo(lessonId) : null;

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 1 / 5,
              onClose: () => Navigator.popUntil(
                  context, (r) => r.settings.name == '/main' || r.isFirst),
            ),
            const SizedBox(height: 8),

            // Breadcrumb + sign indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(lessonTitle,
                        style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                        overflow: TextOverflow.ellipsis),
                  ),
                  if (totalSigns > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isReview
                            ? const Color(0xFFFF9800).withOpacity(0.15)
                            : const Color(0xFF2196F3).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isReview
                            ? 'Reviewing · $signName'
                            : 'Sign ${signIndex + 1} of $totalSigns · $signName',
                        style: TextStyle(
                          color: isReview
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
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Watch & Notice: $signName',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Video or placeholder
                    if (videoPath != null)
                      SignlyVideoPlayer(assetPath: videoPath, height: 220, label: 'Correct Sign')
                    else
                      VideoPlaceholder(height: 220, label: '$signName demonstration'),
                    const SizedBox(height: 16),

                    // Sign details
                    const Text('Sign Details',
                        style: TextStyle(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.pan_tool, 'Handshape',
                        content?.handshape ?? 'See demonstration above'),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.place, 'Placement',
                        content?.placement ?? 'See demonstration above'),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.swap_horiz, 'Movement',
                        content?.movement ?? 'See demonstration above'),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.face, 'Facial Expression',
                        content?.facialExpression ?? 'Natural and expressive'),
                    const SizedBox(height: 24),

                    // Think about it
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Think about it',
                              style: TextStyle(
                                  color: Color(0xFF2196F3),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(
                            content?.thinkAboutIt ??
                                'What do you notice first? Pay attention to where the hand starts and how it moves.',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15, height: 1.5),
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
                Navigator.pushReplacementNamed(context, '/lesson-recognition',
                    arguments: {
                      'unitTitle': unitTitle,
                      'lessonTitle': lessonTitle,
                      'lessonId': lessonId,
                      'signIndex': signIndex,
                      'isReview': isReview,
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2196F3), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}