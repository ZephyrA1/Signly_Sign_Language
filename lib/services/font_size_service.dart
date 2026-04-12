import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FontSizeLevel { small, normal, large }

class FontSizeService extends ChangeNotifier {
  FontSizeService._();
  static final FontSizeService instance = FontSizeService._();

  static const _key = 'font_size_level';

  FontSizeLevel _level = FontSizeLevel.normal;
  FontSizeLevel get level => _level;

  /// 0 = small, 1 = normal, 2 = large — matches the slider index
  int get index => _level.index;

  /// The textScaleFactor to pass into MaterialApp
  double get scaleFactor {
    switch (_level) {
      case FontSizeLevel.small:  return 0.85;
      case FontSizeLevel.normal: return 1.0;
      case FontSizeLevel.large:  return 1.2;
    }
  }

  String get label {
    switch (_level) {
      case FontSizeLevel.small:  return 'Small';
      case FontSizeLevel.normal: return 'Normal';
      case FontSizeLevel.large:  return 'Large';
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_key);
    if (saved != null && saved >= 0 && saved < FontSizeLevel.values.length) {
      _level = FontSizeLevel.values[saved];
      notifyListeners();
    }
  }

  Future<void> setIndex(int index) async {
    if (index < 0 || index >= FontSizeLevel.values.length) return;
    _level = FontSizeLevel.values[index];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, index);
  }
}