import 'package:flutter/material.dart';

class FreePracticeScreen extends StatelessWidget {
  const FreePracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Explore', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Learn at your own pace',
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
              ),
              const SizedBox(height: 20),
              _buildExploreCard(
                Icons.category,
                'Browse by Topic',
                'Explore signs organized by category',
                const Color(0xFF2196F3),
              ),
              const SizedBox(height: 12),
              _buildExploreCard(
                Icons.search,
                'Search Any Sign',
                'Look up a specific sign or word',
                const Color(0xFF4CAF50),
              ),
              const SizedBox(height: 12),
              _buildExploreCard(
                Icons.casino,
                'Random Sign Challenge',
                'Test yourself with a random sign',
                const Color(0xFFFF9800),
              ),
              const SizedBox(height: 12),
              _buildExploreCard(
                Icons.camera_alt,
                'Practice Without Lesson',
                'Free-form camera practice',
                const Color(0xFF9C27B0),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/deaf-culture'),
                child: _buildExploreCard(
                  Icons.public,
                  'Browse Culture Notes',
                  'Learn about Deaf culture and communication',
                  const Color(0xFFE91E63),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Recommended for You',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Based on your interests',
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start exploring signs to get personalized recommendations!',
                      style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildExploreCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
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
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color, size: 22),
        ],
      ),
    );
  }
}
