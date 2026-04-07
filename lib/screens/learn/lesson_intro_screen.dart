import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

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
    final content = LessonContent.forLesson(lessonId);
    final lesson = LessonUnit.findLesson(lessonId);

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
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
                    child: Text(unitTitle,
                        style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                        overflow: TextOverflow.ellipsis),
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
                    Text(lessonTitle,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Learning goal
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
                          const Text('Learning Goal',
                              style: TextStyle(
                                  color: Color(0xFF2196F3),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(
                            content?.learningGoal ??
                                'In this lesson you will learn new signs and practise them in context.',
                            style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Signs in this lesson
                    if (lesson != null && lesson.signs.isNotEmpty) ...[
                      const Text('Signs You\'ll Learn',
                          style: TextStyle(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: lesson.signs.map((sign) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF3A3A3A)),
                          ),
                          child: Text(sign,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                        )).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Per-sign step indicator
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF3A3A3A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You\'ll learn each sign one at a time',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            ...lesson.signs.asMap().entries.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20, height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2196F3).withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text('${e.key + 1}',
                                          style: const TextStyle(
                                              color: Color(0xFF2196F3),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(e.value,
                                      style: const TextStyle(
                                          color: Color(0xFF9E9E9E), fontSize: 13)),
                                  const SizedBox(width: 6),
                                  const Text('→ Watch · Recognize · Context · Error · Camera',
                                      style: TextStyle(
                                          color: Color(0xFF555577), fontSize: 11)),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Skills + time
                    const Text('Skills Practiced',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(children: [
                      _buildSkillChip(Icons.remove_red_eye, 'Recognition'),
                      const SizedBox(width: 8),
                      _buildSkillChip(Icons.camera_alt, 'Production'),
                      const SizedBox(width: 8),
                      _buildSkillChip(Icons.chat, 'Context'),
                    ]),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer, color: Color(0xFF9E9E9E), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Estimated time: ${content?.estimatedTime ?? '10 min'}',
                            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
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
              label: 'Start Lesson',
              onPressed: () {
                Navigator.pushNamed(context, '/lesson-watch', arguments: {
                  'unitTitle': unitTitle,
                  'lessonTitle': lessonTitle,
                  'lessonId': lessonId,
                  'signIndex': 0,
                  'isReview': false,
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
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}