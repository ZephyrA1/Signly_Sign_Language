import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../services/auth_service.dart';
import '../../services/session_timer_service.dart';
import '../../widgets/common_widgets.dart';

class StartGoalScreen extends StatefulWidget {
  const StartGoalScreen({super.key});

  @override
  State<StartGoalScreen> createState() => _StartGoalScreenState();
}

class _StartGoalScreenState extends State<StartGoalScreen> {
  Map<String, String> _data = {};
  bool _loading = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _data = Map<String, String>.from(args as Map);
    }
  }

  Future<void> _onBegin() async {
    setState(() { _loading = true; _error = null; });

    final isEditing = _data['isEditing'] == 'true';

    if (isEditing) {
      // Update preferences for existing user
      await AuthService.instance.updatePreferences(
        signLanguage: _data['signLanguage'],
        experience:   _data['experience'],
        purpose:      _data['purpose'],
        dailyGoal:    _data['dailyGoal'],
        level:        _data['level'],
      );
      if (!mounted) return;
      // Pop back to main — learn home will re-read the updated level
      Navigator.popUntil(context, (r) => r.settings.name == '/main' || r.isFirst);
    } else {
      final result = await AuthService.instance.register(
        email:        _data['email'] ?? '',
        username:     _data['username'] ?? '',
        password:     _data['password'] ?? '',
        signLanguage: _data['signLanguage'] ?? 'ASL',
        experience:   _data['experience'] ?? '',
        purpose:      _data['purpose'] ?? '',
        dailyGoal:    _data['dailyGoal'] ?? '10 min',
        level:        _data['level'] ?? 'Beginner',
      );

      if (!mounted) return;

      if (result == AuthResult.success) {
        SessionTimerService.instance.start();
        // Navigate to /main (clearing the auth stack) then immediately push
        // the first lesson so new users land straight on their first lesson.
        final unit   = LessonUnit.sampleUnits.first;
        final lesson = unit.lessons.first;
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        Navigator.pushNamed(context, '/lesson-intro', arguments: {
          'unitTitle':   unit.title,
          'lessonTitle': lesson.title,
          'lessonId':    lesson.id,
        });
      } else {
        setState(() {
          _loading = false;
          _error = switch (result) {
            AuthResult.emailAlreadyExists => 'An account with this email already exists.',
            AuthResult.emptyFields        => 'Missing required fields. Please go back and fill everything in.',
            AuthResult.weakPassword       => 'Password is too short.',
            AuthResult.invalidEmail       => 'Invalid email address.',
            _                             => 'Something went wrong. Please try again.',
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = _data['signLanguage'] ?? 'ASL';
    final purpose  = _data['purpose']?.isNotEmpty == true ? _data['purpose']! : 'Not specified';
    final level    = _data['level'] ?? 'Beginner';
    final goal     = _data['dailyGoal'] ?? '10 min';

    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(child: SignlyProgressBar(value: 1.0, height: 6)),
                const SizedBox(width: 16),
                const Text('Step 2/2',
                    style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 14)),
              ]),
              const SizedBox(height: 32),

              Text(
                _data['isEditing'] == 'true' ? 'Update Your Preferences' : 'Welcome, ${_data['username'] ?? 'there'}! 👋',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Here's your personalized learning plan",
                  style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 15)),
              const SizedBox(height: 28),

              // Summary card with real data
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [const Color(0xFF1565C0), const Color(0xFF2196F3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Learning Path',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildRow(Icons.language, 'Language', language),
                    const SizedBox(height: 12),
                    _buildRow(Icons.school, 'Goal', purpose),
                    const SizedBox(height: 12),
                    _buildRow(Icons.trending_up, 'Level', level),
                    const SizedBox(height: 12),
                    _buildRow(Icons.timer, 'Daily target', goal),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              const Text('Suggested next steps',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              _buildNextStepCard(Icons.play_circle_outline, 'Start $level Unit',
                  'Begin with Greetings and Introductions', true),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE53935).withOpacity(0.4)),
                  ),
                  child: Text(_error!, style: const TextStyle(color: const Color(0xFFE53935), fontSize: 13)),
                ),
              ],

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _onBegin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: _loading
                      ? const SizedBox(width: 24, height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(_data['isEditing'] == 'true' ? 'Save Changes' : "Let's Begin"),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildRow(IconData icon, String label, String value) => Row(children: [
    Icon(icon, color: Colors.white70, size: 20),
    const SizedBox(width: 12),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
    const Spacer(),
    Flexible(
      child: Text(value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis),
    ),
  ]);

  static Widget _buildNextStepCard(IconData icon, String title, String subtitle, bool recommended) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: recommended ? const Color(0xFF2196F3).withOpacity(0.1) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: recommended ? const Color(0xFF2196F3).withOpacity(0.4) : const Color(0xFF3A3A3A),
          ),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: recommended ? const Color(0xFF2196F3).withOpacity(0.2) : const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: recommended ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              if (recommended) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFF2196F3), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Recommended',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ]),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 13)),
          ])),
          const Icon(Icons.chevron_right, color: const Color(0xFF9E9E9E), size: 22),
        ]),
      );
}