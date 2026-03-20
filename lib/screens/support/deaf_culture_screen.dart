import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';

class DeafCultureScreen extends StatelessWidget {
  const DeafCultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Culture & Communication', style: TextStyle(color: Colors.white)),
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
              const Text(
                'Understanding Deaf culture helps you communicate with respect and awareness.',
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),
              ...CultureNote.sampleNotes.map((note) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildCultureCard(note),
                );
              }),
              const SizedBox(height: 12),
              const Text(
                'Related Lessons',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildRelatedLesson(Icons.face, 'Facial Expressions in ASL', 'Learn how expressions change meaning'),
              const SizedBox(height: 8),
              _buildRelatedLesson(Icons.people, 'Deaf Community Etiquette', 'Respectful communication practices'),
              const SizedBox(height: 8),
              _buildRelatedLesson(Icons.history_edu, 'History of Sign Language', 'How sign languages developed'),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _getIconForNote(String iconName) {
    switch (iconName) {
      case 'face': return Icons.face;
      case 'attention': return Icons.pan_tool;
      case 'respect': return Icons.visibility;
      case 'identity': return Icons.people;
      case 'name': return Icons.badge;
      default: return Icons.info;
    }
  }

  static Widget _buildCultureCard(CultureNote note) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_getIconForNote(note.icon), color: const Color(0xFF2196F3), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  note.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            note.description,
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  static Widget _buildRelatedLesson(IconData icon, String title, String subtitle) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E), size: 22),
        ],
      ),
    );
  }
}
