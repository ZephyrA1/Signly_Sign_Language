import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import 'dart:async';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/session_timer_service.dart';
import '../../widgets/common_widgets.dart';

class LearnHomeScreen extends StatefulWidget {
  const LearnHomeScreen({super.key});

  @override
  State<LearnHomeScreen> createState() => _LearnHomeScreenState();
}

class _LearnHomeScreenState extends State<LearnHomeScreen> {
  /// Tracks which unit cards are currently expanded.
  final Set<String> _expandedUnits = {};

  // Daily goal timer
  int _elapsedSeconds = 0;
  StreamSubscription<int>? _timerSub;

  // Lesson progress
  Set<String> _completedLessonIds = {};
  Map<String, double> _unitProgress = {};

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = SessionTimerService.instance.lessonElapsedTodaySeconds;
    _timerSub = SessionTimerService.instance.lessonTickStream.listen((seconds) {
      if (mounted) setState(() => _elapsedSeconds = seconds);
    });
    ProgressService.instance.addListener(_onProgressChanged);
    _loadProgress();
  }

  @override
  void dispose() {
    _timerSub?.cancel();
    ProgressService.instance.removeListener(_onProgressChanged);
    super.dispose();
  }

  void _onProgressChanged() => _loadProgress();

  Future<void> _loadProgress() async {
    final progress = await ProgressService.instance.load();
    final completedIds = progress.completedLessonIds;
    final computed = <String, double>{};
    for (final unit in LessonUnit.sampleUnits) {
      final done = unit.lessons.where((l) => completedIds.contains(l.id)).length;
      computed[unit.id] = unit.lessons.isEmpty ? 0.0 : done / unit.lessons.length;
    }
    if (mounted) {
      setState(() {
        _completedLessonIds = completedIds;
        _unitProgress = computed;
      });
    }
  }


  /// Returns units reordered based on the user's learning level.
  List<LessonUnit> get _orderedUnits {
    final level = AuthService.instance.currentUser?.level ?? 'Beginner';
    final all = LessonUnit.sampleUnits;

    // Map unit IDs to units for easy lookup
    final byId = {for (final u in all) u.id: u};

    List<String> order;
    switch (level) {
      case 'Elementary':
        order = ['u2', 'u4', 'u3', 'u1']; // Everyday, Family, School, Greetings
        break;
      case 'Intermediate':
        order = ['u4', 'u3', 'u2', 'u1']; // Family, School, Everyday, Greetings
        break;
      default: // Beginner
        order = ['u1', 'u2', 'u4', 'u3']; // Greetings, Everyday, Family, School
    }

    return order.map((id) => byId[id]!).toList();
  }

  void _toggleUnit(String unitId) {
    setState(() {
      if (_expandedUnits.contains(unitId)) {
        _expandedUnits.remove(unitId);
      } else {
        _expandedUnits.add(unitId);
      }
    });
  }

  void _startLesson(BuildContext context, LessonUnit unit, UnitLesson lesson) {
    Navigator.pushNamed(
      context,
      '/lesson-intro',
      arguments: {
        'unitTitle': unit.title,
        'lessonTitle': lesson.title,
        'lessonId': lesson.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top greeting
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Continue your sign language journey',
                          style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily goal progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildDailyGoalCard(),
            ),
            const SizedBox(height: 24),

            // Continue Learning section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SignlySectionTitle(title: 'Continue Learning'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildContinueLearningCard(context),
            ),
            const SizedBox(height: 24),

            // Units section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SignlySectionTitle(title: 'Units'),
            ),
            const SizedBox(height: 12),
            ..._orderedUnits.map((unit) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _buildUnitCard(context, unit),
              );
            }),
            const SizedBox(height: 12),

            // Culture note shortcut
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/deaf-culture'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.public, color: const Color(0xFF2196F3), size: 22),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Explore Deaf Culture & Communication',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: const Color(0xFF9E9E9E), size: 22),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _greeting() {
    final hour = DateTime.now().hour;
    final name = AuthService.instance.currentUser?.username ?? '';
    final suffix = name.isNotEmpty ? ', $name!' : '!';
    if (hour < 12) return 'Good morning$suffix 👋';
    if (hour < 17) return 'Good afternoon$suffix 👋';
    return 'Good evening$suffix 👋';
  }


  Widget _buildDailyGoalCard() {
    // Parse goal from user preferences e.g. "10 min" -> 10
    final goalStr = AuthService.instance.currentUser?.dailyGoal ?? '10 min';
    final goalMinutes = int.tryParse(goalStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 10;
    final goalSeconds = goalMinutes * 60;

    final elapsedMinutes = _elapsedSeconds ~/ 60;
    final remainingSeconds = _elapsedSeconds % 60;
    final progress = (_elapsedSeconds / goalSeconds).clamp(0.0, 1.0);
    final isComplete = _elapsedSeconds >= goalSeconds;

    final displayTime = elapsedMinutes > 0
        ? '${elapsedMinutes}m ${remainingSeconds.toString().padLeft(2, '0')}s'
        : '${_elapsedSeconds}s';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [const Color(0xFF1565C0), const Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(children: [
            Icon(
              isComplete ? Icons.check_circle : Icons.local_fire_department,
              color: isComplete ? const Color(0xFF4CAF50) : Colors.orange,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text('Daily Goal',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(
              isComplete ? 'Goal reached!' : '$displayTime / $goalMinutes min',
              style: TextStyle(
                color: isComplete ? const Color(0xFF4CAF50) : Colors.white70,
                fontSize: 14,
                fontWeight: isComplete ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? const Color(0xFF4CAF50) : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.bolt, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(
              isComplete
                  ? 'Daily goal complete!'
                  : '${((1 - progress) * goalMinutes).ceil()} min remaining',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContinueLearningCard(BuildContext context) {
    // Walk the user's ordered units to find the first uncompleted lesson.
    LessonUnit nextUnit = _orderedUnits.first;
    UnitLesson nextLesson = nextUnit.lessons.first;
    outer:
    for (final unit in _orderedUnits) {
      for (final lesson in unit.lessons) {
        if (!_completedLessonIds.contains(lesson.id)) {
          nextUnit = unit;
          nextLesson = lesson;
          break outer;
        }
      }
    }

    final unitProgress = _unitProgress[nextUnit.id] ?? 0.0;
    final pct = (unitProgress * 100).toInt();

    return GestureDetector(
      onTap: () => _startLesson(context, nextUnit, nextLesson),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: const Color(0xFF2196F3), size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextLesson.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${nextUnit.title} · ${nextLesson.duration} · $pct% complete',
                    style: const TextStyle(
                        color: const Color(0xFF9E9E9E), fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SignlyProgressBar(value: unitProgress, height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitCard(BuildContext context, LessonUnit unit) {
    final isExpanded = _expandedUnits.contains(unit.id);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          // Unit header — tapping toggles expansion
          GestureDetector(
            onTap: () => _toggleUnit(unit.id),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          unit.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${unit.lessonCount} lessons',
                          style: const TextStyle(
                            color: const Color(0xFF2196F3),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down,
                            color: const Color(0xFF9E9E9E), size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    unit.subtitle,
                    style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Skill focus: ${unit.skillFocus}',
                    style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  SignlyProgressBar(
                      value: _unitProgress[unit.id] ?? 0.0, height: 4),
                  const SizedBox(height: 6),
                  Text(
                    '${((_unitProgress[unit.id] ?? 0.0) * 100).toInt()}% complete',
                    style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Expandable lesson list
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildLessonList(context, unit),
            crossFadeState:
            isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonList(BuildContext context, LessonUnit unit) {
    return Column(
      children: [
        const Divider(
          color: const Color(0xFF3A3A3A),
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        ...unit.lessons.asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;
          final isLast = index == unit.lessons.length - 1;
          return _buildLessonRow(
            context: context,
            unit: unit,
            lesson: lesson,
            lessonNumber: index + 1,
            isLast: isLast,
          );
        }),
      ],
    );
  }

  Widget _buildLessonRow({
    required BuildContext context,
    required LessonUnit unit,
    required UnitLesson lesson,
    required int lessonNumber,
    required bool isLast,
  }) {
    return GestureDetector(
      onTap: () => _startLesson(context, unit, lesson),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
            bottom: BorderSide(color: const Color(0xFF3A3A3A), width: 0.5),
          ),
          borderRadius: isLast
              ? const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Lesson number badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Center(
                child: Text(
                  '$lessonNumber',
                  style: const TextStyle(
                    color: const Color(0xFF9E9E9E),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Title + signs
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (lesson.signs.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: lesson.signs
                          .map((sign) => _SignPill(sign: sign))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Duration + chevron
            Text(
              lesson.duration,
              style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 12),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: const Color(0xFF9E9E9E), size: 18),
          ],
        ),
      ),
    );
  }
}

/// Small pill showing a sign name within a lesson row.
class _SignPill extends StatelessWidget {
  final String sign;
  const _SignPill({required this.sign});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.25)),
      ),
      child: Text(
        sign,
        style: const TextStyle(
          color: Color(0xFF64B5F6),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}