import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

/// RLO Type 3: Scenario-Based Context Practice
/// A Reusable Learning Object that presents real-world scenarios
/// requiring learners to choose the appropriate sign for a given
/// situation. Develops contextual understanding and pragmatic skills.
/// Bloom's Taxonomy Level: Apply & Analyze
/// UDL: Multiple means of engagement (real-world relevance)
class LessonContextScreen extends StatefulWidget {
  final String lessonTitle;
  final String lessonId;

  const LessonContextScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  State<LessonContextScreen> createState() => _LessonContextScreenState();
}

class _LessonContextScreenState extends State<LessonContextScreen> {
  int? _selectedOption;
  bool _submitted = false;
  final int _correctAnswer = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 3 / 6,
              onClose: () => Navigator.popUntil(context, (route) => route.settings.name == '/main' || route.isFirst),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Context Practice',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose the right sign for this situation',
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // Scenario card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.chat_bubble_outline, color: Color(0xFF2196F3), size: 18),
                              SizedBox(width: 8),
                              Text('Scenario', style: TextStyle(color: Color(0xFF2196F3), fontSize: 14, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'You are meeting your teacher for the first time at school. What is the most appropriate greeting?',
                            style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Options
                    _buildOption(0, 'Wave casually'),
                    _buildOption(1, 'Sign HELLO formally'),
                    _buildOption(2, 'Sign HI + NICE MEET YOU'),
                    _buildOption(3, 'Nod your head'),
                    if (_submitted) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: (_selectedOption == _correctAnswer
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFFE53935))
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (_selectedOption == _correctAnswer
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFE53935))
                                .withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'In a formal first meeting, signing HI followed by NICE MEET YOU shows proper etiquette and respect. This is the culturally appropriate response.',
                          style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SignlyBottomButton(
              label: _submitted ? 'Continue' : 'Submit',
              onPressed: _selectedOption == null
                  ? null
                  : () {
                      if (!_submitted) {
                        setState(() => _submitted = true);
                      } else {
                        Navigator.pushReplacementNamed(context, '/lesson-error', arguments: {
                          'lessonTitle': widget.lessonTitle,
                          'lessonId': widget.lessonId,
                        });
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index, String text) {
    final selected = _selectedOption == index;
    final isCorrect = index == _correctAnswer;
    Color borderColor = const Color(0xFF3A3A3A);
    Color bgColor = const Color(0xFF2A2A2A);

    if (_submitted && selected) {
      borderColor = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
      bgColor = (isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935)).withOpacity(0.15);
    } else if (_submitted && isCorrect) {
      borderColor = const Color(0xFF4CAF50);
      bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
    } else if (selected) {
      borderColor = const Color(0xFF2196F3);
      bgColor = const Color(0xFF2196F3).withOpacity(0.15);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: _submitted ? null : () => setState(() => _selectedOption = index),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected || (_submitted && isCorrect) ? 2 : 1),
          ),
          child: Row(
            children: [
              Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
              const Spacer(),
              if (_submitted && isCorrect)
                const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 22),
              if (_submitted && selected && !isCorrect)
                const Icon(Icons.cancel, color: Color(0xFFE53935), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
