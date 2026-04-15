import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount {
  final String email;
  final String username;
  final String passwordHash;

  // Learning preferences
  final String signLanguage;     // e.g. 'ASL'
  final String experience;       // e.g. 'New to sign language'
  final String purpose;          // e.g. 'For school'
  final String dailyGoal;        // e.g. '10 min'
  final String level;            // e.g. 'Beginner'

  const UserAccount({
    required this.email,
    required this.username,
    required this.passwordHash,
    required this.signLanguage,
    required this.experience,
    required this.purpose,
    required this.dailyGoal,
    required this.level,
  });

  UserAccount copyWith({
    String? signLanguage,
    String? experience,
    String? purpose,
    String? dailyGoal,
    String? level,
    String? username,
  }) => UserAccount(
    email: email,
    username: username ?? this.username,
    passwordHash: passwordHash,
    signLanguage: signLanguage ?? this.signLanguage,
    experience: experience ?? this.experience,
    purpose: purpose ?? this.purpose,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    level: level ?? this.level,
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'passwordHash': passwordHash,
    'signLanguage': signLanguage,
    'experience': experience,
    'purpose': purpose,
    'dailyGoal': dailyGoal,
    'level': level,
  };

  factory UserAccount.fromJson(Map<String, dynamic> j) => UserAccount(
    email: j['email'] as String,
    username: j['username'] as String,
    passwordHash: j['passwordHash'] as String,
    signLanguage: j['signLanguage'] as String? ?? 'ASL',
    experience: j['experience'] as String? ?? '',
    purpose: j['purpose'] as String? ?? '',
    dailyGoal: j['dailyGoal'] as String? ?? '10 min',
    level: j['level'] as String? ?? 'Beginner',
  );
}

enum AuthResult {
  success,
  emailAlreadyExists,
  userNotFound,
  wrongPassword,
  emptyFields,
  weakPassword,
  invalidEmail,
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _keyAccounts     = 'accounts';
  static const _keyLoggedInEmail = 'logged_in_email';

  UserAccount? _currentUser;
  UserAccount? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ── Initialise (call from main before runApp) ─────────────────────────────

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyLoggedInEmail);
    if (email != null) {
      _currentUser = await _findAccount(email);
    }
  }

  // ── Register ──────────────────────────────────────────────────────────────

  Future<AuthResult> register({
    required String email,
    required String username,
    required String password,
    required String signLanguage,
    required String experience,
    required String purpose,
    required String dailyGoal,
    required String level,
  }) async {
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      return AuthResult.emptyFields;
    }
    if (!email.contains('@') || !email.contains('.')) {
      return AuthResult.invalidEmail;
    }
    if (password.length < 6) return AuthResult.weakPassword;

    final existing = await _findAccount(email.toLowerCase().trim());
    if (existing != null) return AuthResult.emailAlreadyExists;

    final account = UserAccount(
      email: email.toLowerCase().trim(),
      username: username.trim(),
      passwordHash: _hash(password),
      signLanguage: signLanguage,
      experience: experience,
      purpose: purpose,
      dailyGoal: dailyGoal,
      level: level,
    );

    await _saveAccount(account);
    await _setLoggedIn(account);
    return AuthResult.success;
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) return AuthResult.emptyFields;

    final account = await _findAccount(email.toLowerCase().trim());
    if (account == null) return AuthResult.userNotFound;
    if (account.passwordHash != _hash(password)) return AuthResult.wrongPassword;

    await _setLoggedIn(account);
    return AuthResult.success;
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedInEmail);
  }

  // ── Update preferences ────────────────────────────────────────────────────

  Future<void> updatePreferences({
    String? signLanguage,
    String? experience,
    String? purpose,
    String? dailyGoal,
    String? level,
    String? username,
  }) async {
    if (_currentUser == null) return;
    final updated = _currentUser!.copyWith(
      signLanguage: signLanguage,
      experience: experience,
      purpose: purpose,
      dailyGoal: dailyGoal,
      level: level,
      username: username,
    );
    await _saveAccount(updated);
    _currentUser = updated;
  }



  Future<void> _setLoggedIn(UserAccount account) async {
    _currentUser = account;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLoggedInEmail, account.email);
  }

  Future<UserAccount?> _findAccount(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('${_keyAccounts}_$email');
    if (raw == null) return null;
    try {
      return UserAccount.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveAccount(UserAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_keyAccounts}_${account.email}',
      jsonEncode(account.toJson()),
    );
  }

  /// Very simple hash good enough for local storage demo.
  String _hash(String input) {
    int hash = 5381;
    for (final ch in input.codeUnits) {
      hash = ((hash << 5) + hash) ^ ch;
      hash &= 0x7FFFFFFF;
    }
    return hash.toRadixString(16);
  }
}