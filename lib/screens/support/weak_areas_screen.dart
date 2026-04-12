import 'package:flutter/material.dart';
import '../../services/progress_service.dart';

class WeakAreasScreen extends StatefulWidget {
  const WeakAreasScreen({super.key});

  @override
  State<WeakAreasScreen> createState() => _WeakAreasScreenState();
}

class _WeakAreasScreenState extends State<WeakAreasScreen> {
  List<WeakAreaEntry>? _entries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await ProgressService.instance.loadWeakAreas();
    if (mounted) setState(() => _entries = entries);
  }

  Future<void> _dismiss(WeakAreaEntry entry) async {
    await ProgressService.instance.dismissWeakArea(entry.key);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Weak Areas', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _entries == null
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2196F3)))
            : _entries!.isEmpty
            ? _buildEmpty()
            : _buildList(),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: Color(0xFF4CAF50), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('No weak areas yet!',
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'When you get a recognition, context, or error analysis question wrong, it will show up here so you can practise it again.',
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: _load,
      color: const Color(0xFF2196F3),
      backgroundColor: const Color(0xFF2A2A2A),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            '${_entries!.length} area${_entries!.length == 1 ? '' : 's'} to review',
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
          ),
          const SizedBox(height: 16),
          ..._entries!.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildEntry(e),
          )),
        ],
      ),
    );
  }

  Widget _buildEntry(WeakAreaEntry entry) {
    final typeColor = _typeColor(entry.type);
    final typeIcon  = _typeIcon(entry.type);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.signName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(entry.lessonTitle,
                          style: const TextStyle(
                              color: Color(0xFF9E9E9E), fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                // Dismiss button
                GestureDetector(
                  onTap: () => _confirmDismiss(entry),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close,
                        color: Color(0xFF9E9E9E), size: 16),
                  ),
                ),
              ],
            ),
          ),

          // ── Type badge ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Missed: ${entry.typeLabel}',
                style: TextStyle(
                    color: typeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Actions ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: 'Retry Sign',
                    icon: Icons.replay,
                    color: const Color(0xFF2196F3),
                    filled: true,
                    onTap: () => _retrySign(entry),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _actionButton(
                    label: 'Full Lesson',
                    icon: Icons.menu_book_outlined,
                    color: const Color(0xFF2196F3),
                    filled: false,
                    onTap: () => _openFullLesson(entry),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: filled ? Colors.white : color, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: filled ? Colors.white : color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── Navigation ───────────────────────────────────────────────────────────

  /// Jump directly to the Watch screen for the specific sign, in review mode.
  void _retrySign(WeakAreaEntry entry) {
    Navigator.pushNamed(context, '/lesson-watch', arguments: {
      'unitTitle':   entry.unitTitle,
      'lessonTitle': entry.lessonTitle,
      'lessonId':    entry.lessonId,
      'signIndex':   entry.signIndex,
      'isReview':    true,
    });
  }

  /// Open the lesson intro screen so the user can redo the full lesson.
  void _openFullLesson(WeakAreaEntry entry) {
    Navigator.pushNamed(context, '/lesson-intro', arguments: {
      'unitTitle':   entry.unitTitle,
      'lessonTitle': entry.lessonTitle,
      'lessonId':    entry.lessonId,
    });
  }

  // ── Dismiss confirmation ──────────────────────────────────────────────────

  Future<void> _confirmDismiss(WeakAreaEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove from Weak Areas?',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'This will remove "${entry.signName}" from your focus list. Only do this if you feel confident with it.',
          style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF9E9E9E))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove',
                style: TextStyle(
                    color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed == true) await _dismiss(entry);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Color _typeColor(MistakeType type) {
    switch (type) {
      case MistakeType.recognition:   return const Color(0xFF9C27B0);
      case MistakeType.context:       return const Color(0xFFFF9800);
      case MistakeType.errorAnalysis: return const Color(0xFFE53935);
    }
  }

  IconData _typeIcon(MistakeType type) {
    switch (type) {
      case MistakeType.recognition:   return Icons.remove_red_eye_outlined;
      case MistakeType.context:       return Icons.chat_bubble_outline;
      case MistakeType.errorAnalysis: return Icons.compare_arrows;
    }
  }
}