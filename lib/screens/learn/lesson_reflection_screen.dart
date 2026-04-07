import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

class LessonReflectionScreen extends StatefulWidget {
  final String unitTitle;
  final String lessonTitle;
  final String lessonId;

  const LessonReflectionScreen({
    super.key,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  State<LessonReflectionScreen> createState() => _LessonReflectionScreenState();
}

class _LessonReflectionScreenState extends State<LessonReflectionScreen> {
  int? _difficultyRating;
  String? _improvementChoice;

  @override
  Widget build(BuildContext context) {
    final lesson = LessonUnit.findLesson(widget.lessonId);
    final signs = lesson?.signs ?? [];

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 1.0,
              onClose: () => Navigator.popUntil(
                  context, (r) => r.settings.name == '/main' || r.isFirst),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Lesson Complete 🎉',
                        style: TextStyle(
                            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('You practised all ${signs.length} sign${signs.length == 1 ? '' : 's'} in ${widget.lessonTitle}.',
                        style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
                    const SizedBox(height: 24),

                    // Quick stats
                    Row(
                      children: [
                        _buildStatCard('Signs\nlearned', '${signs.length}', Icons.pan_tool),
                        const SizedBox(width: 10),
                        _buildStatCard('Steps\ncompleted', '${signs.length * 5}', Icons.check_circle_outline),
                        const SizedBox(width: 10),
                        _buildStatCard('Screens\npractised', '5', Icons.camera_alt),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Reflection Q1
                    const Text('How was the difficulty?',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildDifficultyButton(1, Icons.sentiment_very_dissatisfied, 'Too Easy'),
                        const SizedBox(width: 8),
                        _buildDifficultyButton(2, Icons.sentiment_neutral, 'Just Right'),
                        const SizedBox(width: 8),
                        _buildDifficultyButton(3, Icons.sentiment_very_satisfied, 'Challenging'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Reflection Q2
                    const Text('What would you like to improve?',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    ...['Handshape accuracy', 'Sign speed', 'Facial expression', 'Context usage']
                        .map((choice) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _improvementChoice = choice),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _improvementChoice == choice
                                ? const Color(0xFF2196F3).withOpacity(0.15)
                                : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _improvementChoice == choice
                                  ? const Color(0xFF2196F3)
                                  : const Color(0xFF3A3A3A),
                            ),
                          ),
                          child: Text(choice,
                              style: TextStyle(
                                color: _improvementChoice == choice
                                    ? const Color(0xFF2196F3)
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight: _improvementChoice == choice
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              )),
                        ),
                      ),
                    )),
                    const SizedBox(height: 28),

                    // Per-sign review section
                    if (signs.isNotEmpty) ...[
                      const Text('Review a sign',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap any sign to go through its full loop again.',
                        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      ...signs.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            // pushNamed so the reflection screen stays in the stack
                            // Camera in review mode will pop back here
                            Navigator.pushNamed(context, '/lesson-watch', arguments: {
                              'unitTitle': widget.unitTitle,
                              'lessonTitle': widget.lessonTitle,
                              'lessonId': widget.lessonId,
                              'signIndex': e.key,
                              'isReview': true,
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(14),
                              border:
                              Border.all(color: const Color(0xFF3A3A3A)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9800).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.pan_tool_outlined,
                                        color: Color(0xFFFF9800), size: 16),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Review ${e.value}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Watch → Recognize → Context → Error → Camera',
                                        style: TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    color: Color(0xFF9E9E9E), size: 14),
                              ],
                            ),
                          ),
                        ),
                      )),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
            SignlyBottomButton(
              label: 'Continue to Summary',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/lesson-summary', arguments: {
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

  Widget _buildDifficultyButton(int value, IconData icon, String label) {
    final selected = _difficultyRating == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _difficultyRating = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF2196F3).withOpacity(0.15)
                : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
              selected ? const Color(0xFF2196F3) : const Color(0xFF3A3A3A),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E),
                  size: 26),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                    color: selected ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E),
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2196F3), size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF9E9E9E), fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}