import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

class LearnHomeScreen extends StatelessWidget {
  const LearnHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top greeting
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Good evening! 👋',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Continue your sign language journey',
                          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily goal progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.local_fire_department, color: Colors.orange, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Daily Goal',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          '0 / 10 min',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.0,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.bolt, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '0 day streak',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Continue Learning section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SignlySectionTitle(title: 'Continue Learning'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildContinueLearningCard(context),
            ),
            const SizedBox(height: 24),

            // Units section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SignlySectionTitle(title: 'Units'),
            ),
            const SizedBox(height: 12),
            ...LessonUnit.sampleUnits.map((unit) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _buildUnitCard(context, unit),
              );
            }),
            const SizedBox(height: 12),

            // Culture note shortcut
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/deaf-culture');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.public, color: Color(0xFF2196F3), size: 22),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Explore Deaf Culture & Communication',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E), size: 22),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildContinueLearningCard(BuildContext context) {
    final firstLesson = LessonUnit.sampleUnits[0].lessons[0];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/lesson-intro', arguments: {
          'unitTitle': LessonUnit.sampleUnits[0].title,
          'lessonTitle': firstLesson.title,
          'lessonId': firstLesson.id,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF2196F3), size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firstLesson.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Unit 1 - ${firstLesson.duration} - 0% complete',
                    style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  const SignlyProgressBar(value: 0.0, height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildUnitCard(BuildContext context, LessonUnit unit) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/lesson-intro', arguments: {
          'unitTitle': unit.title,
          'lessonTitle': unit.lessons[0].title,
          'lessonId': unit.lessons[0].id,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    unit.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${unit.lessonCount} lessons',
                    style: const TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              unit.subtitle,
              style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Skill focus: ${unit.skillFocus}',
              style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
            ),
            const SizedBox(height: 10),
            SignlyProgressBar(value: unit.progress, height: 4),
            const SizedBox(height: 6),
            Text(
              '${(unit.progress * 100).toInt()}% complete',
              style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
