import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

/// RLO Type 2 (Reused): Sign Interpretation / Recognition Quiz
/// Independent practice mode reusing the Recognition RLO pattern.
/// Presents signed video with multiple meaning options to test
/// interpretive comprehension in varied contexts.
class SignInterpretationScreen extends StatefulWidget {
  const SignInterpretationScreen({super.key});

  @override
  State<SignInterpretationScreen> createState() => _SignInterpretationScreenState();
}

class _SignInterpretationScreenState extends State<SignInterpretationScreen> {
  int? _selectedOption;
  bool _submitted = false;
  int _currentQuestion = 0;

  final _questions = [
    {
      'sign': 'Sign demonstration: "Hello"',
      'options': ['Hello', 'Goodbye', 'Help', 'Sorry'],
      'correct': 0,
      'explanation': 'This sign is "Hello" - an open hand moving away from the forehead.',
    },
    {
      'sign': 'Sign demonstration: "Thank You"',
      'options': ['Please', 'Sorry', 'Thank You', 'Yes'],
      'correct': 2,
      'explanation': 'This sign is "Thank You" - the hand moves forward from the chin.',
    },
    {
      'sign': 'Sign demonstration: "Friend"',
      'options': ['Family', 'Friend', 'Teacher', 'Student'],
      'correct': 1,
      'explanation': 'This sign is "Friend" - two index fingers hooked together, then switched.',
    },
  ];

  Map<String, dynamic> get _current => _questions[_currentQuestion];

  void _next() {
    setState(() {
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
        _selectedOption = null;
        _submitted = false;
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Sign Interpretation', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentQuestion + 1}/${_questions.length}',
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
                    const Text(
                      'Interpret the Sign',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Watch the signed word and choose its meaning',
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    VideoPlaceholder(height: 180, label: _current['sign'] as String),
                    const SizedBox(height: 24),
                    const Text(
                      'What does this sign mean?',
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    ...(_current['options'] as List<String>).asMap().entries.map((e) {
                      final i = e.key;
                      final option = e.value;
                      final selected = _selectedOption == i;
                      final isCorrect = i == _current['correct'];
                      Color borderColor = const Color(0xFF3A3A3A);
                      Color bgColor = const Color(0xFF2A2A2A);

                      if (_submitted && selected) {
                        borderColor = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
                        bgColor = (isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935)).withOpacity(0.15);
                      } else if (_submitted && isCorrect) {
                        borderColor = const Color(0xFF4CAF50);
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: selected || (_submitted && isCorrect) ? 2 : 1),
                            ),
                            child: Text(option, style: const TextStyle(color: Colors.white, fontSize: 15)),
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
                        child: Text(
                          _current['explanation'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                        ),
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
                  onPressed: _selectedOption == null
                      ? null
                      : () {
                          if (!_submitted) {
                            setState(() => _submitted = true);
                          } else {
                            _next();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: Text(_submitted ? (_currentQuestion < _questions.length - 1 ? 'Next' : 'Finish') : 'Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
