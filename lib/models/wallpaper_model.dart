class WallpaperModel {
  final int id;
  final String pageUrl;
  final String tags;
  final String previewUrl;
  final String largeImageUrl;
  final int views;
  final int downloads;
  final int likes;
  final String user;
  final String userImageUrl;

  WallpaperModel({
    required this.id,
    required this.pageUrl,
    required this.tags,
    required this.previewUrl,
    required this.largeImageUrl,
    required this.views,
    required this.downloads,
    required this.likes,
    required this.user,
    required this.userImageUrl,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'] ?? 0,
      pageUrl: json['pageURL'] ?? '',
      tags: json['tags'] ?? '',
      previewUrl: json['previewURL'] ?? '',
      largeImageUrl: json['largeImageURL'] ?? '',
      views: json['views'] ?? 0,
      downloads: json['downloads'] ?? 0,
      likes: json['likes'] ?? 0,
      user: json['user'] ?? '',
      userImageUrl: json['userImageURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageURL': pageUrl,
      'tags': tags,
      'previewURL': previewUrl,
      'largeImageURL': largeImageUrl,
      'views': views,
      'downloads': downloads,
      'likes': likes,
      'user': user,
      'userImageURL': userImageUrl,
    };
  }
}
