import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/wallpaper_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.pixabayBaseUrl));

  Future<List<WallpaperModel>> fetchWallpapers({
    int page = 1,
    String? category,
    String? query,
    bool editorsChoice = false,
  }) async {
    try {
      final response = await _dio.get('', queryParameters: {
        'key': AppConstants.pixabayApiKey,
        'page': page,
        'per_page': 30,
        'image_type': 'photo',
        'orientation': 'vertical',
        'safesearch': true,
        'category': ?category,
        if (query != null && query.isNotEmpty) 'q': query,
        if (editorsChoice) 'editors_choice': true,
      });

      if (response.statusCode == 200) {
        final List hits = response.data['hits'];
        return hits.map((e) => WallpaperModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching wallpapers: $e");
      return [];
    }
  }
}
