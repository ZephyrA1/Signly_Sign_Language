import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../services/progress_service.dart';
import '../../services/lesson_session_tracker.dart';
import '../../widgets/common_widgets.dart';

class LessonContextScreen extends StatefulWidget {
  final String unitTitle;
  final String lessonTitle;
  final String lessonId;
  final int signIndex;
  final bool isReview;

  const LessonContextScreen({
    super.key,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonId,
    this.signIndex = 0,
    this.isReview = false,
  });

  @override
  State<LessonContextScreen> createState() => _LessonContextScreenState();
}

class _LessonContextScreenState extends State<LessonContextScreen> {
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
    _options = _content?.contextOptions ??
        ['Wave casually', 'Sign HELLO formally', 'Sign HI + NICE MEET YOU', 'Nod your head'];
    _correctAnswer = _content?.contextCorrectIndex ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: LessonProgressBar(
            progress: 3 / 5,
            onClose: () => Navigator.popUntil(
                context, (r) => r.settings.name == '/main' || r.isFirst),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Context: $_signName',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Choose the right sign for this situation',
                        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
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
                          Row(children: const [
                            Icon(Icons.chat_bubble_outline,
                                color: Color(0xFF2196F3), size: 18),
                            SizedBox(width: 8),
                            Text('Scenario',
                                style: TextStyle(
                                    color: Color(0xFF2196F3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: 10),
                          Text(
                            _content?.contextScenario ?? 'Choose the most appropriate sign.',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    ..._options.asMap().entries.map((e) => _buildOption(e.key, e.value)),

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
                        child: Text(
                          _content?.contextExplanation ??
                              'Consider the social context carefully when choosing which sign to use.',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, height: 1.5),
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
                  LessonSessionTracker.instance.recordContext(
                      widget.signIndex, _selectedOption == _correctAnswer);
                  if (_selectedOption != _correctAnswer) {
                    ProgressService.instance.recordMistake(WeakAreaEntry(
                      signName:    _signName,
                      lessonId:    widget.lessonId,
                      lessonTitle: widget.lessonTitle,
                      unitTitle:   widget.unitTitle,
                      signIndex:   widget.signIndex,
                      type:        MistakeType.context,
                      recordedAt:  DateTime.now(),
                    ));
                  }
                } else {
                  Navigator.pushReplacementNamed(context, '/lesson-error',
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
              Expanded(
                child: Text(text,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
              ),
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