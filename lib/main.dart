import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/favorites_provider.dart';
import 'providers/wallpaper_provider.dart';
import 'ui/screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallpaperProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const WallPixApp(),
    ),
  );
}

class WallPixApp extends StatelessWidget {
  const WallPixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WallPix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Enforce dark theme
      home: const SplashScreen(),
    );
  }
}
