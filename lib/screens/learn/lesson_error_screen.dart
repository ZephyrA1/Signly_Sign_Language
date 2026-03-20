import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../widgets/common_widgets.dart';

/// RLO Type 4: Error Analysis / Error Detective
/// A Reusable Learning Object that develops critical thinking by
/// requiring learners to compare two sign performances and identify
/// the incorrect one, then classify the type of error (handshape,
/// movement, placement, or expression).
/// Bloom's Taxonomy Level: Analyze & Evaluate
/// UDL: Multiple means of representation (side-by-side comparison)
class LessonErrorScreen extends StatefulWidget {
  final String lessonTitle;
  final String lessonId;

  const LessonErrorScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonId,
  });

  @override
  State<LessonErrorScreen> createState() => _LessonErrorScreenState();
}

class _LessonErrorScreenState extends State<LessonErrorScreen> {
  int? _selectedSign; // 0 = left (Sign A = correct), 1 = right (Sign B = incorrect)
  String? _selectedError;
  bool _submitted = false;

  final _errorTypes = ['Handshape', 'Movement', 'Placement', 'Expression'];

  @override
  Widget build(BuildContext context) {
    final correctPath = LessonVideoMap.correctVideo(widget.lessonId);
    final incorrectPath = LessonVideoMap.incorrectVideo(widget.lessonId);
    final hasVideos = correctPath != null && incorrectPath != null;

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            LessonProgressBar(
              progress: 4 / 6,
              onClose: () => Navigator.popUntil(context,
                  (route) => route.settings.name == '/main' || route.isFirst),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error Analysis',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Compare both signs - which one is performed incorrectly?',
                      style:
                          TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // ── Two sign demonstrations side by side ──
                    Row(
                      children: [
                        // Sign A (correct)
                        Expanded(
                          child: GestureDetector(
                            onTap: _submitted
                                ? null
                                : () => setState(() => _selectedSign = 0),
                            child: _buildSignCard(
                              label: 'Sign A',
                              isSelected: _selectedSign == 0,
                              videoPath: hasVideos ? correctPath : null,
                              feedbackWhenSubmitted: _submitted && _selectedSign == 0
                                  ? _WrongPickFeedback()
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Sign B (incorrect)
                        Expanded(
                          child: GestureDetector(
                            onTap: _submitted
                                ? null
                                : () => setState(() => _selectedSign = 1),
                            child: _buildSignCard(
                              label: 'Sign B',
                              isSelected: _selectedSign == 1,
                              videoPath: hasVideos ? incorrectPath : null,
                              feedbackWhenSubmitted: _submitted && _selectedSign == 1
                                  ? _CorrectPickFeedback()
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Error type selection ──
                    const Text(
                      'What is wrong with it?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _errorTypes.map((type) {
                        final selected = _selectedError == type;
                        return GestureDetector(
                          onTap: _submitted
                              ? null
                              : () =>
                                  setState(() => _selectedError = type),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF2196F3)
                                      .withOpacity(0.2)
                                  : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF2196F3)
                                    : const Color(0xFF3A3A3A),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: selected
                                    ? const Color(0xFF2196F3)
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // ── Feedback after submit ──
                    if (_submitted) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  const Color(0xFF4CAF50).withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Correct! Sign B has the error.',
                              style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'The movement in Sign B is too fast and doesn\'t follow the correct arc. The hand should move smoothly away from the forehead, not snap forward.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5),
                            ),
                          ],
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
              onPressed:
                  (_selectedSign == null || _selectedError == null)
                      ? null
                      : () {
                          if (!_submitted) {
                            setState(() => _submitted = true);
                          } else {
                            Navigator.pushReplacementNamed(
                                context, '/lesson-camera',
                                arguments: {
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

  /// Builds one of the two side-by-side sign cards.
  Widget _buildSignCard({
    required String label,
    required bool isSelected,
    String? videoPath,
    Widget? feedbackWhenSubmitted,
  }) {
    final borderColor = isSelected
        ? (_submitted
            ? (label == 'Sign B'
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE53935))
            : const Color(0xFF2196F3))
        : const Color(0xFF3A3A3A);

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          children: [
            // Video or placeholder area
            Expanded(
              child: videoPath != null
                  ? SignlyMiniVideoPlayer(
                      assetPath: videoPath,
                      autoPlay: false,
                    )
                  : Center(
                      child: Icon(Icons.play_circle_outline,
                          color: const Color(0xFF9E9E9E), size: 40),
                    ),
            ),
            // Label + feedback
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF2A2A2A),
              child: Column(
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  if (feedbackWhenSubmitted != null) feedbackWhenSubmitted,
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
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: Text('Not this one',
          style: TextStyle(color: Color(0xFFE53935), fontSize: 12)),
    );
  }
}

class _CorrectPickFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
    );
  }
}
