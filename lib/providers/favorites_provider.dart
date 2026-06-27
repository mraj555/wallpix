import 'package:flutter/material.dart';
import '../models/wallpaper_model.dart';
import '../services/local_storage_service.dart';

class FavoritesProvider with ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();
  
  List<WallpaperModel> _favorites = [];

  List<WallpaperModel> get favorites => _favorites;

  FavoritesProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites.any((w) => w.id == id);
  }

  Future<void> toggleFavorite(WallpaperModel wallpaper) async {
    if (isFavorite(wallpaper.id)) {
      _favorites.removeWhere((w) => w.id == wallpaper.id);
    } else {
      _favorites.add(wallpaper);
    }
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }
}
