# WallPix

A modern, high-performance, and visually stunning wallpaper application built with Flutter.

**Note: Complete App build using Antigravity AI IDE and don't write any line of code manually.**

## 🛠️ Tech Stack

This project is built using the following core technologies and packages:

*   **Framework:** [Flutter](https://flutter.dev/) (Dart)
*   **State Management:** [provider](https://pub.dev/packages/provider) for managing app state (favorites, wallpaper fetching).
*   **Networking:** [dio](https://pub.dev/packages/dio) for making robust HTTP requests to fetch wallpaper data from APIs.
*   **Image Caching:** [cached_network_image](https://pub.dev/packages/cached_network_image) for downloading, displaying, and caching high-resolution images efficiently.
*   **UI / Layout:** [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) for creating beautiful masonry grid layouts.
*   **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences) for persisting user's favorite wallpapers locally.
*   **Wallpaper Management:** [async_wallpaper](https://pub.dev/packages/async_wallpaper) for setting wallpapers directly to the home screen, lock screen, or both.
*   **Media Gallery:** [gal](https://pub.dev/packages/gal) for saving images directly to the device's photo gallery.
*   **System Integration:** 
    *   [share_plus](https://pub.dev/packages/share_plus) for sharing wallpaper images with other apps.
    *   [permission_handler](https://pub.dev/packages/permission_handler) for managing storage access permissions gracefully.
*   **Typography & Icons:** [google_fonts](https://pub.dev/packages/google_fonts) (using the *Outfit* font family) and [flutter_lucide](https://pub.dev/packages/flutter_lucide) for modern typography and iconography.

## 🏗️ Architecture

The app follows a clean, layered architecture designed for maintainability, scalability, and clear separation of concerns.

1.  **Data Layer (`lib/services/`)**: Responsible for all external communications and side effects.
    *   `api_service.dart`: Handles network requests to the wallpaper API and parses JSON responses into Dart model objects.
    *   `local_storage_service.dart`: Manages local persistence using `SharedPreferences`, specifically for saving favorite wallpaper IDs.
    *   `wallpaper_service.dart`: Abstracts native device interactions, such as downloading images to the file system, saving them to the gallery via `gal`, and setting them as device wallpapers via `async_wallpaper`.
2.  **Domain/Model Layer (`lib/models/`)**: Contains strongly-typed data structures representing the business entities.
    *   `wallpaper_model.dart`: Represents a single wallpaper entity, containing URLs for different image resolutions, photographer details, and IDs.
3.  **State Management Layer (`lib/providers/`)**: Acts as the bridge between the UI and the Data layer, using the `ChangeNotifier` pattern.
    *   `wallpaper_provider.dart`: Fetches and caches wallpaper data from the `ApiService`, handles pagination logic, and exposes the state (loading, error, data) to the UI.
    *   `favorites_provider.dart`: Manages the user's list of favorite wallpapers, persisting and retrieving them via the `LocalStorageService`.
4.  **Presentation Layer (`lib/ui/`)**: Contains all the UI components, heavily utilizing modern design trends like Glassmorphism and immersive layouts.
    *   `screens/`: Full-page views (e.g., Home, Categories, Favorites, Wallpaper View).
    *   `widgets/`: Reusable UI components (e.g., `WallpaperCard`).

## 📂 Project Structure in Detail

```text
lib/
├── core/
│   ├── constants.dart               # Global app constants (API keys, endpoints, standard dimensions)
│   └── theme.dart                   # Global app theme, styling configurations, colors, and typography (Outfit)
├── models/
│   └── wallpaper_model.dart         # Data model representing a wallpaper object
├── providers/
│   ├── favorites_provider.dart      # Manages state for favorited wallpapers
│   └── wallpaper_provider.dart      # Manages state for fetching, paginating, and displaying wallpapers
├── services/
│   ├── api_service.dart             # Network calls (e.g., fetching from Pexels/Unsplash API)
│   ├── local_storage_service.dart   # Shared preferences wrapper for local data persistence
│   └── wallpaper_service.dart       # Methods to download, save to gallery, and set wallpaper natively
├── ui/
│   ├── screens/
│   │   ├── categories_screen.dart       # Shows lists of different curated wallpaper categories
│   │   ├── category_wallpapers_screen.dart # Shows wallpapers fetched for a specific selected category
│   │   ├── favorites_screen.dart        # Displays user's saved favorite wallpapers from local storage
│   │   ├── home_screen.dart             # Main screen displaying curated/trending wallpapers with a glassmorphic app bar
│   │   ├── main_navigation.dart         # Scaffold wrapping a floating, glassmorphic bottom navigation bar
│   │   ├── splash_screen.dart           # Initial app loading screen
│   │   └── wallpaper_view_screen.dart   # Detailed full-screen view of a single wallpaper with a glassmorphic action bar (Set, Save, Share)
│   └── widgets/
│       └── wallpaper_card.dart      # Reusable, interactive card widget to display a wallpaper in the staggered grid with scale animations
└── main.dart                        # Application entry point; initializes providers, sets system UI overlays, and runs the app
```

## 🔗 How the Files are Connected (Control Flow)

To help new developers understand the data flow and UI connectivity, here is the lifecycle of typical user interactions:

1.  **Bootstrapping:** `main.dart` is the entry point. It wraps the entire application in a `MultiProvider` that initializes the `ChangeNotifierProvider`s (`WallpaperProvider` and `FavoritesProvider`). It then launches the app with `SplashScreen`.
2.  **Navigation:** After a brief delay, `SplashScreen` transitions to `MainNavigation`. `MainNavigation` holds a custom floating `BottomNavigationBar` to switch between `HomeScreen` (index 0), `CategoriesScreen` (index 1), and `FavoritesScreen` (index 2) using an `IndexedStack`.
3.  **Data Fetching:** When `HomeScreen` or `CategoryWallpapersScreen` loads in the `IndexedStack`, they use `Provider.of` or `Consumer` to call fetch methods on `WallpaperProvider`. The provider delegates the actual HTTP call to `ApiService`. Once the JSON data is fetched, it is parsed into `WallpaperModel` instances, and the provider calls `notifyListeners()` to rebuild the UI with the new data.
4.  **Displaying Data:** The screens utilize a `MasonryGridView` (from `flutter_staggered_grid_view`) filled with `WallpaperCard` widgets. Each card receives a specific `WallpaperModel`.
5.  **User Interactions (Viewing):** 
    *   Tapping a `WallpaperCard` triggers a scale animation and navigates to `WallpaperViewScreen`, passing the specific `WallpaperModel` as an argument. A `Hero` widget smoothly animates the image transition.
    *   Tapping the "favorite" heart icon on a card or view screen triggers `FavoritesProvider`, which uses `LocalStorageService` to save/remove the wallpaper ID locally and immediately updates the UI.
6.  **Wallpaper Actions:** Inside the `WallpaperViewScreen`, the "Download", "Share", and "Set Wallpaper" buttons call specific methods inside `WallpaperService`. 
    *   This service internally uses `path_provider` and `dio` to download the image file.
    *   It then passes the file path to packages like `gal` (to save to gallery), `share_plus` (to open the system share sheet), and `async_wallpaper` (to set the device wallpaper via native Android/iOS channels).
