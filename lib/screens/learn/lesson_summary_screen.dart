import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../services/progress_service.dart';

class LessonSummaryScreen extends StatefulWidget {
  final String lessonTitle;
  final String lessonId;

  const LessonSummaryScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  State<LessonSummaryScreen> createState() => _LessonSummaryScreenState();
}

class _LessonSummaryScreenState extends State<LessonSummaryScreen> {
  @override
  void initState() {
    super.initState();
    _recordCompletion();
  }

  Future<void> _recordCompletion() async {
    final lesson = LessonUnit.findLesson(widget.lessonId);
    await ProgressService.instance.recordLessonCompleted(
      lessonId: widget.lessonId,
      signsLearned: lesson?.signs ?? [],
      recognitionTotal: lesson?.signs.length ?? 0,
      recognitionCorrect: lesson?.signs.length ?? 0,
      cameraTotal: lesson?.signs.length ?? 0,
      cameraCorrect: lesson?.signs.length ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLesson = LessonUnit.findLesson(widget.lessonId);
    final nextLesson = LessonUnit.nextLesson(widget.lessonId);
    final signCount = currentLesson?.signs.length ?? 0;

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
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle,
                          color: Color(0xFF4CAF50), size: 48),
                    ),
                    const SizedBox(height: 16),
                    const Text('Lesson Complete!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.lessonTitle,
                        style: const TextStyle(
                            color: Color(0xFF9E9E9E), fontSize: 15),
                        textAlign: TextAlign.center),
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
                          _buildSummaryRow('Signs introduced',
                              signCount > 0 ? '$signCount' : '—'),
                          const Divider(color: Color(0xFF3A3A3A), height: 24),
                          _buildSummaryRow('Recognition quiz', 'Completed'),
                          const Divider(color: Color(0xFF3A3A3A), height: 24),
                          _buildSummaryRow('Context practice', 'Completed'),
                          const Divider(color: Color(0xFF3A3A3A), height: 24),
                          _buildSummaryRow('Error analysis', 'Completed'),
                          const Divider(color: Color(0xFF3A3A3A), height: 24),
                          _buildSummaryRow('Camera practice', 'Completed'),
                        ],
                      ),
                    ),

                    // Signs learned chips
                    if (currentLesson != null && currentLesson.signs.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Signs Covered',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8, runSpacing: 8,
                          children: currentLesson.signs
                              .map((s) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(0xFF2196F3).withOpacity(0.3)),
                            ),
                            child: Text(s,
                                style: const TextStyle(
                                    color: Color(0xFF64B5F6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ))
                              .toList(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("What's Next?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 12),

                    if (nextLesson != null)
                      _buildNextAction(context, Icons.play_circle_outline,
                          'Continue to Next Lesson', nextLesson.title,
                          highlighted: true),
                    if (nextLesson != null) const SizedBox(height: 8),

                    _buildNextAction(context, Icons.replay, 'Review Mistakes',
                        'Practice signs you found difficult',
                        highlighted: false),
                    const SizedBox(height: 8),
                    _buildNextAction(context, Icons.refresh, 'Practice Again',
                        'Redo this lesson for mastery',
                        highlighted: false),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.settings.name == '/main' || r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Back to Home'),
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
        Text(label,
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  static Widget _buildNextAction(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle, {
        required bool highlighted,
      }) {
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
          Icon(icon,
              color: highlighted
                  ? const Color(0xFF2196F3)
                  : const Color(0xFF9E9E9E),
              size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF9E9E9E), fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: Color(0xFF9E9E9E), size: 22),
        ],
      ),
    );
  }
}