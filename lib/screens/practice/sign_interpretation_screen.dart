import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

class SignInterpretationScreen extends StatefulWidget {
  const SignInterpretationScreen({super.key});

  @override
  State<SignInterpretationScreen> createState() => _SignInterpretationScreenState();
}

class _SignInterpretationScreenState extends State<SignInterpretationScreen> {
  int? _selectedOption;
  bool _submitted = false;
  int _currentQuestion = 0;

  // Questionnaire mc
  static const _questions = [
    _Question('Hello',     ['Hello', 'Goodbye', 'Thank You', 'Sorry'],       0),
    _Question('Goodbye',   ['Hello', 'Please', 'Goodbye', 'Fine'],           2),
    _Question('Name',      ['Name', 'Friend', 'Nice', 'Sorry'],              0),
    _Question('Nice',      ['Good', 'Fine', 'Happy', 'Nice'],                3),
    _Question('Thank You', ['Please', 'Sorry', 'Thank You', 'Yes'],          2),
    _Question('Please',    ['Thank You', 'Please', 'Help', 'Sorry'],         1),
    _Question('Fine',      ['Happy', 'Fine', 'Yes', 'Good'],                 1),
    _Question('Friend',    ['Family', 'Friend', 'Teacher', 'Student'],       1),
    _Question('Yes',       ['Maybe', 'No', 'Yes', 'Fine'],                   2),
    _Question('No',        ['No', 'Maybe', 'Sorry', 'Stop'],                 0),
    _Question('Maybe',     ['Yes', 'No', 'Maybe', 'Sorry'],                  2),
    _Question('Help',      ['Please', 'Help', 'Sorry', 'Thank You'],         1),
    _Question('Sorry',     ['Help', 'Please', 'Thank You', 'Sorry'],         3),
    _Question('Happy',     ['Happy', 'Sad', 'Fine', 'Yes'],                  0),
    _Question('Sad',       ['Happy', 'Sorry', 'Sad', 'Fine'],                2),
    _Question('Book',      ['Paper', 'Pencil', 'Book', 'Class'],             2),
    _Question('Pencil',    ['Pencil', 'Paper', 'Book', 'Write'],             0),
    _Question('Paper',     ['Book', 'Paper', 'Write', 'Pencil'],             1),
    _Question('Teacher',   ['Student', 'Teacher', 'Friend', 'Class'],        1),
    _Question('Student',   ['Teacher', 'Student', 'Class', 'Friend'],        1),
    _Question('Class',     ['Book', 'Teacher', 'Student', 'Class'],          3),
    _Question('What',      ['Where', 'Who', 'What', 'Why'],                  2),
    _Question('Where',     ['Where', 'What', 'Who', 'When'],                 0),
    _Question('Read',      ['Write', 'Read', 'Book', 'Learn'],               1),
    _Question('Write',     ['Read', 'Write', 'Pencil', 'Paper'],             1),
    _Question('Mother',    ['Father', 'Sister', 'Mother', 'Teacher'],        2),
    _Question('Father',    ['Father', 'Mother', 'Brother', 'Teacher'],       0),
    _Question('Sister',    ['Mother', 'Brother', 'Friend', 'Sister'],        3),
    _Question('Tall',      ['Old', 'Young', 'Short', 'Tall'],                3),
    _Question('Young',     ['Old', 'Tall', 'Young', 'Happy'],                2),
    _Question('Birthday',  ['Birthday', 'Happy', 'Old', 'Together'],         0),
    _Question('Old',       ['Young', 'Happy', 'Tall', 'Old'],                3),
    _Question('Love',      ['Like', 'Happy', 'Sorry', 'Love'],               3),
    _Question('Together',  ['Together', 'Friend', 'Love', 'Help'],           0),
    _Question('Eat',       ['Drink', 'Eat', 'Play', 'Together'],             1),
    _Question('Play',      ['Eat', 'Happy', 'Together', 'Play'],             3),
  ];

  _Question get _current => _questions[_currentQuestion];

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
    final q = _current;
    final youtubeId = SignContent.youtubeIdForSign(q.signName);
    final signContent = SignContent.forSign(q.signName);
    final isCorrect = _selectedOption == q.correctIndex;

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
                '${_currentQuestion + 1} / ${_questions.length}',
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
                    const Text('Interpret the Sign',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Watch the video and choose the correct sign name.',
                        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
                    const SizedBox(height: 20),

                    // Video
                    if (youtubeId != null)
                      SignlyYouTubePlayer(
                        key: ValueKey('interp_$_currentQuestion'),
                        videoId: youtubeId,
                        label: 'What sign is this?',
                      )
                    else
                      const VideoPlaceholder(height: 220, label: 'Sign demonstration'),

                    const SizedBox(height: 24),
                    const Text('What does this sign mean?',
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),

                    // Options
                    ...q.options.asMap().entries.map((e) {
                      final i = e.key;
                      final option = e.value;
                      final selected = _selectedOption == i;
                      final correct = i == q.correctIndex;

                      Color borderColor = const Color(0xFF3A3A3A);
                      Color bgColor = const Color(0xFF2A2A2A);

                      if (_submitted && selected) {
                        borderColor = correct ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
                        bgColor = (correct ? const Color(0xFF4CAF50) : const Color(0xFFE53935)).withOpacity(0.15);
                      } else if (_submitted && correct) {
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: selected || (_submitted && correct) ? 2 : 1),
                            ),
                            child: Row(children: [
                              Expanded(
                                child: Text(option,
                                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                              ),
                              if (_submitted && correct)
                                const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                              if (_submitted && selected && !correct)
                                const Icon(Icons.cancel, color: Color(0xFFE53935), size: 20),
                            ]),
                          ),
                        ),
                      );
                    }),

                    // Explanation
                    if (_submitted) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: (isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935)).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935)).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          signContent?.recognitionExplanation ?? '',
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
                  onPressed: _selectedOption == null ? null : () {
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
                  child: Text(_submitted
                      ? (_currentQuestion < _questions.length - 1 ? 'Next' : 'Finish')
                      : 'Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String signName;
  final List<String> options;
  final int correctIndex;
  const _Question(this.signName, this.options, this.correctIndex);
}