import 'package:flutter/material.dart';

/// RLO Type 4 (Reused): Error Detective / Error Analysis
/// Independent practice mode reusing the Error Analysis RLO pattern.
/// Presents two sign cards for comparison and error identification.
class ErrorDetectiveScreen extends StatefulWidget {
  const ErrorDetectiveScreen({super.key});

  @override
  State<ErrorDetectiveScreen> createState() => _ErrorDetectiveScreenState();
}

class _ErrorDetectiveScreenState extends State<ErrorDetectiveScreen> {
  int? _selectedSign;
  bool _submitted = false;
  final int _incorrectSign = 1; // Sign B is incorrect

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Error Detective', style: TextStyle(color: Colors.white)),
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
                    const Text(
                      'Which sign is performed incorrectly?',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Watch both signs carefully and identify the mistake',
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // Two signs
                    Row(
                      children: [
                        Expanded(child: _buildSignCard(0, 'Sign A')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSignCard(1, 'Sign B')),
                      ],
                    ),
                    if (_submitted) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: (_selectedSign == _incorrectSign ? const Color(0xFF4CAF50) : const Color(0xFFE53935)).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (_selectedSign == _incorrectSign ? const Color(0xFF4CAF50) : const Color(0xFFE53935)).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedSign == _incorrectSign ? 'Correct!' : 'Not quite',
                              style: TextStyle(
                                color: _selectedSign == _incorrectSign ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                                fontSize: 16, fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Sign B has the error. The handshape is incorrect - the fingers should be together, not spread apart. This changes the meaning of the sign entirely.',
                              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                            ),
                          ],
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
                  onPressed: _selectedSign == null
                      ? null
                      : () {
                          if (!_submitted) {
                            setState(() => _submitted = true);
                          } else {
                            setState(() {
                              _selectedSign = null;
                              _submitted = false;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: Text(_submitted ? 'Next' : 'Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignCard(int index, String label) {
    final selected = _selectedSign == index;
    final isIncorrect = index == _incorrectSign;

    Color borderColor = const Color(0xFF3A3A3A);
    if (_submitted && selected) {
      borderColor = isIncorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    } else if (selected) {
      borderColor = const Color(0xFF2196F3);
    }

    return GestureDetector(
      onTap: _submitted ? null : () => setState(() => _selectedSign = index),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline, color: Color(0xFF9E9E9E), size: 44),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            if (_submitted && selected)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  isIncorrect ? Icons.check_circle : Icons.cancel,
                  color: isIncorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
