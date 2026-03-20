import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

/// Lesson Introduction Screen - Sets learning objectives and expectations.
/// Implements UDL Principle: Multiple Means of Engagement
/// - Clearly states learning goals (transparency of objectives)
/// - Shows skills to be practiced (Recognition, Production, Context)
/// - Previews all 6 lesson steps (reduces anxiety, promotes self-regulation)
/// - Displays estimated time for learner planning
class LessonIntroScreen extends StatelessWidget {
  final String unitTitle;
  final String lessonTitle;
  final String lessonId;

  const LessonIntroScreen({
    super.key,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      unitTitle,
                      style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lesson title
                    Text(
                      lessonTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Goal statement
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
                        children: const [
                          Text(
                            'Learning Goal',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'In this lesson, you will learn 5 greeting signs and use them in basic introductions.',
                            style: TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Skills practiced
                    const Text(
                      'Skills Practiced',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildSkillChip(Icons.remove_red_eye, 'Recognition'),
                        const SizedBox(width: 8),
                        _buildSkillChip(Icons.camera_alt, 'Production'),
                        const SizedBox(width: 8),
                        _buildSkillChip(Icons.chat, 'Context Use'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Estimated time
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.timer, color: Color(0xFF9E9E9E), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Estimated time: 8-10 min',
                            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Lesson steps preview
                    const Text(
                      'Lesson Steps',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    _buildLessonStep(1, 'Watch & Notice', 'Observe the sign demonstration', Icons.play_circle_outline),
                    _buildLessonStep(2, 'Recognize', 'Identify the sign correctly', Icons.quiz_outlined),
                    _buildLessonStep(3, 'Apply in Context', 'Choose the right sign for a situation', Icons.chat_outlined),
                    _buildLessonStep(4, 'Error Analysis', 'Spot mistakes in sign performance', Icons.search),
                    _buildLessonStep(5, 'Camera Practice', 'Try the sign yourself', Icons.camera_alt_outlined),
                    _buildLessonStep(6, 'Reflect', 'Think about what you learned', Icons.lightbulb_outline),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Start Lesson button
            SignlyBottomButton(
              label: 'Start Lesson',
              onPressed: () {
                Navigator.pushNamed(context, '/lesson-watch', arguments: {
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

  static Widget _buildSkillChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2196F3), size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildLessonStep(int number, String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: const Color(0xFF9E9E9E), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
