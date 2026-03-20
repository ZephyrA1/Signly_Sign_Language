import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

/// RLO Type 6: Self-Reflection & Metacognition
/// A Reusable Learning Object that prompts learners to reflect on
/// their learning experience, identify difficulties, assess improvement,
/// and choose optional review activities. Promotes metacognitive skills.
/// Bloom's Taxonomy Level: Evaluate
/// UDL: Multiple means of engagement (self-regulation, reflection)
class LessonReflectionScreen extends StatefulWidget {
  final String lessonTitle;
  final String lessonId;

  const LessonReflectionScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  State<LessonReflectionScreen> createState() => _LessonReflectionScreenState();
}

class _LessonReflectionScreenState extends State<LessonReflectionScreen> {
  int? _selectedDifficulty;
  int? _selectedImprovement;
  bool _wantsExtraPractice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 6 / 6,
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
                      'Reflect',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Think about your learning experience',
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    // Question 1: Difficulty
                    _buildQuestionCard(
                      'Which part was most difficult?',
                      [
                        'Recognizing the sign',
                        'Choosing the right context',
                        'Spotting the error',
                        'Performing the sign myself',
                      ],
                      _selectedDifficulty,
                      (i) => setState(() => _selectedDifficulty = i),
                    ),
                    const SizedBox(height: 20),
                    // Question 2: Improvement
                    _buildQuestionCard(
                      'What did you improve after retrying?',
                      [
                        'My handshape became more accurate',
                        'I understood the movement better',
                        'I felt more confident overall',
                        'I still need more practice',
                      ],
                      _selectedImprovement,
                      (i) => setState(() => _selectedImprovement = i),
                    ),
                    const SizedBox(height: 20),
                    // Question 3: Extra practice
                    const Text(
                      'Would you like extra practice on this sign?',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _wantsExtraPractice = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _wantsExtraPractice
                                    ? const Color(0xFF2196F3).withOpacity(0.2)
                                    : const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _wantsExtraPractice
                                      ? const Color(0xFF2196F3)
                                      : const Color(0xFF3A3A3A),
                                  width: _wantsExtraPractice ? 2 : 1,
                                ),
                              ),
                              child: const Center(
                                child: Text('Yes, review more', style: TextStyle(color: Colors.white, fontSize: 14)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _wantsExtraPractice = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: !_wantsExtraPractice
                                    ? const Color(0xFF2196F3).withOpacity(0.2)
                                    : const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_wantsExtraPractice
                                      ? const Color(0xFF2196F3)
                                      : const Color(0xFF3A3A3A),
                                  width: !_wantsExtraPractice ? 2 : 1,
                                ),
                              ),
                              child: const Center(
                                child: Text('Move on', style: TextStyle(color: Colors.white, fontSize: 14)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Optional review buttons
                    if (_wantsExtraPractice) ...[
                      const Text(
                        'What would you like to review?',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _buildReviewOption(Icons.pan_tool, 'Review Handshape'),
                      const SizedBox(height: 8),
                      _buildReviewOption(Icons.swap_horiz, 'Review Movement'),
                      const SizedBox(height: 8),
                      _buildReviewOption(Icons.camera_alt, 'Practice Again'),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SignlyBottomButton(
              label: 'Continue',
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

  Widget _buildQuestionCard(String question, List<String> options, int? selected, Function(int) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...options.asMap().entries.map((e) {
          final isSelected = selected == e.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => onSelect(e.key),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2196F3).withOpacity(0.15)
                      : const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF3A3A3A),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  e.value,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF2196F3) : Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReviewOption(IconData icon, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2196F3), size: 22),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E), size: 22),
        ],
      ),
    );
  }
}
