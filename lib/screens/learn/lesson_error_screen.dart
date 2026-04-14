import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../services/progress_service.dart';
import '../../services/lesson_session_tracker.dart';
import '../../widgets/common_widgets.dart';

class LessonErrorScreen extends StatefulWidget {
  final String unitTitle;
  final String lessonTitle;
  final String lessonId;
  final int signIndex;
  final bool isReview;

  const LessonErrorScreen({
    super.key,
    required this.unitTitle,
    required this.lessonTitle,
    required this.lessonId,
    this.signIndex = 0,
    this.isReview = false,
  });

  @override
  State<LessonErrorScreen> createState() => _LessonErrorScreenState();
}

class _LessonErrorScreenState extends State<LessonErrorScreen> {
  int? _selectedSign; // 0 = Sign A (correct), 1 = Sign B (incorrect)
  final Set<String> _selectedErrors = {};
  bool _submitted = false;

  late final SignContent? _content;
  late final String _signName;
  /// YouTube ID for Sign B — a random sign that differs from Sign A so the
  /// student has a real video to compare against rather than a placeholder.
  late final String? _distractorYoutubeId;

  final _errorTypes = ['Handshape', 'Movement', 'Placement', 'Expression'];

  @override
  void initState() {
    super.initState();
    final lesson = LessonUnit.findLesson(widget.lessonId);
    _signName = (lesson != null && widget.signIndex < lesson.signs.length)
        ? lesson.signs[widget.signIndex]
        : '';
    _content = SignContent.forSign(_signName);

    // Pick a random sign (different from _signName) that has a YouTube video.
    final candidates = SignContent.allSigns
        .map((sc) => sc.signName)
        .where((name) =>
    name != _signName &&
        SignContent.youtubeIdForSign(name) != null)
        .toList();
    if (candidates.isNotEmpty) {
      candidates.shuffle(Random());
      _distractorYoutubeId = SignContent.youtubeIdForSign(candidates.first);
    } else {
      _distractorYoutubeId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final youtubeId = SignContent.youtubeIdForSign(_signName);

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: LessonProgressBar(
            progress: 4 / 5,
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
                    Text('Error Analysis: $_signName',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Compare both signs — which one is performed incorrectly?',
                        style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 14)),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _submitted ? null : () => setState(() => _selectedSign = 0),
                            child: _buildSignCard(
                              label: 'Sign A',
                              isSelected: _selectedSign == 0,
                              youtubeId: youtubeId,
                              feedback: _submitted && _selectedSign == 0
                                  ? _WrongPickFeedback() : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: _submitted ? null : () => setState(() => _selectedSign = 1),
                            child: _buildSignCard(
                              label: 'Sign B',
                              isSelected: _selectedSign == 1,
                              youtubeId: _distractorYoutubeId,
                              feedback: _submitted && _selectedSign == 1
                                  ? _CorrectPickFeedback() : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text('What is wrong with it?',
                        style: TextStyle(
                            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _errorTypes.map((type) {
                        final selected = _selectedErrors.contains(type);
                        return GestureDetector(
                          onTap: _submitted
                              ? null
                              : () => setState(() {
                            if (_selectedErrors.contains(type)) {
                              _selectedErrors.remove(type);
                            } else {
                              _selectedErrors.add(type);
                            }
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF2196F3).withOpacity(0.2)
                                  : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF2196F3) : const Color(0xFF3A3A3A),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Text(type,
                                style: TextStyle(
                                  color: selected
                                      ? const Color(0xFF2196F3) : Colors.white,
                                  fontSize: 14,
                                  fontWeight: selected
                                      ? FontWeight.w600 : FontWeight.w400,
                                )),
                          ),
                        );
                      }).toList(),
                    ),

                    if (_submitted) ...[
                      const SizedBox(height: 20),
                      Builder(builder: (context) {
                        final isCorrect = _selectedSign == 1;
                        final feedbackColor = isCorrect
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935);
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: feedbackColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: feedbackColor.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCorrect
                                    ? 'Correct! Sign B has the error.'
                                    : 'Not quite — Sign A is actually the correct one.',
                                style: TextStyle(
                                    color: feedbackColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isCorrect
                                    ? (_content?.errorFeedback ??
                                    'Look carefully — small differences in movement or handshape change the meaning completely.')
                                    : 'Sign B is the incorrect one. ${_content?.errorFeedback ?? 'Look carefully at the movement and handshape.'}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14, height: 1.5),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SignlyBottomButton(
              label: _submitted ? 'Continue' : 'Submit',
              onPressed: (_selectedSign == null || _selectedErrors.isEmpty)
                  ? null
                  : () {
                if (!_submitted) {
                  setState(() => _submitted = true);
                  LessonSessionTracker.instance.recordErrorAnalysis(
                      widget.signIndex, _selectedSign == 1);
                  if (_selectedSign != 1) {
                    ProgressService.instance.recordMistake(WeakAreaEntry(
                      signName:    _signName,
                      lessonId:    widget.lessonId,
                      lessonTitle: widget.lessonTitle,
                      unitTitle:   widget.unitTitle,
                      signIndex:   widget.signIndex,
                      type:        MistakeType.errorAnalysis,
                      recordedAt:  DateTime.now(),
                    ));
                  }
                } else {
                  Navigator.pushReplacementNamed(context, '/lesson-camera',
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

  Widget _buildSignCard({
    required String label,
    required bool isSelected,
    String? youtubeId,
    Widget? feedback,
  }) {
    final borderColor = isSelected
        ? (_submitted
        ? (label == 'Sign B' ? const Color(0xFF4CAF50) : const Color(0xFFE53935))
        : const Color(0xFF2196F3))
        : const Color(0xFF3A3A3A);

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          children: [
            Expanded(
              child: youtubeId != null
                  ? SignlyYouTubeMiniPlayer(videoId: youtubeId)
                  : Center(
                  child: Icon(Icons.play_circle_outline,
                      color: const Color(0xFF9E9E9E), size: 40)),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF2A2A2A),
              child: Column(
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  if (feedback != null) feedback,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WrongPickFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 4),
    child: Text('Not this one',
        style: TextStyle(color: const Color(0xFFE53935), fontSize: 12)),
  );
}

class _CorrectPickFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 4),
    child: Icon(Icons.check_circle, color: const Color(0xFF4CAF50), size: 20),
  );
}