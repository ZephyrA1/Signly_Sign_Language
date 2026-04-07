import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

class LessonRecognitionScreen extends StatefulWidget {
  final String unitTitle;
  final String lessonTitle;
  final String lessonId;
  final int signIndex;
  final bool isReview;

  const LessonRecognitionScreen({
    super.key,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonId,
    this.signIndex = 0,
    this.isReview = false,
  });

  @override
  State<LessonRecognitionScreen> createState() => _LessonRecognitionScreenState();
}

class _LessonRecognitionScreenState extends State<LessonRecognitionScreen> {
  int? _selectedOption;
  bool _submitted = false;

  late final SignContent? _content;
  late final List<String> _options;
  late final int _correctAnswer;
  late final String _signName;

  @override
  void initState() {
    super.initState();
    final lesson = LessonUnit.findLesson(widget.lessonId);
    _signName = (lesson != null && widget.signIndex < lesson.signs.length)
        ? lesson.signs[widget.signIndex]
        : '';
    _content = SignContent.forSign(_signName);
    _options = _content?.recognitionOptions ?? ['Goodbye', 'Hello', 'Thank You', 'Please'];
    _correctAnswer = _content?.recognitionCorrectIndex ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final videoPath = widget.signIndex == 0 ? LessonVideoMap.correctVideo(widget.lessonId) : null;

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 2 / 5,
              onClose: () => Navigator.popUntil(
                  context, (r) => r.settings.name == '/main' || r.isFirst),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recognize: $_signName',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Watch the sign and choose the correct answer',
                        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
                    const SizedBox(height: 20),

                    if (videoPath != null)
                      SignlyVideoPlayer(
                          assetPath: videoPath, height: 180, label: 'What sign is this?')
                    else
                      VideoPlaceholder(height: 180, label: '$_signName demonstration'),

                    const SizedBox(height: 24),
                    Text(
                      _content?.recognitionQuestion ?? 'What does this sign mean?',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),

                    ..._options.asMap().entries.map((e) => _buildOption(e.key, e.value)),

                    if (_submitted) ...[
                      const SizedBox(height: 12),
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
                        child: Text(
                          _content?.recognitionExplanation ?? 'Review the sign carefully.',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, height: 1.4),
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
                  Navigator.pushReplacementNamed(context, '/lesson-context',
                      arguments: {
                        'unitTitle': widget.unitTitle,
                        'lessonTitle': widget.lessonTitle,
                        'lessonId': widget.lessonId,
                        'signIndex': widget.signIndex,
                        'isReview': widget.isReview,
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
            border: Border.all(
                color: borderColor, width: selected || (_submitted && isCorrect) ? 2 : 1),
          ),
          child: Row(
            children: [
              Text(text,
                  style: TextStyle(
                    color: selected && !_submitted ? const Color(0xFF2196F3) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
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