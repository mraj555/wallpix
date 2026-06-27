import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class WallpaperService {
  final Dio _dio = Dio();

  Future<String?> downloadImageToTemp(String url, String fileName) async {
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$fileName';
      await _dio.download(url, path);
      return path;
    } catch (e) {
      debugPrint("Download error: $e");
      return null;
    }
  }

  Future<bool> saveToGallery(String url, String id) async {
    try {
      final path = await downloadImageToTemp(url, 'wallpix_$id.jpg');
      if (path != null) {
        // Request access and save image
        final hasAccess = await Gal.hasAccess(toAlbum: true);
        if (!hasAccess) {
          await Gal.requestAccess(toAlbum: true);
        }
        await Gal.putImage(path);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Save to gallery error: $e");
      return false;
    }
  }

  Future<bool> setWallpaper(String url, String id, WallpaperTarget target) async {
    try {
      final path = await downloadImageToTemp(url, 'wallpix_set_$id.jpg');
      if (path != null) {
        final result = await AsyncWallpaper.setWallpaper(
          WallpaperRequest(
            target: target,
            sourceType: WallpaperSourceType.file,
            source: path,
          ),
        );
        return result.isSuccess;
      }
      return false;
    } catch (e) {
      debugPrint("Set wallpaper error: $e");
      return false;
    }
  }

  Future<void> shareWallpaper(String url, String id) async {
    try {
      final path = await downloadImageToTemp(url, 'wallpix_share_$id.jpg');
      if (path != null) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(path)],
            text: 'Check out this awesome wallpaper from WallPix!',
          ),
        );
      }
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }
}
