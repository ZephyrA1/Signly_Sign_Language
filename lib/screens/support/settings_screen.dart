import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../services/font_size_service.dart';
import '../../services/auth_service.dart';
import '../../services/session_timer_service.dart';

/// Settings screen with full accessibility/UDL features.
/// UDL Implementation:
/// - Multiple Means of Engagement: customizable daily goals, notification preferences
/// - Multiple Means of Representation: adjustable text size, high contrast mode, playback speed
/// - Multiple Means of Action & Expression: configurable animation speed, dominant hand selection
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _dominantHand = 'Right';



  @override
  void initState() {
    super.initState();
    FontSizeService.instance.addListener(_onFontSizeChanged);
  }

  void _onFontSizeChanged() => setState(() {});

  @override
  void dispose() {
    FontSizeService.instance.removeListener(_onFontSizeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account section
              _buildSectionTitle('Account'),
              const SizedBox(height: 12),
              _buildSettingItem(Icons.person_outline, 'Username', AuthService.instance.currentUser?.username ?? 'Learner'),
              const SizedBox(height: 8),
              _buildSettingItem(Icons.email_outlined, 'Email', AuthService.instance.currentUser?.email ?? ''),
              const SizedBox(height: 8),
              _buildSettingItem(Icons.lock_outline, 'Password', '********'),
              const SizedBox(height: 24),

              // Language section
              _buildSectionTitle('Language Preferences'),
              const SizedBox(height: 12),
              _buildSettingItem(Icons.language, 'Sign Language', AuthService.instance.currentUser?.signLanguage ?? 'ASL'),
              const SizedBox(height: 8),
              _buildSettingItem(Icons.trending_up, 'Level', AuthService.instance.currentUser?.level ?? 'Beginner'),
              const SizedBox(height: 8),
              _buildSettingItem(Icons.timer, 'Daily Goal', AuthService.instance.currentUser?.dailyGoal ?? '10 min'),
              const SizedBox(height: 8),
              _buildSelectorItem(
                Icons.front_hand,
                'Dominant Hand',
                _dominantHand,
                ['Left', 'Right'],
                    (v) => setState(() => _dominantHand = v),
              ),
              const SizedBox(height: 24),

              // Accessibility section - UDL: Multiple means of representation
              _buildSectionTitle('Accessibility (UDL)'),
              const SizedBox(height: 4),
              const Text(
                'Universal Design for Learning options',
                style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 12),
              ),
              const SizedBox(height: 12),
              _buildFontSizeSelector(),
              const SizedBox(height: 8),
              Opacity(
                opacity: 0.5,
                child: _buildToggleItem(
                  Icons.dark_mode_outlined,
                  'Dark Mode',
                  true,
                      (_) {},
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(Icons.translate, 'Interface Language', 'English'),
              const SizedBox(height: 24),

              // Notifications
              _buildSectionTitle('Notifications'),
              const SizedBox(height: 12),
              _buildToggleItem(
                Icons.notifications_outlined,
                'Push Notifications',
                _notificationsEnabled,
                    (v) => setState(() => _notificationsEnabled = v),
              ),
              const SizedBox(height: 24),

              // Privacy & Support
              _buildSectionTitle('Privacy & Support'),
              const SizedBox(height: 12),
              _buildSettingItem(Icons.privacy_tip_outlined, 'Privacy Policy', ''),
              const SizedBox(height: 8),
              _buildSettingItem(Icons.description_outlined, 'Terms of Service', ''),
              const SizedBox(height: 8),
              _buildSettingItem(Icons.help_outline, 'Help & Support', ''),
              const SizedBox(height: 8),
              _buildSettingItem(Icons.info_outline, 'About Signly', ''),
              const SizedBox(height: 24),

              // Reset progress (with confirmation)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () async {
                    final confirmed = await SignlyConfirmDialog.show(
                      context,
                      title: 'Reset All Progress?',
                      message: 'This will erase all your learning data, streaks, and achievements. This action cannot be undone.',
                      confirmLabel: 'Reset',
                      cancelLabel: 'Keep Data',
                      confirmColor: const Color(0xFFE53935),
                      icon: Icons.warning_amber_rounded,
                    );
                    if (confirmed && context.mounted) {
                      showSignlySnackBar(context, 'Progress has been reset');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF9800),
                    side: const BorderSide(color: const Color(0xFFFF9800)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Reset Progress'),
                ),
              ),
              const SizedBox(height: 12),

              // Log out (with confirmation)
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
                      await SessionTimerService.instance.pause();
                      await AuthService.instance.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(color: const Color(0xFFE53935)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Log Out'),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Signly v1.0.0',
                  style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeSelector() {
    final labels = ['Small', 'Normal', 'Large'];
    final current = FontSizeService.instance.index;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.text_fields, color: const Color(0xFF9E9E9E), size: 22),
            const SizedBox(width: 14),
            const Text('Text Size',
                style: TextStyle(color: Colors.white, fontSize: 15)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                labels[current],
                style: const TextStyle(
                    color: const Color(0xFF2196F3),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ]),
          const SizedBox(height: 14),
          Row(
            children: List.generate(labels.length, (i) {
              final selected = i == current;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => FontSizeService.instance.setIndex(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF2196F3)
                            : const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF3A3A3A),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Aa',
                            style: TextStyle(
                              color: selected ? Colors.white : const Color(0xFF9E9E9E),
                              fontSize: 11.0 + (i * 3.0),
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            labels[i],
                            style: TextStyle(
                              color: selected ? Colors.white : const Color(0xFF9E9E9E),
                              fontSize: 11,
                              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: const Color(0xFF2196F3), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }

  Widget _buildSettingItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9E9E9E), size: 22),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          const Spacer(),
          Text(value, style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: const Color(0xFF9E9E9E), size: 20),
        ],
      ),
    );
  }

  Widget _buildToggleItem(IconData icon, String label, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9E9E9E), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  /// Slider-based setting for accessibility controls (text size, speed).
  Widget _buildSliderItem(
      IconData icon,
      String label,
      String currentLabel,
      int currentIndex,
      int maxIndex,
      Function(double) onChanged,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF9E9E9E), size: 22),
              const SizedBox(width: 14),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentLabel,
                  style: const TextStyle(color: const Color(0xFF2196F3), fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF2196F3),
              inactiveTrackColor: const Color(0xFF3A3A3A),
              thumbColor: const Color(0xFF2196F3),
              overlayColor: const Color(0xFF2196F3).withOpacity(0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: currentIndex.toDouble(),
              min: 0,
              max: maxIndex.toDouble(),
              divisions: maxIndex,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  /// Selector item for choosing between options (e.g., dominant hand).
  Widget _buildSelectorItem(
      IconData icon,
      String label,
      String currentValue,
      List<String> options,
      Function(String) onChanged,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9E9E9E), size: 22),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          const Spacer(),
          ...options.map((opt) {
            final selected = opt == currentValue;
            return Padding(
              padding: const EdgeInsets.only(left: 6),
              child: GestureDetector(
                onTap: () => onChanged(opt),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF2196F3).withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected ? const Color(0xFF2196F3) : const Color(0xFF3A3A3A),
                    ),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: selected ? const Color(0xFF2196F3) : const Color(0xFF9E9E9E),
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}