import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';

class VocabularyHomeScreen extends StatefulWidget {
  const VocabularyHomeScreen({super.key});

  @override
  State<VocabularyHomeScreen> createState() => _VocabularyHomeScreenState();
}

class _VocabularyHomeScreenState extends State<VocabularyHomeScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  List<VocabularyItem> get _filteredItems {
    var items = VocabularyItem.sampleItems;
    if (_selectedCategory != null) {
      items = items.where((i) => i.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      items = items
          .where((i) =>
              i.sign.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              i.meaning.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: const [
                Text(
                  'Vocabulary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search signs...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9E9E9E)),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Category filter chips
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFilterChip('All', _selectedCategory == null, () {
                  setState(() => _selectedCategory = null);
                }),
                const SizedBox(width: 8),
                ...VocabularyItem.categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(cat, _selectedCategory == cat, () {
                      setState(() => _selectedCategory = cat);
                    }),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Saved vocabulary banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(Icons.bookmark, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Saved vocabulary',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '0',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Review due banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.access_time, color: Color(0xFFFF9800), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Review due today',
                      style: TextStyle(color: Color(0xFFFF9800), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '3',
                    style: TextStyle(color: Color(0xFFFF9800), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Vocabulary list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildVocabItem(context, item),
                );
              },
            ),
          ),
          // Quick practice button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/free-practice');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Quick Practice'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2196F3).withOpacity(0.2)
              : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF2196F3) : const Color(0xFF3A3A3A),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF2196F3) : Colors.white,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildVocabItem(BuildContext context, VocabularyItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/vocabulary-detail', arguments: item);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sign_language, color: Color(0xFF2196F3), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.sign,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.category,
                    style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E), size: 22),
          ],
        ),
      ),
    );
  }
}
