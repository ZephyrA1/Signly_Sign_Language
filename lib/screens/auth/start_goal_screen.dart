import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class StartGoalScreen extends StatelessWidget {
  const StartGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Progress bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: SignlyProgressBar(value: 1.0, height: 6),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Step 2/2',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Welcome message
              const Text(
                'Welcome! 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Here's your personalized learning plan",
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 15),
              ),
              const SizedBox(height: 28),
              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Learning Path',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow(Icons.language, 'Language', 'ASL'),
                    const SizedBox(height: 12),
                    _buildSummaryRow(Icons.school, 'Goal', 'School / Personal'),
                    const SizedBox(height: 12),
                    _buildSummaryRow(Icons.trending_up, 'Level', 'Beginner'),
                    const SizedBox(height: 12),
                    _buildSummaryRow(Icons.timer, 'Daily target', '10 min'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Suggested next steps
              const Text(
                'Suggested next steps',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              _buildNextStepCard(
                Icons.play_circle_outline,
                'Start Beginner Unit',
                'Begin with Greetings and Introductions',
                true,
              ),
              const SizedBox(height: 10),
              _buildNextStepCard(
                Icons.quiz_outlined,
                'Take Quick Placement Check',
                'See if you should skip ahead',
                false,
              ),
              const SizedBox(height: 10),
              _buildNextStepCard(
                Icons.explore_outlined,
                'Explore Free Practice',
                'Browse signs at your own pace',
                false,
              ),
              const Spacer(),
              // Let's Begin button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/main',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text("Let's Begin"),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static Widget _buildNextStepCard(
    IconData icon,
    String title,
    String subtitle,
    bool recommended,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: recommended
            ? const Color(0xFF2196F3).withOpacity(0.1)
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: recommended
              ? const Color(0xFF2196F3).withOpacity(0.4)
              : const Color(0xFF3A3A3A),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: recommended
                  ? const Color(0xFF2196F3).withOpacity(0.2)
                  : const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: recommended ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (recommended) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Recommended',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E), size: 22),
        ],
      ),
    );
  }
}
