import 'package:flutter/material.dart';

/// Lesson Summary Screen - Measurable Learning Outcomes
/// Displays completion statistics and performance metrics providing
/// measurable evidence of learning. Shows signs learned count,
/// recognition accuracy %, context practice results, and areas
/// to improve. Offers guided next steps for continued learning.
/// UDL: Self-regulation through progress awareness and goal-setting.
class LessonSummaryScreen extends StatelessWidget {
  final String lessonTitle;
  final String lessonId;

  const LessonSummaryScreen({
    super.key,
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
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Completion icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 48),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Lesson Complete!',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lessonTitle,
                      style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    // Summary card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('Signs learned', '5'),
                          const Divider(color: Color(0xFF3A3A3A), height: 24),
                          _buildSummaryRow('Recognition accuracy', '80%'),
                          const Divider(color: Color(0xFF3A3A3A), height: 24),
                          _buildSummaryRow('Context practice', 'Correct'),
                          const Divider(color: Color(0xFF3A3A3A), height: 24),
                          _buildSummaryRow('Camera practice', 'Completed'),
                          const Divider(color: Color(0xFF3A3A3A), height: 24),
                          _buildSummaryRow('Area to improve', 'Movement'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Suggested next actions
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What\'s Next?',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildNextAction(
                      context,
                      Icons.play_circle_outline,
                      'Continue to Next Lesson',
                      'My Name Is...',
                      true,
                    ),
                    const SizedBox(height: 8),
                    _buildNextAction(
                      context,
                      Icons.replay,
                      'Review Mistakes',
                      'Practice signs you missed',
                      false,
                    ),
                    const SizedBox(height: 8),
                    _buildNextAction(
                      context,
                      Icons.refresh,
                      'Practice Again',
                      'Redo this lesson for mastery',
                      false,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) {
                      return route.settings.name == '/main' || route.isFirst;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  static Widget _buildNextAction(BuildContext context, IconData icon, String title, String subtitle, bool highlighted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: highlighted
            ? const Color(0xFF2196F3).withOpacity(0.1)
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted
              ? const Color(0xFF2196F3).withOpacity(0.4)
              : const Color(0xFF3A3A3A),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: highlighted ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E), size: 22),
        ],
      ),
    );
  }
}
