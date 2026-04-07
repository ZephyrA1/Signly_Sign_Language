import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../services/progress_service.dart';
import '../../widgets/common_widgets.dart';

class ProgressDashboardScreen extends StatefulWidget {
  const ProgressDashboardScreen({super.key});

  @override
  State<ProgressDashboardScreen> createState() => ProgressDashboardScreenState();
}

class ProgressDashboardScreenState extends State<ProgressDashboardScreen> {
  UserProgress? _progress;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Called by MainScreen whenever the Progress tab is tapped.
  Future<void> reload() => _load();

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);
    final p = await ProgressService.instance.load();
    if (mounted) setState(() { _progress = p; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2196F3)))
          : RefreshIndicator(
        onRefresh: _load,
        color: const Color(0xFF2196F3),
        backgroundColor: const Color(0xFF2A2A2A),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final p = _progress!;
    final intPct = p.interpretationPct;
    final prodPct = p.productionPct;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text('Your Progress',
              style: TextStyle(
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // ── Stat cards ──────────────────────────────────────────────────
          Row(children: [
            _statCard(Icons.menu_book, '${p.lessonsCompleted}', 'Lessons',
                const Color(0xFF2196F3)),
            const SizedBox(width: 12),
            _statCard(Icons.sign_language, '${p.signsLearned}', 'Signs Learned',
                const Color(0xFF4CAF50)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _statCard(
              Icons.remove_red_eye,
              intPct != null ? '$intPct%' : '—',
              'Interpretation',
              const Color(0xFF9C27B0),
            ),
            const SizedBox(width: 12),
            _statCard(
              Icons.camera_alt,
              prodPct != null ? '$prodPct%' : '—',
              'Production',
              const Color(0xFFFF9800),
            ),
          ]),
          const SizedBox(height: 12),

          // ── Streak card ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              const Icon(Icons.local_fire_department,
                  color: Colors.orange, size: 32),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  p.dayStreak == 0
                      ? 'No streak yet'
                      : '${p.dayStreak} Day Streak 🔥',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  p.dayStreak == 0
                      ? 'Complete a lesson to start your streak!'
                      : p.dayStreak == 1
                      ? 'Great start — keep it going tomorrow!'
                      : 'Keep it up — don\'t break the chain!',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 24),

          // ── Weekly goal ─────────────────────────────────────────────────
          const SignlySectionTitle(title: 'Weekly Goal'),
          const SizedBox(height: 12),
          _buildWeeklyGoal(p),
          const SizedBox(height: 24),

          // ── Unit strengths ──────────────────────────────────────────────
          const SignlySectionTitle(title: 'Unit Progress'),
          const SizedBox(height: 12),
          ...LessonUnit.sampleUnits.map((unit) {
            final total = unit.lessons.length;
            final done = unit.lessons
                .where((l) => p.completedLessonIds.contains(l.id))
                .length;
            final frac = total == 0 ? 0.0 : done / total;
            final status = done == 0
                ? 'Not started'
                : done == total
                ? 'Complete ✓'
                : '$done / $total lessons';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildUnitRow(unit.title, frac, status),
            );
          }),
          const SizedBox(height: 24),

          // ── Areas needing review ────────────────────────────────────────
          const SignlySectionTitle(title: 'Areas Needing Review'),
          const SizedBox(height: 12),
          _buildReviewSection(p),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity, height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/weak-areas'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2196F3),
                side: const BorderSide(color: Color(0xFF2196F3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Review Weak Areas'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFF9E9E9E), fontSize: 12),
                  overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildWeeklyGoal(UserProgress p) {
    const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final active = p.activeDaysThisWeek[i];
            return Column(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF2196F3)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active
                        ? const Color(0xFF2196F3)
                        : const Color(0xFF3A3A3A),
                  ),
                ),
                child: Center(
                  child: active
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(days[i],
                  style: TextStyle(
                    color: active
                        ? const Color(0xFF2196F3)
                        : const Color(0xFF9E9E9E),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  )),
            ]);
          }),
        ),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.calendar_today,
              color: Color(0xFF9E9E9E), size: 16),
          const SizedBox(width: 8),
          Text(
            '${p.daysActiveThisWeek} / 7 days this week',
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
          ),
          const Spacer(),
          if (p.daysActiveThisWeek >= 7)
            const Text('Perfect week! 🏆',
                style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }

  Widget _buildUnitRow(String title, double progress, String status) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
          Text(status,
              style: TextStyle(
                color: progress == 1.0
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF9E9E9E),
                fontSize: 12,
              )),
        ]),
        const SizedBox(height: 8),
        SignlyProgressBar(value: progress, height: 5),
      ]),
    );
  }

  Widget _buildReviewSection(UserProgress p) {
    if (p.lessonsCompleted == 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: const Column(children: [
          Icon(Icons.school_outlined, color: Color(0xFF9E9E9E), size: 40),
          SizedBox(height: 8),
          Text('Complete some lessons first',
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
          SizedBox(height: 4),
          Text("We'll track areas that need more practice",
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12)),
        ]),
      );
    }

    // Show signs learned so far
    final signs = p.learnedSigns.take(8).toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Signs to keep practising',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: signs
              .map((s) => Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color(0xFFFF9800).withOpacity(0.3)),
            ),
            child: Text(s,
                style: const TextStyle(
                    color: Color(0xFFFFB74D), fontSize: 13)),
          ))
              .toList(),
        ),
        if (p.learnedSigns.length > 8) ...[
          const SizedBox(height: 8),
          Text('+ ${p.learnedSigns.length - 8} more',
              style: const TextStyle(
                  color: Color(0xFF9E9E9E), fontSize: 12)),
        ],
      ]),
    );
  }
}