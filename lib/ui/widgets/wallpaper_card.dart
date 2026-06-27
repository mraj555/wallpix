import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/wallpaper_model.dart';
import '../screens/wallpaper_view_screen.dart';

class WallpaperCard extends StatelessWidget {
  final WallpaperModel wallpaper;

  const WallpaperCard({super.key, required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WallpaperViewScreen(wallpaper: wallpaper),
          ),
        );
      },
      child: Hero(
        tag: 'wallpaper_${wallpaper.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).cardTheme.color,
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: wallpaper.previewUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const AspectRatio(
              aspectRatio: 0.7,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) =>
                const AspectRatio(aspectRatio: 0.7, child: Icon(Icons.error)),
          ),
        ),
      ),
    );
  }
}
