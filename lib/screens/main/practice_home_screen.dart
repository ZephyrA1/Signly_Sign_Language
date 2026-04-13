import 'package:flutter/material.dart';

class PracticeHomeScreen extends StatelessWidget {
  const PracticeHomeScreen({super.key});

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
              'Practice',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Strengthen your skills with focused activities',
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Practice mode cards
            _buildPracticeModeCard(
              context,
              icon: Icons.camera_alt_rounded,
              title: 'Camera Practice',
              description: 'Practice signs with your camera and get feedback on your form',
              color: const Color(0xFF2196F3),
              route: '/camera-practice',
            ),
            const SizedBox(height: 12),
            _buildPracticeModeCard(
              context,
              icon: Icons.chat_rounded,
              title: 'Scenario Practice',
              description: 'Apply signs in real-life situations and contexts',
              color: const Color(0xFF4CAF50),
              route: '/scenario-practice',
            ),
            const SizedBox(height: 12),
            _buildPracticeModeCard(
              context,
              icon: Icons.search_rounded,
              title: 'Error Detective',
              description: 'Spot mistakes in sign demonstrations and identify what went wrong',
              color: const Color(0xFFFF9800),
              route: '/error-detective',
            ),
            const SizedBox(height: 12),
            _buildPracticeModeCard(
              context,
              icon: Icons.remove_red_eye_rounded,
              title: 'Sign Interpretation',
              description: 'Watch signed words and phrases, then identify their meaning',
              color: const Color(0xFF9C27B0),
              route: '/sign-interpretation',
            ),
            const SizedBox(height: 12),
            _buildPracticeModeCard(
              context,
              icon: Icons.replay_rounded,
              title: 'Mistake Review',
              description: 'Review and practice signs you previously got wrong',
              color: const Color(0xFFE53935),
              route: '/weak-areas',
            ),
            const SizedBox(height: 28),

            // Daily recommendation
            const Text(
              'Daily Recommendation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.star_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Practice Greetings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Review the signs from your last lesson',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white70, size: 24),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildPracticeModeCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required Color color,
        required String route,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: color, size: 24),
          ],
        ),
      ),
    );
  }
}