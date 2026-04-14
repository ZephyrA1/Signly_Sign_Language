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
  int? _selectedSign;
  bool _submitted = false;

  // Signs that have both correct + incorrect MP4s locally
  static const _localVideoSigns = {'Mother', 'Father', 'Sister', 'Hello'};

  // All signs with YouTube IDs — distractor is a different sign from same unit
  static const _questions = [
    // Unit 1 — Greetings
    _Question('Hello',     distractorSign: 'Goodbye',   incorrectSlot: 1),
    _Question('Goodbye',   distractorSign: 'Hello',     incorrectSlot: 0),
    _Question('Name',      distractorSign: 'Nice',      incorrectSlot: 1),
    _Question('Nice',      distractorSign: 'Name',      incorrectSlot: 0),
    _Question('Thank You', distractorSign: 'Please',    incorrectSlot: 1),
    _Question('Please',    distractorSign: 'Thank You', incorrectSlot: 0),
    _Question('Fine',      distractorSign: 'Happy',     incorrectSlot: 1),
    _Question('Friend',    distractorSign: 'Teacher',   incorrectSlot: 0),
    // Unit 2 — Everyday
    _Question('Yes',       distractorSign: 'No',        incorrectSlot: 1),
    _Question('No',        distractorSign: 'Yes',       incorrectSlot: 0),
    _Question('Maybe',     distractorSign: 'Yes',       incorrectSlot: 1),
    _Question('Help',      distractorSign: 'Sorry',     incorrectSlot: 0),
    _Question('Sorry',     distractorSign: 'Help',      incorrectSlot: 1),
    _Question('Happy',     distractorSign: 'Sad',       incorrectSlot: 0),
    _Question('Sad',       distractorSign: 'Happy',     incorrectSlot: 1),
    // Unit 3 — School
    _Question('Book',      distractorSign: 'Paper',     incorrectSlot: 0),
    _Question('Pencil',    distractorSign: 'Book',      incorrectSlot: 1),
    _Question('Paper',     distractorSign: 'Pencil',    incorrectSlot: 0),
    _Question('Teacher',   distractorSign: 'Student',   incorrectSlot: 1),
    _Question('Student',   distractorSign: 'Teacher',   incorrectSlot: 0),
    _Question('What',      distractorSign: 'Where',     incorrectSlot: 1),
    _Question('Where',     distractorSign: 'What',      incorrectSlot: 0),
    _Question('Read',      distractorSign: 'Write',     incorrectSlot: 1),
    _Question('Write',     distractorSign: 'Read',      incorrectSlot: 0),
    // Unit 4 — Family
    _Question('Mother',    distractorSign: 'Father',    incorrectSlot: 1),
    _Question('Father',    distractorSign: 'Mother',    incorrectSlot: 0),
    _Question('Sister',    distractorSign: 'Mother',    incorrectSlot: 1),
    _Question('Tall',      distractorSign: 'Young',     incorrectSlot: 0),
    _Question('Young',     distractorSign: 'Old',       incorrectSlot: 1),
    _Question('Birthday',  distractorSign: 'Love',      incorrectSlot: 0),
    _Question('Old',       distractorSign: 'Young',     incorrectSlot: 1),
    _Question('Love',      distractorSign: 'Together',  incorrectSlot: 0),
    _Question('Together',  distractorSign: 'Love',      incorrectSlot: 1),
    _Question('Eat',       distractorSign: 'Play',      incorrectSlot: 0),
    _Question('Play',      distractorSign: 'Eat',       incorrectSlot: 1),
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

    // Slot 0 = correct sign, Slot 1 = distractor — unless incorrectSlot flips them
    final correctId    = SignContent.youtubeIdForSign(q.signName);
    final distractorId = SignContent.youtubeIdForSign(q.distractorSign);

    final slot0Id = q.incorrectSlot == 0 ? distractorId : correctId;
    final slot1Id = q.incorrectSlot == 1 ? distractorId : correctId;

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
                    // Sign label
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
                        Text('Sign: ${q.signName}',
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    const Text('Which sign is performed incorrectly?',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    const Text('Watch both videos and tap the incorrect one.',
                        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                    const SizedBox(height: 16),

                    // Two video cards
                    Row(children: [
                      Expanded(child: _buildVideoCard(slot: 0, youtubeId: slot0Id, label: 'Sign A')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildVideoCard(slot: 1, youtubeId: slot1Id, label: 'Sign B')),
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
                            style: TextStyle(color: feedbackColor, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign ${q.incorrectSlot == 0 ? 'A' : 'B'} is "${q.distractorSign}" — the incorrect sign. $errorFeedback',
                            style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
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

  Widget _buildVideoCard({required int slot, required String? youtubeId, required String label}) {
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            child: youtubeId != null
                ? AspectRatio(
              aspectRatio: 16 / 9,
              child: SignlyYouTubeMiniPlayer(
                key: ValueKey('${_questionIndex}_$slot'),
                videoId: youtubeId,
              ),
            )
                : Container(
              height: 120,
              color: const Color(0xFF1A1A2E),
              child: const Center(
                child: Icon(Icons.play_circle_outline, color: Color(0xFF9E9E9E), size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ]),
      ),
    );
  }
}

class _Question {
  final String signName;
  final String distractorSign;
  final int incorrectSlot;
  const _Question(this.signName, {required this.distractorSign, required this.incorrectSlot});
}