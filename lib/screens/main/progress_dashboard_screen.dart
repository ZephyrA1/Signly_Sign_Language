import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class ProgressDashboardScreen extends StatelessWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Your Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Stats cards row 1
            Row(
              children: const [
                SignlyStatCard(
                  icon: Icons.menu_book,
                  value: '0',
                  label: 'Lessons',
                  color: Color(0xFF2196F3),
                ),
                SizedBox(width: 12),
                SignlyStatCard(
                  icon: Icons.sign_language,
                  value: '0',
                  label: 'Signs Learned',
                  color: Color(0xFF4CAF50),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Stats cards row 2
            Row(
              children: const [
                SignlyStatCard(
                  icon: Icons.remove_red_eye,
                  value: '0%',
                  label: 'Interpretation',
                  color: Color(0xFF9C27B0),
                ),
                SizedBox(width: 12),
                SignlyStatCard(
                  icon: Icons.camera_alt,
                  value: '0%',
                  label: 'Production',
                  color: Color(0xFFFF9800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Streak card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '0 Day Streak',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Start practicing to build your streak!',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Weekly goal progress
            const SignlySectionTitle(title: 'Weekly Goal'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDayCircle('Mo', false),
                      _buildDayCircle('Tu', false),
                      _buildDayCircle('We', false),
                      _buildDayCircle('Th', false),
                      _buildDayCircle('Fr', false),
                      _buildDayCircle('Sa', false),
                      _buildDayCircle('Su', false),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.calendar_today, color: Color(0xFF9E9E9E), size: 16),
                      SizedBox(width: 8),
                      Text(
                        '0 / 7 days this week',
                        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Strengths
            const SignlySectionTitle(title: 'Strengths'),
            const SizedBox(height: 12),
            _buildStrengthItem('Greetings', 0.0, 'Not started yet'),
            const SizedBox(height: 8),
            _buildStrengthItem('Everyday Expressions', 0.0, 'Not started yet'),
            const SizedBox(height: 24),

            // Areas needing review
            const SignlySectionTitle(title: 'Areas Needing Review'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.school_outlined, color: Color(0xFF9E9E9E), size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'Complete some lessons first',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "We'll track areas that need more practice",
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Review weak areas button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/weak-areas');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2196F3),
                  side: const BorderSide(color: Color(0xFF2196F3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Review Weak Areas'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildDayCircle(String day, bool active) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2196F3) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: active ? const Color(0xFF2196F3) : const Color(0xFF3A3A3A),
            ),
          ),
          child: Center(
            child: active
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: TextStyle(
            color: active ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static Widget _buildStrengthItem(String title, double progress, String status) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                status,
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SignlyProgressBar(value: progress, height: 4),
        ],
      ),
    );
  }
}
