import 'package:flutter/material.dart';
import '../../models/lesson_data.dart';
import '../../services/progress_service.dart';

class VocabularyHomeScreen extends StatefulWidget {
  const VocabularyHomeScreen({super.key});

  @override
  State<VocabularyHomeScreen> createState() => _VocabularyHomeScreenState();
}

class _VocabularyHomeScreenState extends State<VocabularyHomeScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  Set<String> _learnedSigns = {};
  bool _showLearnedOnly = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await ProgressService.instance.load();
    if (mounted) setState(() => _learnedSigns = progress.learnedSigns);
  }

  List<VocabularyItem> get _filteredItems {
    var items = VocabularyItem.allItems;

    if (_showLearnedOnly) {
      items = items.where((i) => _learnedSigns.contains(i.sign)).toList();
    }
    if (_selectedCategory != null) {
      items = items.where((i) => i.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      items = items
          .where((i) =>
      i.sign.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final allItems = VocabularyItem.allItems;
    final learnedCount = allItems.where((i) => _learnedSigns.contains(i.sign)).length;

    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              const Text('Vocabulary',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${allItems.length} signs',
                  style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
            ]),
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
          const SizedBox(height: 12),

          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3A3A3A)),
              ),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.sign_language, color: Color(0xFF2196F3), size: 18),
                  const SizedBox(width: 8),
                  Text('$learnedCount / ${allItems.length} signs learned',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _showLearnedOnly = !_showLearnedOnly),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _showLearnedOnly
                            ? const Color(0xFF2196F3).withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _showLearnedOnly
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF3A3A3A),
                        ),
                      ),
                      child: Text(
                        'Learned only',
                        style: TextStyle(
                          color: _showLearnedOnly
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF9E9E9E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: allItems.isEmpty ? 0 : learnedCount / allItems.length,
                    minHeight: 6,
                    backgroundColor: const Color(0xFF3A3A3A),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),

          // Category filter chips
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFilterChip('All', _selectedCategory == null,
                        () => setState(() => _selectedCategory = null)),
                const SizedBox(width: 8),
                ...VocabularyItem.allCategories.map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildFilterChip(cat, _selectedCategory == cat,
                          () => setState(() => _selectedCategory = cat)),
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Vocabulary list
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.search_off, color: Color(0xFF9E9E9E), size: 40),
                const SizedBox(height: 8),
                Text(
                  _showLearnedOnly
                      ? 'No learned signs yet.\nComplete lessons to see them here.'
                      : 'No signs match your search.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                ),
              ]),
            )
                : ListView.builder(
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
                onPressed: () => Navigator.pushNamed(context, '/free-practice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    // Shorten long unit titles for chips
    final display = label
        .replaceAll('Greetings and Introductions', 'Greetings')
        .replaceAll('Everyday Expressions', 'Everyday')
        .replaceAll('School and Classroom', 'School')
        .replaceAll('Family and Relationships', 'Family');

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
          display,
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
    final isLearned = _learnedSigns.contains(item.sign);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/vocabulary-detail', arguments: item),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isLearned
                ? const Color(0xFF4CAF50).withOpacity(0.4)
                : const Color(0xFF3A3A3A),
          ),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isLearned
                  ? const Color(0xFF4CAF50).withOpacity(0.15)
                  : const Color(0xFF2196F3).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isLearned ? Icons.check : Icons.sign_language,
              color: isLearned ? const Color(0xFF4CAF50) : const Color(0xFF2196F3),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.sign,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                item.category
                    .replaceAll('Greetings and Introductions', 'Greetings')
                    .replaceAll('Everyday Expressions', 'Everyday')
                    .replaceAll('School and Classroom', 'School')
                    .replaceAll('Family and Relationships', 'Family'),
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
              ),
            ]),
          ),
          if (isLearned)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('Learned',
                  style: TextStyle(
                      color: Color(0xFF4CAF50), fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E), size: 22),
        ]),
      ),
    );
  }
}