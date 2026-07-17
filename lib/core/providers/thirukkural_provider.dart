import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/kural_model.dart';
import '../../data/repository/thirukkural_repository.dart';

class ThirukkuralProvider extends ChangeNotifier {
  final ThirukkuralRepository _repository = ThirukkuralRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  List<int> _favorites = [];
  List<int> get favorites => _favorites;

  int _kuralOfTheDayNo = 1;
  int get kuralOfTheDayNo => _kuralOfTheDayNo;
  Kural? _kuralOfTheDay;
  Kural? get kuralOfTheDay => _kuralOfTheDay;

  ThirukkuralRepository get repository => _repository;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Initialize local JSON repository
      await _repository.init();

      // 2. Load preferences (favorites, theme)
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      
      final savedFavs = prefs.getStringList('favorites') ?? [];
      _favorites = savedFavs.map((e) => int.tryParse(e) ?? 0).where((n) => n > 0).toList();

      // 3. Set Kural of the Day (seeded by the date so it changes daily)
      final now = DateTime.now();
      final seed = now.year * 10000 + now.month * 100 + now.day;
      final random = Random(seed);
      _kuralOfTheDayNo = random.nextInt(1330) + 1; // 1 to 1330
      _kuralOfTheDay = _repository.getKuralByNumber(_kuralOfTheDayNo);
    } catch (e) {
      debugPrint("Error initializing ThirukkuralProvider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Theme Management
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Favorites Management
  bool isFavorite(int number) {
    return _favorites.contains(number);
  }

  Future<void> toggleFavorite(int number) async {
    if (_favorites.contains(number)) {
      _favorites.remove(number);
    } else {
      _favorites.add(number);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final stringFavs = _favorites.map((e) => e.toString()).toList();
    await prefs.setStringList('favorites', stringFavs);
  }

  List<Kural> getFavoriteKurals() {
    return _repository.getFavoriteKurals(_favorites);
  }
}
