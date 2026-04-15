import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

/// Tracks time spent in the app today, per logged-in user.
/// Call [start] when the app comes to foreground, [pause] when it goes to background.
/// [elapsedTodaySeconds] is always up to date.
///
/// Separately, [lessonElapsedTodaySeconds] tracks only time spent inside
/// lesson screens. Use [startLessonSession] / [endLessonSession] (driven by
/// the navigator observer in main.dart) to accumulate that value.
class SessionTimerService {
  SessionTimerService._();
  static final SessionTimerService instance = SessionTimerService._();

  Timer? _ticker;
  DateTime? _sessionStart;

  /// Seconds accumulated today before the current session.
  int _savedSecondsToday = 0;

  // Lesson-specific tracking

  int _lessonSavedSecondsToday = 0;
  DateTime? _lessonStart;

  /// Key is per-user and per-date so it resets automatically each new day.
  String get _key {
    final email = AuthService.instance.currentUser?.email ?? 'guest';
    final today = _todayString();
    return 'session_time_${email}_$today';
  }

  String get _lessonKey {
    final email = AuthService.instance.currentUser?.email ?? 'guest';
    final today = _todayString();
    return 'lesson_time_${email}_$today';
  }

  /// Total seconds spent in app today (saved + current session).
  int get elapsedTodaySeconds {
    final sessionSeconds = _sessionStart != null
        ? DateTime.now().difference(_sessionStart!).inSeconds
        : 0;
    return _savedSecondsToday + sessionSeconds;
  }

  int get elapsedTodayMinutes => elapsedTodaySeconds ~/ 60;

  /// Seconds spent inside lesson screens today.
  int get lessonElapsedTodaySeconds {
    final lessonSeconds = _lessonStart != null
        ? DateTime.now().difference(_lessonStart!).inSeconds
        : 0;
    return _lessonSavedSecondsToday + lessonSeconds;
  }

  /// Stream of lesson-elapsed seconds (ticks every second).
  Stream<int> get lessonTickStream =>
      Stream.periodic(const Duration(seconds: 1), (_) => lessonElapsedTodaySeconds);

  /// Called by the navigator observer when the user enters a lesson route.
  void startLessonSession() {
    if (_lessonStart != null) return; // already counting
    _lessonStart = DateTime.now();
  }

  /// Called by the navigator observer when the user leaves all lesson routes.
  void endLessonSession() {
    if (_lessonStart == null) return;
    _lessonSavedSecondsToday = lessonElapsedTodaySeconds;
    _lessonStart = null;
    _persistLesson(); // fire-and-forget
  }



  /// Load saved time and start counting
  Future<void> start() async {
    await _loadSaved();
    await _loadLessonSaved();
    _sessionStart = DateTime.now();
    _ticker?.cancel();
    // Save to prefs every 30 seconds so data survives a force-quit
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      _persist();
      if (_lessonStart != null) _persistLesson();
    });
  }

  /// Pause counting and persist
  Future<void> pause() async {
    _ticker?.cancel();
    _ticker = null;
    await _persist();
    _savedSecondsToday = elapsedTodaySeconds;
    _sessionStart = null;
    if (_lessonStart != null) endLessonSession();
  }

  /// Stream of elapsed seconds
  Stream<int> get tickStream =>
      Stream.periodic(const Duration(seconds: 1), (_) => elapsedTodaySeconds);



  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    _savedSecondsToday = prefs.getInt(_key) ?? 0;
  }

  Future<void> _loadLessonSaved() async {
    final prefs = await SharedPreferences.getInstance();
    _lessonSavedSecondsToday = prefs.getInt(_lessonKey) ?? 0;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, elapsedTodaySeconds);
  }

  Future<void> _persistLesson() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lessonKey, lessonElapsedTodaySeconds);
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}