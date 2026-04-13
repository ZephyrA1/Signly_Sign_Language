import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

/// Tracks time spent in the app today, per logged-in user.
/// Call [start] when the app comes to foreground, [pause] when it goes to background.
/// [elapsedTodaySeconds] is always up to date.
class SessionTimerService {
  SessionTimerService._();
  static final SessionTimerService instance = SessionTimerService._();

  Timer? _ticker;
  DateTime? _sessionStart;

  /// Seconds accumulated today before the current session.
  int _savedSecondsToday = 0;

  /// Key is per-user and per-date so it resets automatically each new day.
  String get _key {
    final email = AuthService.instance.currentUser?.email ?? 'guest';
    final today = _todayString();
    return 'session_time_${email}_$today';
  }

  /// Total seconds spent in app today (saved + current session).
  int get elapsedTodaySeconds {
    final sessionSeconds = _sessionStart != null
        ? DateTime.now().difference(_sessionStart!).inSeconds
        : 0;
    return _savedSecondsToday + sessionSeconds;
  }

  int get elapsedTodayMinutes => elapsedTodaySeconds ~/ 60;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  /// Load saved time and start counting. Call when app comes to foreground.
  Future<void> start() async {
    await _loadSaved();
    _sessionStart = DateTime.now();
    _ticker?.cancel();
    // Save to prefs every 30 seconds so data survives a force-quit
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => _persist());
  }

  /// Pause counting and persist. Call when app goes to background.
  Future<void> pause() async {
    _ticker?.cancel();
    _ticker = null;
    await _persist();
    _savedSecondsToday = elapsedTodaySeconds;
    _sessionStart = null;
  }

  /// Stream of elapsed seconds — used by the UI to rebuild every second.
  Stream<int> get tickStream =>
      Stream.periodic(const Duration(seconds: 1), (_) => elapsedTodaySeconds);

  // ── Persistence ───────────────────────────────────────────────────────────

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    _savedSecondsToday = prefs.getInt(_key) ?? 0;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, elapsedTodaySeconds);
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}