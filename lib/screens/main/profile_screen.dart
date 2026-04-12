import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 26),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2196F3), width: 2),
                    ),
                    child: const Icon(Icons.person, color: Color(0xFF9E9E9E), size: 44),
                  ),
                  const SizedBox(height: 12),
                  Text(AuthService.instance.currentUser?.username ?? 'Learner', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('ASL', style: TextStyle(color: Color(0xFF2196F3), fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Beginner', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileItem(Icons.timer_outlined, 'Daily Practice Target', '10 minutes'),
            const SizedBox(height: 10),
            _buildProfileItem(Icons.trending_up, 'Current Streak', '0 days'),
            const SizedBox(height: 10),
            _buildProfileItem(Icons.school_outlined, 'Lessons Completed', '0'),
            const SizedBox(height: 10),
            _buildProfileItem(Icons.sign_language, 'Signs Learned', '0'),
            const SizedBox(height: 24),
            const Text('Quick Actions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildActionItem(context, Icons.edit_outlined, 'Edit Learning Preferences', null),
            const SizedBox(height: 8),
            _buildActionItem(context, Icons.emoji_events_outlined, 'Achievements', null),
            const SizedBox(height: 8),
            _buildActionItem(context, Icons.public, 'Deaf Culture & Context', '/deaf-culture'),
            const SizedBox(height: 8),
            _buildActionItem(context, Icons.explore_outlined, 'Free Practice / Explore', '/free-practice'),
            const SizedBox(height: 8),
            _buildActionItem(context, Icons.accessibility_new, 'Accessibility Settings', '/settings'),
            const SizedBox(height: 8),
            _buildActionItem(context, Icons.notifications_outlined, 'Notifications', '/settings'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2196F3),
                  side: const BorderSide(color: Color(0xFF2196F3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Settings'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () async {
                  final confirmed = await SignlyConfirmDialog.show(
                    context,
                    title: 'Log Out?',
                    message: 'Are you sure you want to log out? Your progress is saved and will be here when you return.',
                    confirmLabel: 'Log Out',
                    cancelLabel: 'Stay',
                    confirmColor: const Color(0xFFE53935),
                    icon: Icons.logout,
                  );
                  if (confirmed && context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE53935),
                  side: const BorderSide(color: Color(0xFFE53935)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Log Out'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildProfileItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2196F3), size: 22),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  static Widget _buildActionItem(BuildContext context, IconData icon, String label, String? route) {
    return GestureDetector(
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF9E9E9E), size: 22),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E), size: 22),
          ],
        ),
      ),
    );
  }
}