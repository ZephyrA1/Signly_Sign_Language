import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds all persisted user progress data.
class UserProgress {
  final Set<String> completedLessonIds;
  final Set<String> learnedSigns;
  final int dayStreak;
  final int totalRecognitionAnswers;
  final int correctRecognitionAnswers;
  final int totalCameraAttempts;
  final int correctCameraAttempts;

  /// ISO-date strings (yyyy-MM-dd) for days practised this week (Mon–Sun).
  final List<bool> activeDaysThisWeek; // index 0 = Monday … 6 = Sunday

  const UserProgress({
    required this.completedLessonIds,
    required this.learnedSigns,
    required this.dayStreak,
    required this.totalRecognitionAnswers,
    required this.correctRecognitionAnswers,
    required this.totalCameraAttempts,
    required this.correctCameraAttempts,
    required this.activeDaysThisWeek,
  });

  static UserProgress empty() => UserProgress(
    completedLessonIds: {},
    learnedSigns: {},
    dayStreak: 0,
    totalRecognitionAnswers: 0,
    correctRecognitionAnswers: 0,
    totalCameraAttempts: 0,
    correctCameraAttempts: 0,
    activeDaysThisWeek: List.filled(7, false),
  );

  int get lessonsCompleted => completedLessonIds.length;
  int get signsLearned => learnedSigns.length;

  /// 0–100 percentage, or null if no data yet.
  int? get interpretationPct => totalRecognitionAnswers == 0
      ? null
      : ((correctRecognitionAnswers / totalRecognitionAnswers) * 100).round();

  int? get productionPct => totalCameraAttempts == 0
      ? null
      : ((correctCameraAttempts / totalCameraAttempts) * 100).round();

  int get daysActiveThisWeek => activeDaysThisWeek.where((d) => d).length;
}

/// Singleton service — call [ProgressService.instance] anywhere.
class ProgressService {
  ProgressService._();
  static final ProgressService instance = ProgressService._();

  static const _keyCompletedLessons = 'completed_lessons';
  static const _keyLearnedSigns = 'learned_signs';
  static const _keyStreak = 'day_streak';
  static const _keyLastActive = 'last_active_date';
  static const _keyActiveDays = 'active_days_week'; // JSON list of 7 bools
  static const _keyWeekStart = 'week_start_date'; // Monday ISO date
  static const _keyTotalRecognition = 'total_recognition';
  static const _keyCorrectRecognition = 'correct_recognition';
  static const _keyTotalCamera = 'total_camera';
  static const _keyCorrectCamera = 'correct_camera';

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<UserProgress> load() async {
    final prefs = await SharedPreferences.getInstance();

    final completedLessons =
    (prefs.getStringList(_keyCompletedLessons) ?? []).toSet();
    final learnedSigns =
    (prefs.getStringList(_keyLearnedSigns) ?? []).toSet();
    final streak = prefs.getInt(_keyStreak) ?? 0;
    final totalRec = prefs.getInt(_keyTotalRecognition) ?? 0;
    final correctRec = prefs.getInt(_keyCorrectRecognition) ?? 0;
    final totalCam = prefs.getInt(_keyTotalCamera) ?? 0;
    final correctCam = prefs.getInt(_keyCorrectCamera) ?? 0;

    final activeDays = _loadActiveDays(prefs);

    return UserProgress(
      completedLessonIds: completedLessons,
      learnedSigns: learnedSigns,
      dayStreak: streak,
      totalRecognitionAnswers: totalRec,
      correctRecognitionAnswers: correctRec,
      totalCameraAttempts: totalCam,
      correctCameraAttempts: correctCam,
      activeDaysThisWeek: activeDays,
    );
  }

  // ── Write: lesson completed ───────────────────────────────────────────────

  Future<void> recordLessonCompleted({
    required String lessonId,
    required List<String> signsLearned,
    int recognitionTotal = 0,
    int recognitionCorrect = 0,
    int cameraTotal = 0,
    int cameraCorrect = 0,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Completed lessons
    final completed =
    (prefs.getStringList(_keyCompletedLessons) ?? []).toSet();
    completed.add(lessonId);
    await prefs.setStringList(_keyCompletedLessons, completed.toList());

    // Learned signs
    final signs = (prefs.getStringList(_keyLearnedSigns) ?? []).toSet();
    signs.addAll(signsLearned);
    await prefs.setStringList(_keyLearnedSigns, signs.toList());

    // Recognition stats
    await prefs.setInt(_keyTotalRecognition,
        (prefs.getInt(_keyTotalRecognition) ?? 0) + recognitionTotal);
    await prefs.setInt(_keyCorrectRecognition,
        (prefs.getInt(_keyCorrectRecognition) ?? 0) + recognitionCorrect);

    // Camera stats
    await prefs.setInt(_keyTotalCamera,
        (prefs.getInt(_keyTotalCamera) ?? 0) + cameraTotal);
    await prefs.setInt(_keyCorrectCamera,
        (prefs.getInt(_keyCorrectCamera) ?? 0) + cameraCorrect);

    // Streak + activity
    await _recordActivity(prefs);
  }

  // ── Streak & weekly activity ──────────────────────────────────────────────

  Future<void> _recordActivity(SharedPreferences prefs) async {
    final today = _todayString();
    final lastActive = prefs.getString(_keyLastActive);

    int streak = prefs.getInt(_keyStreak) ?? 0;

    if (lastActive == null) {
      // First ever session
      streak = 1;
    } else if (lastActive == today) {
      // Already recorded today — don't double-count streak
    } else if (_isYesterday(lastActive, today)) {
      streak += 1;
    } else {
      // Gap of 2+ days — reset
      streak = 1;
    }

    await prefs.setInt(_keyStreak, streak);
    await prefs.setString(_keyLastActive, today);

    // Weekly activity
    await _updateWeeklyActivity(prefs, today);
  }

  Future<void> _updateWeeklyActivity(
      SharedPreferences prefs, String today) async {
    final mondayOfThisWeek = _mondayOf(today);
    final storedWeekStart = prefs.getString(_keyWeekStart);

    List<bool> days;
    if (storedWeekStart != mondayOfThisWeek) {
      // New week — reset
      days = List.filled(7, false);
      await prefs.setString(_keyWeekStart, mondayOfThisWeek);
    } else {
      days = _loadActiveDays(prefs);
    }

    // Mark today
    final dayIndex = _dayIndexOf(today); // 0=Mon … 6=Sun
    if (dayIndex >= 0 && dayIndex < 7) {
      days[dayIndex] = true;
    }

    await prefs.setString(_keyActiveDays, jsonEncode(days));
  }

  List<bool> _loadActiveDays(SharedPreferences prefs) {
    final raw = prefs.getString(_keyActiveDays);
    if (raw == null) return List.filled(7, false);
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => e as bool).toList();
    } catch (_) {
      return List.filled(7, false);
    }
  }

  // ── Date helpers ──────────────────────────────────────────────────────────

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool _isYesterday(String prev, String today) {
    try {
      final prevDate = DateTime.parse(prev);
      final todayDate = DateTime.parse(today);
      return todayDate.difference(prevDate).inDays == 1;
    } catch (_) {
      return false;
    }
  }

  String _mondayOf(String dateString) {
    final date = DateTime.parse(dateString);
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  /// 0 = Monday … 6 = Sunday
  int _dayIndexOf(String dateString) {
    try {
      return DateTime.parse(dateString).weekday - 1;
    } catch (_) {
      return -1;
    }
  }

  // ── Reset (for testing) ───────────────────────────────────────────────────

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}