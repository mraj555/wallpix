import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallpaper_model.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorites';

  Future<List<WallpaperModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);

    if (favoritesJson != null) {
      final List decoded = json.decode(favoritesJson);
      return decoded.map((e) => WallpaperModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveFavorites(List<WallpaperModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      favorites.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_favoritesKey, encoded);
  }
}
