# WallPix

A modern, high-performance wallpaper application built with Flutter. 

**Note: Complete App build using Antigravity AI IDE and don't write any line of code manually.**

## Tech Stack

This project is built using the following core technologies and packages:

*   **Framework:** [Flutter](https://flutter.dev/) (Dart)
*   **State Management:** [provider](https://pub.dev/packages/provider)
*   **Networking:** [dio](https://pub.dev/packages/dio) for making HTTP requests to fetch wallpaper data.
*   **Image Caching:** [cached_network_image](https://pub.dev/packages/cached_network_image) for downloading, displaying, and caching high-quality images.
*   **UI / Layout:** [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) for beautiful masonry grid layouts.
*   **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences) for persisting favorite wallpapers locally.
*   **Wallpaper Management:** [async_wallpaper](https://pub.dev/packages/async_wallpaper) for setting wallpapers directly to the home or lock screen.
*   **Media Gallery:** [gal](https://pub.dev/packages/gal) for saving images to the device gallery.
*   **System Integration:** [share_plus](https://pub.dev/packages/share_plus) for sharing wallpapers, and [permission_handler](https://pub.dev/packages/permission_handler) for managing storage access permissions.
*   **Typography & Icons:** [google_fonts](https://pub.dev/packages/google_fonts) and [flutter_lucide](https://pub.dev/packages/flutter_lucide) for beautiful text and iconography.

## Architecture

The app follows a clean, layered architecture designed for maintainability and separation of concerns.

1.  **Data Layer (`lib/services/`)**: Responsible for external communications.
    *   `api_service.dart`: Handles network requests and parses JSON data into model objects.
    *   `local_storage_service.dart`: Manages local persistence using SharedPreferences.
    *   `wallpaper_service.dart`: Abstracts interactions with the device for setting wallpapers and downloading/saving images.
2.  **Domain/Model Layer (`lib/models/`)**: Contains strongly-typed data structures.
    *   `wallpaper_model.dart`: Represents a single wallpaper entity.
3.  **State Management Layer (`lib/providers/`)**: Acts as the bridge between the UI and the Data layer.
    *   `wallpaper_provider.dart`: Fetches and caches wallpaper data from the `ApiService`, handles pagination, and exposes the data to the UI.
    *   `favorites_provider.dart`: Manages the user's list of favorite wallpapers, persisting them via the `LocalStorageService`.
4.  **Presentation Layer (`lib/ui/`)**: Contains all the UI components.
    *   `screens/`: Full-page views (e.g., Home, Categories, Favorites, Wallpaper View).
    *   `widgets/`: Reusable UI components (e.g., `WallpaperCard`).

## Project Structure in Detail

```text
lib/
├── core/
│   ├── constants.dart               # Global app constants (API keys, base URLs, etc.)
│   └── theme.dart                   # Global app theme and styling configurations
├── models/
│   └── wallpaper_model.dart         # Data model representing a wallpaper
├── providers/
│   ├── favorites_provider.dart      # Manages state for favorited wallpapers
│   └── wallpaper_provider.dart      # Manages state for fetching and displaying wallpapers
├── services/
│   ├── api_service.dart             # Network calls (e.g., fetching from Pexels API)
│   ├── local_storage_service.dart   # Shared preferences wrapper for local data
│   └── wallpaper_service.dart       # Methods to download, save to gallery, and set wallpaper
├── ui/
│   ├── screens/
│   │   ├── categories_screen.dart       # Shows lists of different wallpaper categories
│   │   ├── category_wallpapers_screen.dart # Shows wallpapers for a specific category
│   │   ├── favorites_screen.dart        # Displays user's saved favorite wallpapers
│   │   ├── home_screen.dart             # Main screen with curated/trending wallpapers
│   │   ├── main_navigation.dart         # Bottom navigation bar integrating the main screens
│   │   ├── splash_screen.dart           # Initial app loading screen
│   │   └── wallpaper_view_screen.dart   # Detailed view of a single wallpaper with actions (Set, Save, Share)
│   └── widgets/
│       └── wallpaper_card.dart      # Reusable card widget to display a wallpaper in the grid
└── main.dart                        # Application entry point, initializes providers and starts the app
```

### How the files are connected

1.  **Bootstrapping:** `main.dart` initializes the `ChangeNotifierProvider`s (`WallpaperProvider` and `FavoritesProvider`) and launches the app with `SplashScreen`.
2.  **Navigation:** `SplashScreen` transitions to `MainNavigation`. `MainNavigation` holds a `BottomNavigationBar` to switch between `HomeScreen`, `CategoriesScreen`, and `FavoritesScreen`.
3.  **Data Fetching:** When `HomeScreen` or `CategoryWallpapersScreen` loads, they call methods on `WallpaperProvider`. The provider delegates to `ApiService` to fetch JSON data, parses it into `WallpaperModel` instances, and notifies the UI to rebuild with the new data.
4.  **Displaying Data:** The screens use a `StaggeredGridView` filled with `WallpaperCard` widgets. Each card receives a `WallpaperModel`.
5.  **User Interactions:** 
    *   Tapping a `WallpaperCard` navigates to `WallpaperViewScreen`, passing the specific `WallpaperModel`.
    *   Tapping the "favorite" icon triggers `FavoritesProvider` which uses `LocalStorageService` to save/remove the wallpaper ID locally.
6.  **Wallpaper Actions:** In `WallpaperViewScreen`, the "Download", "Share", and "Set Wallpaper" buttons call methods inside `WallpaperService`. This service internally uses packages like `gal`, `share_plus`, and `async_wallpaper` to execute native device operations.
