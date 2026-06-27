import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../widgets/wallpaper_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return const Center(
              child: Text(
                'No saved wallpapers yet!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            padding: const EdgeInsets.all(12),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return WallpaperCard(wallpaper: provider.favorites[index]);
            },
          );
        },
      ),
    );
  }
}
