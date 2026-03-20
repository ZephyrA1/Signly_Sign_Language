import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class WeakAreasScreen extends StatelessWidget {
  const WeakAreasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Focus Areas', style: TextStyle(color: Colors.white)),
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
                'Areas that need more practice',
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
              ),
              const SizedBox(height: 20),
              _buildWeakArea('Movement Accuracy', 'Your hand movements need refinement', Icons.swap_horiz, 0.35, [
                'Practice slow motion replay',
                'Compare side-by-side with model',
                'Focus on arc and speed',
              ]),
              const SizedBox(height: 14),
              _buildWeakArea('Context Application', 'Choosing signs for situations', Icons.chat, 0.5, [
                'More scenario practice',
                'Review cultural context notes',
                'Practice formal vs informal signs',
              ]),
              const SizedBox(height: 14),
              _buildWeakArea('Similar Signs', 'Distinguishing between similar signs', Icons.compare, 0.4, [
                'Error detective exercises',
                'Side-by-side comparisons',
                'Focus on handshape differences',
              ]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Practice Now'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildWeakArea(String title, String desc, IconData icon, double progress, List<String> exercises) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(icon, color: const Color(0xFFFF9800), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(desc, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(color: Color(0xFFFF9800), fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SignlyProgressBar(value: progress, height: 4, valueColor: const Color(0xFFFF9800)),
          const SizedBox(height: 14),
          const Text('Suggested exercises:', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
          const SizedBox(height: 6),
          ...exercises.map((ex) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_right, color: Color(0xFF2196F3), size: 18),
                    const SizedBox(width: 6),
                    Text(ex, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
