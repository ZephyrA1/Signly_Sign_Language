import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

/// RLO Type 2: Recognition Quiz
/// A Reusable Learning Object that tests sign recognition through
/// multiple-choice questions. Provides immediate feedback with
/// correct/incorrect indicators and explanations.
/// Bloom's Taxonomy Level: Understand & Apply
/// UDL: Multiple means of action & expression (choice-based input)
class LessonRecognitionScreen extends StatefulWidget {
  final String lessonTitle;
  final String lessonId;

  const LessonRecognitionScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  State<LessonRecognitionScreen> createState() => _LessonRecognitionScreenState();
}

class _LessonRecognitionScreenState extends State<LessonRecognitionScreen> {
  int? _selectedOption;
  bool _submitted = false;
  final int _correctAnswer = 1;

  final _options = ['Goodbye', 'Hello', 'Thank You', 'Please'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 2 / 6,
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
                      'Guided Recognition',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Watch the sign and choose the correct meaning',
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // Sign video
                    Builder(builder: (context) {
                      final videoPath = LessonVideoMap.correctVideo(widget.lessonId);
                      if (videoPath != null) {
                        return SignlyVideoPlayer(
                          assetPath: videoPath,
                          height: 180,
                          label: 'What sign is this?',
                        );
                      }
                      return const VideoPlaceholder(height: 180, label: 'Sign demonstration');
                    }),
                    const SizedBox(height: 24),
                    const Text(
                      'What does this sign mean?',
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    // Options
                    ..._options.asMap().entries.map((e) {
                      final i = e.key;
                      final option = e.value;
                      final selected = _selectedOption == i;
                      final isCorrect = i == _correctAnswer;
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
                          onTap: _submitted ? null : () => setState(() => _selectedOption = i),
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
                                Text(
                                  option,
                                  style: TextStyle(
                                    color: selected && !_submitted ? const Color(0xFF2196F3) : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
                    }),
                    if (_submitted) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
                        ),
                        child: const Text(
                          'This sign means "Hello" - the hand moves away from the forehead in a salute-like motion.',
                          style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
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
                        Navigator.pushReplacementNamed(context, '/lesson-context', arguments: {
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
}
