import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class LearningPreferencesScreen extends StatefulWidget {
  const LearningPreferencesScreen({super.key});

  @override
  State<LearningPreferencesScreen> createState() =>
      _LearningPreferencesScreenState();
}

class _LearningPreferencesScreenState extends State<LearningPreferencesScreen> {
  // Section 1: Language Variant
  int _selectedLanguage = 0;
  // Section 2: Experience Level
  int _selectedExperience = -1;
  // Section 3: Why learning
  int _selectedPurpose = -1;
  // Section 4: Daily goal
  int _selectedGoal = -1;
  // Section 5: Starting level
  int _selectedLevel = -1;

  final _languages = [
    {'code': 'ASL', 'name': 'American Sign Language', 'flag': 'assets/usa.png'},
    {'code': 'BSL', 'name': 'British Sign Language', 'flag': 'assets/british.png'},
    {'code': 'LSF', 'name': 'French Sign Language', 'flag': 'assets/france.png'},
    {'code': 'CSL', 'name': 'Chinese Sign Language', 'flag': 'assets/china.png'},
    {'code': 'RSL', 'name': 'Russian Sign Language', 'flag': 'assets/russia.png'},
  ];

  final _experiences = [
    'New to sign language',
    'Learned a little before',
    'Have some experience',
  ];

  final _purposes = [
    'For school',
    'For work',
    'For personal interest',
    'To communicate with family/friends',
    'Other',
  ];

  final _goals = [
    {'label': '5 min', 'subtitle': 'Casual'},
    {'label': '10 min', 'subtitle': 'Regular'},
    {'label': '15 min', 'subtitle': 'Serious'},
    {'label': '20 min', 'subtitle': 'Intensive'},
  ];

  final _levels = [
    {'label': 'Beginner', 'desc': 'Starting from scratch'},
    {'label': 'Elementary', 'desc': 'Know some basic signs'},
    {'label': 'Intermediate', 'desc': 'Can hold simple conversations'},
  ];

  Map<String, String> _credentials = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _credentials = Map<String, String>.from(args as Map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with progress
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SignlyProgressBar(value: 0.5, height: 6),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Step 1/2',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tell us about your\nlearning goals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'This helps us personalize your learning path',
                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Scrollable sections
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Language Variant
                    _buildSectionTitle('Which sign language do you want to learn?'),
                    const SizedBox(height: 12),
                    ..._languages.asMap().entries.map((e) {
                      final i = e.key;
                      final lang = e.value;
                      final selected = i == _selectedLanguage;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedLanguage = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF2196F3).withOpacity(0.15)
                                  : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF2196F3)
                                    : const Color(0xFF3A3A3A),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    lang['flag']!,
                                    width: 28,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang['code']!,
                                        style: TextStyle(
                                          color: selected ? const Color(0xFF2196F3) : Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        lang['name']!,
                                        style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                if (selected)
                                  const Icon(Icons.check_circle, color: Color(0xFF2196F3), size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // Section 2: Experience Level
                    _buildSectionTitle('What is your experience level?'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _experiences.asMap().entries.map((e) {
                        return SignlyChip(
                          label: e.value,
                          selected: _selectedExperience == e.key,
                          onTap: () => setState(() => _selectedExperience = e.key),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Section 3: Why learning
                    _buildSectionTitle('Why are you learning?'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _purposes.asMap().entries.map((e) {
                        return SignlyChip(
                          label: e.value,
                          selected: _selectedPurpose == e.key,
                          onTap: () => setState(() => _selectedPurpose = e.key),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Section 4: Daily practice goal
                    _buildSectionTitle('Daily practice goal'),
                    const SizedBox(height: 12),
                    Row(
                      children: _goals.asMap().entries.map((e) {
                        final i = e.key;
                        final goal = e.value;
                        final selected = _selectedGoal == i;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedGoal = i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF2196F3).withOpacity(0.2)
                                      : const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFF2196F3)
                                        : const Color(0xFF3A3A3A),
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      goal['label']!,
                                      style: TextStyle(
                                        color: selected ? const Color(0xFF2196F3) : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      goal['subtitle']!,
                                      style: const TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Section 5: Starting level
                    _buildSectionTitle('Starting level'),
                    const SizedBox(height: 12),
                    ..._levels.asMap().entries.map((e) {
                      final i = e.key;
                      final level = e.value;
                      final selected = _selectedLevel == i;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedLevel = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF2196F3).withOpacity(0.15)
                                  : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF2196F3)
                                    : const Color(0xFF3A3A3A),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        level['label']!,
                                        style: TextStyle(
                                          color: selected ? const Color(0xFF2196F3) : Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        level['desc']!,
                                        style: const TextStyle(
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (selected)
                                  const Icon(Icons.check_circle, color: Color(0xFF2196F3), size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final languages = ['ASL', 'BSL', 'LSF', 'CSL', 'RSL'];
                    final goals = ['5 min', '10 min', '15 min', '20 min'];
                    final levels = ['Beginner', 'Elementary', 'Intermediate'];

                    Navigator.pushNamed(context, '/start-goal', arguments: {
                      ..._credentials,
                      'signLanguage': languages[_selectedLanguage],
                      'experience':   _selectedExperience >= 0 ? _experiences[_selectedExperience] : '',
                      'purpose':      _selectedPurpose >= 0 ? _purposes[_selectedPurpose] : '',
                      'dailyGoal':    _selectedGoal >= 0 ? goals[_selectedGoal] : '10 min',
                      'level':        _selectedLevel >= 0 ? levels[_selectedLevel] : 'Beginner',
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}