import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../providers/wallpaper_provider.dart';
import '../widgets/wallpaper_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WallpaperProvider>().fetchWallpapers(
        refresh: true,
        editorsChoice: true,
      );
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<WallpaperProvider>().fetchWallpapers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trending',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<WallpaperProvider>(
        builder: (context, provider, child) {
          if (provider.wallpapers.isEmpty && provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchWallpapers(
                refresh: true,
                editorsChoice: true,
              );
            },
            child: MasonryGridView.count(
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
            ),
          );
        },
      ),
    );
  }
}
