import 'package:flutter/material.dart';
import '../models/wallpaper_model.dart';
import '../services/api_service.dart';

class WallpaperProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<WallpaperModel> _wallpapers = [];
  bool _isLoading = false;
  int _currentPage = 1;
  String? _currentCategory;
  String? _currentQuery;
  bool _isEditorsChoice = false;

  List<WallpaperModel> get wallpapers => _wallpapers;
  bool get isLoading => _isLoading;
  String? get currentCategory => _currentCategory;

  Future<void> fetchWallpapers({
    bool refresh = false,
    String? category,
    String? query,
    bool editorsChoice = false,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _wallpapers.clear();
      _currentCategory = category ?? _currentCategory;
      _currentQuery = query ?? _currentQuery;
      _isEditorsChoice = editorsChoice;
    }

    _isLoading = true;
    notifyListeners();

    final newWallpapers = await _apiService.fetchWallpapers(
      page: _currentPage,
      category: _currentCategory,
      query: _currentQuery,
      editorsChoice: _isEditorsChoice,
    );

    _wallpapers.addAll(newWallpapers);
    _currentPage++;
    _isLoading = false;
    notifyListeners();
  }
}
