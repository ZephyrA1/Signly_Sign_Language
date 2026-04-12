/// In-memory tracker for a single lesson session.
/// Call [start] when a lesson begins, record answers as the user progresses,
/// then call [finish] in the summary screen to get final counts and reset.
class LessonSessionTracker {
  LessonSessionTracker._();
  static final LessonSessionTracker instance = LessonSessionTracker._();

  String? _currentLessonId;

  // Correct signs = signs where ALL three quiz types were answered correctly.
  // We track per-sign per-type so a sign only counts as "learned" if every
  // step was right on first attempt.
  final Map<int, Set<_QuizType>> _correctBySignIndex = {};
  final Map<int, Set<_QuizType>> _attemptedBySignIndex = {};

  int _recognitionCorrect = 0;
  int _recognitionTotal   = 0;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  void start(String lessonId) {
    if (_currentLessonId == lessonId) return; // already tracking this lesson
    _currentLessonId = lessonId;
    _correctBySignIndex.clear();
    _attemptedBySignIndex.clear();
    _recognitionCorrect = 0;
    _recognitionTotal   = 0;
  }

  // ── Recording answers ─────────────────────────────────────────────────────

  void recordRecognition(int signIndex, bool correct) {
    _recognitionTotal++;
    if (correct) _recognitionCorrect++;
    _attempted(signIndex, _QuizType.recognition);
    if (correct) _correct(signIndex, _QuizType.recognition);
  }

  void recordContext(int signIndex, bool correct) {
    _attempted(signIndex, _QuizType.context);
    if (correct) _correct(signIndex, _QuizType.context);
  }

  void recordErrorAnalysis(int signIndex, bool correct) {
    _attempted(signIndex, _QuizType.errorAnalysis);
    if (correct) _correct(signIndex, _QuizType.errorAnalysis);
  }

  // ── Results ───────────────────────────────────────────────────────────────

  /// Signs where all three quiz types were answered correctly first try.
  int get correctSignCount {
    int count = 0;
    for (final index in _correctBySignIndex.keys) {
      final correct  = _correctBySignIndex[index]!;
      final attempted = _attemptedBySignIndex[index]!;
      // A sign is "learned" if every attempted quiz type was correct
      if (correct.length == attempted.length && attempted.isNotEmpty) count++;
    }
    return count;
  }

  int get recognitionCorrect => _recognitionCorrect;
  int get recognitionTotal   => _recognitionTotal;

  /// Resets tracker and returns final counts.
  _SessionResult finish() {
    final result = _SessionResult(
      signsCorrect:        correctSignCount,
      recognitionCorrect:  _recognitionCorrect,
      recognitionTotal:    _recognitionTotal,
    );
    _currentLessonId = null;
    _correctBySignIndex.clear();
    _attemptedBySignIndex.clear();
    _recognitionCorrect = 0;
    _recognitionTotal   = 0;
    return result;
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _attempted(int signIndex, _QuizType type) {
    _attemptedBySignIndex.putIfAbsent(signIndex, () => {}).add(type);
  }

  void _correct(int signIndex, _QuizType type) {
    _correctBySignIndex.putIfAbsent(signIndex, () => {}).add(type);
  }
}

enum _QuizType { recognition, context, errorAnalysis }

class _SessionResult {
  final int signsCorrect;
  final int recognitionCorrect;
  final int recognitionTotal;

  const _SessionResult({
    required this.signsCorrect,
    required this.recognitionCorrect,
    required this.recognitionTotal,
  });
}