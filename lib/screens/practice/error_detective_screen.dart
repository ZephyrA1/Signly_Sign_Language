import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

class ErrorDetectiveScreen extends StatefulWidget {
  const ErrorDetectiveScreen({super.key});

  @override
  State<ErrorDetectiveScreen> createState() => _ErrorDetectiveScreenState();
}

class _ErrorDetectiveScreenState extends State<ErrorDetectiveScreen> {
  int _questionIndex = 0;
  int? _selectedSign; // 0 = Sign A, 1 = Sign B
  bool _submitted = false;

  // Each question: sign name, which slot (0 or 1) is the incorrect video
  // We randomise which side shows correct/incorrect per question
  static const _questions = [
    _Question(signName: 'Mother',  incorrectSlot: 1),
    _Question(signName: 'Father',  incorrectSlot: 0),
    _Question(signName: 'Sister',  incorrectSlot: 1),
  ];

  _Question get _current => _questions[_questionIndex];

  void _onSubmitOrNext() {
    if (!_submitted) {
      setState(() => _submitted = true);
    } else if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedSign = null;
        _submitted = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _current;
    final correctPath   = LessonVideoMap.correctVideo(q.signName);
    final incorrectPath = LessonVideoMap.incorrectVideo(q.signName);
    final feedbackColor = _selectedSign == q.incorrectSlot
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53935);
    final errorFeedback = SignContent.forSign(q.signName)?.errorFeedback ?? '';

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Error Detective', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_questionIndex + 1} / ${_questions.length}',
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sign name
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.sign_language, color: Color(0xFF2196F3), size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Sign: ${q.signName}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Which sign is performed incorrectly?',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Watch both videos carefully and tap the incorrect one.',
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                    ),
                    const SizedBox(height: 16),

                    // Two video cards side by side
                    Row(children: [
                      Expanded(child: _buildVideoCard(
                        slot: 0,
                        label: 'Sign A',
                        videoPath: q.incorrectSlot == 0 ? incorrectPath : correctPath,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _buildVideoCard(
                        slot: 1,
                        label: 'Sign B',
                        videoPath: q.incorrectSlot == 1 ? incorrectPath : correctPath,
                      )),
                    ]),

                    // Feedback
                    if (_submitted) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: feedbackColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: feedbackColor.withOpacity(0.3)),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            _selectedSign == q.incorrectSlot ? 'Correct!' : 'Not quite',
                            style: TextStyle(
                                color: feedbackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign ${q.incorrectSlot == 0 ? 'A' : 'B'} is incorrect. $errorFeedback',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14, height: 1.5),
                          ),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedSign == null ? null : _onSubmitOrNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: Text(_submitted
                      ? (_questionIndex < _questions.length - 1 ? 'Next' : 'Finish')
                      : 'Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard({
    required int slot,
    required String label,
    required String? videoPath,
  }) {
    final selected = _selectedSign == slot;
    final isIncorrect = slot == _current.incorrectSlot;

    Color borderColor = const Color(0xFF3A3A3A);
    if (_submitted && selected) {
      borderColor = isIncorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    } else if (_submitted && isIncorrect) {
      borderColor = const Color(0xFF4CAF50);
    } else if (selected) {
      borderColor = const Color(0xFF2196F3);
    }

    return GestureDetector(
      onTap: _submitted ? null : () => setState(() => _selectedSign = slot),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Column(children: [
          // Video
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            child: videoPath != null
                ? SignlyMiniVideoPlayer(key: ValueKey('${_questionIndex}_$slot'), assetPath: videoPath, height: 180, autoPlay: false)
                : Container(
              height: 180,
              color: const Color(0xFF1A1A2E),
              child: const Center(
                child: Icon(Icons.play_circle_outline,
                    color: Color(0xFF9E9E9E), size: 40),
              ),
            ),
          ),

          // Label + result icon
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),

            ]),
          ),
        ]),
      ),
    );
  }
}

class _Question {
  final String signName;
  final int incorrectSlot; // 0 = Sign A is wrong, 1 = Sign B is wrong
  const _Question({required this.signName, required this.incorrectSlot});
}