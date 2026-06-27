import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../providers/wallpaper_provider.dart';
import '../widgets/wallpaper_card.dart';

class CategoryWallpapersScreen extends StatefulWidget {
  final String category;

  const CategoryWallpapersScreen({super.key, required this.category});

  @override
  State<CategoryWallpapersScreen> createState() =>
      _CategoryWallpapersScreenState();
}

class _CategoryWallpapersScreenState extends State<CategoryWallpapersScreen> {
  final ScrollController _scrollController = ScrollController();
  late WallpaperProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = WallpaperProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.fetchWallpapers(refresh: true, category: widget.category);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _provider.fetchWallpapers(category: widget.category);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category[0].toUpperCase() + widget.category.substring(1),
          ),
        ),
        body: Consumer<WallpaperProvider>(
          builder: (context, provider, child) {
            if (provider.wallpapers.isEmpty && provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return MasonryGridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              padding: const EdgeInsets.all(12),
              itemCount:
                  provider.wallpapers.length + (provider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.wallpapers.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return WallpaperCard(wallpaper: provider.wallpapers[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
