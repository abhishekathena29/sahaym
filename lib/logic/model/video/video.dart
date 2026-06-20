import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final int id;
  final String name;
  final String? title;
  final int seqNumber;
  final String video;
  final String createdAt;
  final String modifiedAt;

  const Video({
    required this.id,
    required this.name,
    required this.title,
    required this.seqNumber,
    required this.video,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    String stringValue(dynamic value) {
      return value == null ? '' : value.toString();
    }

    String? nullableStringValue(dynamic value) {
      if (value == null) return null;
      final text = value.toString().trim();
      return text.isEmpty ? null : text;
    }

    return Video(
      id: int.parse(json['id'].toString()),
      name: stringValue(json['name']),
      title: nullableStringValue(json['title']),
      seqNumber: int.parse(json['seq_number'].toString()),
      video: stringValue(json['video'] ?? json['ideo']),
      createdAt: stringValue(json['created_at']),
      modifiedAt: stringValue(json['modified_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'seq_number': seqNumber,
      'video': video,
      'created_at': createdAt,
      'modified_at': modifiedAt,
    };
  }

  bool get isYouTubeUrl {
    final rawPath = video.trim().toLowerCase();

    return rawPath.contains('youtube.com') || rawPath.contains('youtu.be');
  }

  String? get youtubeVideoId {
    if (!isYouTubeUrl) return null;

    final uri = Uri.tryParse(videoUrl);
    if (uri == null) return null;

    final host = uri.host.toLowerCase();
    final segments = uri.pathSegments.where((segment) => segment.isNotEmpty).toList();

    if (host.contains('youtu.be')) {
      return segments.isNotEmpty ? segments.first : null;
    }

    if (host.contains('youtube.com')) {
      if (segments.isNotEmpty && segments.first == 'shorts' && segments.length >= 2) {
        return segments[1];
      }

      if (segments.isNotEmpty && segments.first == 'embed' && segments.length >= 2) {
        return segments[1];
      }

      final videoId = uri.queryParameters['v'];
      if (videoId != null && videoId.isNotEmpty) {
        return videoId;
      }

      if (segments.isNotEmpty) {
        return segments.last;
      }
    }

    return null;
  }

  String? get youtubeThumbnailUrl {
    final videoId = youtubeVideoId;
    if (videoId == null || videoId.isEmpty) return null;

    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  String get videoUrl {
    final rawPath = video.trim();

    if (rawPath.isEmpty) {
      return rawPath;
    }

    // Preserve absolute URLs from API as-is.
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return rawPath;
    }

    // YouTube links can arrive without a scheme, so normalize them instead
    // of sending them through the API host.
    if (isYouTubeUrl) {
      return 'https://$rawPath';
    }

    // Build complete URL for relative paths from API.
    if (rawPath.startsWith('/')) {
      return 'https://api.sahaym.in$rawPath';
    }

    return 'https://api.sahaym.in/$rawPath';
  }

  String get displayTitle {
    // If an explicit title is provided, use it; otherwise fall back to the name.
    // Keep this behavior simple and predictable: title (when non-null) wins,
    // otherwise show the raw name coming from the API.
    final cleanTitle = title?.trim();
    if (cleanTitle != null && cleanTitle.isNotEmpty) {
      return cleanTitle;
    }

    return name.trim().isEmpty ? 'Untitled video' : name;
  }

  @override
  List<Object?> get props =>
      [id, name, title, seqNumber, video, createdAt, modifiedAt];
}
