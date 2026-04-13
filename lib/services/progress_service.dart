import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

// ── Weak area entry ───────────────────────────────────────────────────────────

enum MistakeType { recognition, context, errorAnalysis }

class WeakAreaEntry {
  final String signName;
  final String lessonId;
  final String lessonTitle;
  final String unitTitle;
  final int signIndex;
  final MistakeType type;
  final DateTime recordedAt;

  WeakAreaEntry({
    required this.signName,
    required this.lessonId,
    required this.lessonTitle,
    required this.unitTitle,
    required this.signIndex,
    required this.type,
    required this.recordedAt,
  });

  String get typeLabel {
    switch (type) {
      case MistakeType.recognition:   return 'Recognition';
      case MistakeType.context:       return 'Context';
      case MistakeType.errorAnalysis: return 'Error Analysis';
    }
  }

  Map<String, dynamic> toJson() => {
    'signName':    signName,
    'lessonId':    lessonId,
    'lessonTitle': lessonTitle,
    'unitTitle':   unitTitle,
    'signIndex':   signIndex,
    'type':        type.index,
    'recordedAt':  recordedAt.toIso8601String(),
  };

  factory WeakAreaEntry.fromJson(Map<String, dynamic> j) => WeakAreaEntry(
    signName:    j['signName']    as String,
    lessonId:    j['lessonId']    as String,
    lessonTitle: j['lessonTitle'] as String,
    unitTitle:   j['unitTitle']   as String,
    signIndex:   j['signIndex']   as int,
    type:        MistakeType.values[j['type'] as int],
    recordedAt:  DateTime.parse(j['recordedAt'] as String),
  );

  String get key => '${lessonId}_${signIndex}_${type.index}';
}

// ── User progress snapshot ────────────────────────────────────────────────────

class UserProgress {
  final Set<String> completedLessonIds;
  final Set<String> learnedSigns;
  final int dayStreak;
  final int totalRecognitionAnswers;
  final int correctRecognitionAnswers;
  final int totalCameraAttempts;
  final int correctCameraAttempts;
  final List<bool> activeDaysThisWeek;

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
  int get signsLearned     => learnedSigns.length;

  int? get interpretationPct => totalRecognitionAnswers == 0
      ? null
      : ((correctRecognitionAnswers / totalRecognitionAnswers) * 100).round();

  int? get productionPct => totalCameraAttempts == 0
      ? null
      : ((correctCameraAttempts / totalCameraAttempts) * 100).round();

  int get daysActiveThisWeek => activeDaysThisWeek.where((d) => d).length;
}

// ── Service ───────────────────────────────────────────────────────────────────

class ProgressService {
  ProgressService._();
  static final ProgressService instance = ProgressService._();

  // All keys are prefixed with the logged-in user's email so each account
  // has completely isolated progress data on the same device.
  String get _prefix {
    final email = AuthService.instance.currentUser?.email ?? 'guest';
    return 'progress_${email}_';
  }

  String get _keyCompletedLessons   => '${_prefix}completed_lessons';
  String get _keyLearnedSigns       => '${_prefix}learned_signs';
  String get _keyStreak             => '${_prefix}day_streak';
  String get _keyLastActive         => '${_prefix}last_active_date';
  String get _keyActiveDays         => '${_prefix}active_days_week';
  String get _keyWeekStart          => '${_prefix}week_start_date';
  String get _keyTotalRecognition   => '${_prefix}total_recognition';
  String get _keyCorrectRecognition => '${_prefix}correct_recognition';
  String get _keyTotalCamera        => '${_prefix}total_camera';
  String get _keyCorrectCamera      => '${_prefix}correct_camera';
  String get _keyWeakAreas          => '${_prefix}weak_areas';

  // ── Read progress ─────────────────────────────────────────────────────────

