import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';

/// RLO Type 3 (Reused): Scenario-Based Context Practice
/// Independent practice mode reusing the Scenario RLO pattern.
/// Cycles through real-world scenarios for contextual sign selection.
class ScenarioPracticeScreen extends StatefulWidget {
  const ScenarioPracticeScreen({super.key});

  @override
  State<ScenarioPracticeScreen> createState() => _ScenarioPracticeScreenState();
}

class _ScenarioPracticeScreenState extends State<ScenarioPracticeScreen> {
  int _currentIndex = 0;
  int? _selectedOption;
  bool _submitted = false;

  ScenarioData get _current => ScenarioData.sampleScenarios[_currentIndex];

  void _nextScenario() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % ScenarioData.sampleScenarios.length;
      _selectedOption = null;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Scenario Practice', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Topic
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _current.topic,
                        style: const TextStyle(color: Color(0xFF2196F3), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Scenario card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Situation', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                          const SizedBox(height: 8),
                          Text(
                            _current.scenario,
                            style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'What would you sign?',
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    // Options
                    ..._current.options.asMap().entries.map((e) {
                      final i = e.key;
                      final option = e.value;
                      final selected = _selectedOption == i;
                      final isCorrect = i == _current.correctIndex;
                      Color borderColor = const Color(0xFF3A3A3A);
                      Color bgColor = const Color(0xFF2A2A2A);

                      if (_submitted && selected) {
                        borderColor = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
                        bgColor = (isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935)).withOpacity(0.15);
                      } else if (_submitted && isCorrect) {
                        borderColor = const Color(0xFF4CAF50);
                        bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
                      } else if (selected) {
                        borderColor = const Color(0xFF2196F3);
                        bgColor = const Color(0xFF2196F3).withOpacity(0.15);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: _submitted ? null : () => setState(() => _selectedOption = i),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: selected || (_submitted && isCorrect) ? 2 : 1),
                            ),
                            child: Text(option, style: const TextStyle(color: Colors.white, fontSize: 15)),
                          ),
                        ),
                      );
                    }),
                    if (_submitted) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
                        ),
                        child: Text(
                          _current.explanation,
                          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedOption == null
                      ? null
                      : () {
                          if (!_submitted) {
                            setState(() => _submitted = true);
                          } else {
                            _nextScenario();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: Text(_submitted ? 'Next Scenario' : 'Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
