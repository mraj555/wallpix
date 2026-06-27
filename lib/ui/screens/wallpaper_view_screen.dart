import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
// Removed flutter_lucide
import 'package:provider/provider.dart';
import '../../models/wallpaper_model.dart';
import '../../providers/favorites_provider.dart';
import '../../services/wallpaper_service.dart';

class WallpaperViewScreen extends StatefulWidget {
  final WallpaperModel wallpaper;

  const WallpaperViewScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperViewScreen> createState() => _WallpaperViewScreenState();
}

class _WallpaperViewScreenState extends State<WallpaperViewScreen> {
  final WallpaperService _wallpaperService = WallpaperService();
  bool _isProcessing = false;

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _downloadImage() async {
    setState(() => _isProcessing = true);
    final success = await _wallpaperService.saveToGallery(
      widget.wallpaper.largeImageUrl,
      widget.wallpaper.id.toString(),
    );
    setState(() => _isProcessing = false);
    _showSnackBar(success ? 'Saved to Gallery!' : 'Failed to save');
  }

  Future<void> _shareImage() async {
    setState(() => _isProcessing = true);
    await _wallpaperService.shareWallpaper(
      widget.wallpaper.largeImageUrl,
      widget.wallpaper.id.toString(),
    );
    setState(() => _isProcessing = false);
  }

  Future<void> _setWallpaperDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home Screen'),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperTarget.home);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Lock Screen'),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperTarget.lock);
                },
              ),
              ListTile(
                leading: const Icon(Icons.smartphone),
                title: const Text('Both Screens'),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperTarget.both);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setWallpaper(WallpaperTarget target) async {
    setState(() => _isProcessing = true);
    final success = await _wallpaperService.setWallpaper(
      widget.wallpaper.largeImageUrl,
      widget.wallpaper.id.toString(),
      target,
    );
    setState(() => _isProcessing = false);
    _showSnackBar(
      success ? 'Wallpaper set successfully!' : 'Failed to set wallpaper',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(widget.wallpaper.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                ),
                onPressed: () => provider.toggleFavorite(widget.wallpaper),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _isProcessing ? null : _shareImage,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'wallpaper_${widget.wallpaper.id}',
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 3.0,
              child: CachedNetworkImage(
                imageUrl: widget.wallpaper.largeImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .4),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: .1), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.download,
                  label: 'Download',
                  onTap: _isProcessing ? null : _downloadImage,
                ),
                _buildActionButton(
                  icon: Icons.image,
                  label: 'Set Wallpaper',
                  onTap: _isProcessing ? null : _setWallpaperDialog,
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary
              ? Theme.of(context).primaryColor
              : Colors.white.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(30),
          border: isPrimary ? null : Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