  Future<UserProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    return UserProgress(
      completedLessonIds:        (prefs.getStringList(_keyCompletedLessons) ?? []).toSet(),
      learnedSigns:              (prefs.getStringList(_keyLearnedSigns) ?? []).toSet(),
      dayStreak:                 prefs.getInt(_keyStreak) ?? 0,
      totalRecognitionAnswers:   prefs.getInt(_keyTotalRecognition) ?? 0,
      correctRecognitionAnswers: prefs.getInt(_keyCorrectRecognition) ?? 0,
      totalCameraAttempts:       prefs.getInt(_keyTotalCamera) ?? 0,
      correctCameraAttempts:     prefs.getInt(_keyCorrectCamera) ?? 0,
      activeDaysThisWeek:        _loadActiveDays(prefs),
    );
  }

  // ── Read weak areas ───────────────────────────────────────────────────────

  Future<List<WeakAreaEntry>> loadWeakAreas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyWeakAreas);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => WeakAreaEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    } catch (_) {
      return [];
    }
  }

  // ── Record a mistake ──────────────────────────────────────────────────────

  Future<void> recordMistake(WeakAreaEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadWeakAreas();
    final map = {for (final e in existing) e.key: e};
    map[entry.key] = entry;
    await prefs.setString(
      _keyWeakAreas,
      jsonEncode(map.values.map((e) => e.toJson()).toList()),
    );
  }

  // ── Dismiss a weak area ───────────────────────────────────────────────────

  Future<void> dismissWeakArea(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadWeakAreas();
    final filtered = existing.where((e) => e.key != key).toList();
    await prefs.setString(
      _keyWeakAreas,
      jsonEncode(filtered.map((e) => e.toJson()).toList()),
    );
  }

  // ── Record lesson completed ───────────────────────────────────────────────

  Future<void> recordLessonCompleted({
    required String lessonId,
    required List<String> signsLearned,
    int recognitionTotal = 0,
    int recognitionCorrect = 0,
    int cameraTotal = 0,
    int cameraCorrect = 0,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final completed = (prefs.getStringList(_keyCompletedLessons) ?? []).toSet();
    completed.add(lessonId);
    await prefs.setStringList(_keyCompletedLessons, completed.toList());

    final signs = (prefs.getStringList(_keyLearnedSigns) ?? []).toSet();
    signs.addAll(signsLearned);
    await prefs.setStringList(_keyLearnedSigns, signs.toList());

    await prefs.setInt(_keyTotalRecognition,
        (prefs.getInt(_keyTotalRecognition) ?? 0) + recognitionTotal);
    await prefs.setInt(_keyCorrectRecognition,
        (prefs.getInt(_keyCorrectRecognition) ?? 0) + recognitionCorrect);
    await prefs.setInt(_keyTotalCamera,
        (prefs.getInt(_keyTotalCamera) ?? 0) + cameraTotal);
    await prefs.setInt(_keyCorrectCamera,
        (prefs.getInt(_keyCorrectCamera) ?? 0) + cameraCorrect);

    await _recordActivity(prefs);
  }

  // ── Streak & weekly activity ──────────────────────────────────────────────

  Future<void> _recordActivity(SharedPreferences prefs) async {
    final today = _todayString();
    final lastActive = prefs.getString(_keyLastActive);
    int streak = prefs.getInt(_keyStreak) ?? 0;

    if (lastActive == null) {
      streak = 1;
    } else if (lastActive == today) {
      // no-op
    } else if (_isYesterday(lastActive, today)) {
      streak += 1;
    } else {
      streak = 1;
    }

    await prefs.setInt(_keyStreak, streak);
    await prefs.setString(_keyLastActive, today);
    await _updateWeeklyActivity(prefs, today);
  }

  Future<void> _updateWeeklyActivity(SharedPreferences prefs, String today) async {
    final mondayOfThisWeek = _mondayOf(today);
    final storedWeekStart  = prefs.getString(_keyWeekStart);
    List<bool> days;

    if (storedWeekStart != mondayOfThisWeek) {
      days = List.filled(7, false);
      await prefs.setString(_keyWeekStart, mondayOfThisWeek);
    } else {
      days = _loadActiveDays(prefs);
    }

    final dayIndex = _dayIndexOf(today);
    if (dayIndex >= 0 && dayIndex < 7) days[dayIndex] = true;
    await prefs.setString(_keyActiveDays, jsonEncode(days));
  }

  List<bool> _loadActiveDays(SharedPreferences prefs) {
    final raw = prefs.getString(_keyActiveDays);
    if (raw == null) return List.filled(7, false);
    try {
      return (jsonDecode(raw) as List).map((e) => e as bool).toList();
    } catch (_) {
      return List.filled(7, false);
    }
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool _isYesterday(String prev, String today) {
    try {
      final p = DateTime.parse(prev);
      final t = DateTime.parse(today);
      return t.difference(p).inDays == 1;
    } catch (_) { return false; }
  }

  String _mondayOf(String dateString) {
    final date   = DateTime.parse(dateString);
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  int _dayIndexOf(String dateString) {
    try { return DateTime.parse(dateString).weekday - 1; }
    catch (_) { return -1; }
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    // Only clear this user's keys
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}