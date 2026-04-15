import 'package:flutter/material.dart';


class MistakeReviewScreen extends StatelessWidget {
  const MistakeReviewScreen({super.key});

  static const _mistakes = [
    {'sign': 'Thank You', 'type': 'Placement - started too low', 'times': 2},
    {'sign': 'Please', 'type': 'Movement - circle too small', 'times': 1},
    {'sign': 'Sorry', 'type': 'Handshape - used flat hand instead of fist', 'times': 3},
    {'sign': 'Teacher', 'type': 'Forgot PERSON marker', 'times': 1},
    {'sign': 'Father', 'type': 'Placement - touched chin instead of forehead', 'times': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Review Your Mistakes', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Signs you commonly miss',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_mistakes.length} signs need review',
                    style: const TextStyle(color: Color(0xFFFF9800), fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _mistakes.length,
                itemBuilder: (context, index) {
                  final mistake = _mistakes[index];
                  return _buildMistakeCard(mistake);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Review All'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMistakeCard(Map<String, dynamic> mistake) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close, color: Color(0xFFE53935), size: 22),
          ),
          title: Text(
            mistake['sign'] as String,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'Missed ${mistake['times']}x - ${mistake['type']}',
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
          ),
          iconColor: const Color(0xFF9E9E9E),
          collapsedIconColor: const Color(0xFF9E9E9E),
          children: [
            const Divider(color: Color(0xFF3A3A3A)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Color(0xFF4CAF50), size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Correct version available', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFFFF9800), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mistake['type'] as String,
                    style: const TextStyle(color: Color(0xFFFF9800), fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2196F3),
                  side: const BorderSide(color: Color(0xFF2196F3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Practice Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
