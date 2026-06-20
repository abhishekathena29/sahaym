import 'package:equatable/equatable.dart';

class EventImage extends Equatable {
  final int id;
  final String name;
  final String path;
  final int eventId;

  const EventImage({
    required this.id,
    required this.name,
    required this.path,
    required this.eventId,
  });

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      id: json['id'] as int,
      name: json['name'] as String,
      path: json['path'] as String,
      eventId: json['event_id'] as int,
    );
  }

  String get imageUrl {
    // Extract the filename from the path and build the full URL
    final filename = path.split('/').last;
    return 'https://api.sahaym.in/.images/$filename';
  }

  @override
  List<Object?> get props => [id, name, path, eventId];
}

class Event extends Equatable {
  final int id;
  final String name;
  final String desc;
  final String location;
  final String videoLink;
  final List<EventImage> images;
  final DateTime eventDate;
  final String createdAt;
  final String modifiedAt;

  const Event({
    required this.id,
    required this.name,
    required this.desc,
    required this.location,
    required this.videoLink,
    required this.images,
    required this.eventDate,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] as String,
      desc: json['desc'] as String,
      location: json['location'] as String,
      videoLink: json['video_link'] as String,
      images: (json['images'] as List)
          .map((image) => EventImage.fromJson(image as Map<String, dynamic>))
          .toList(),
      eventDate: DateTime.parse(json['event_date'] as String),
      createdAt: json['created_at'] as String,
      modifiedAt: json['modified_at'] as String,
    );
  }

  String get dateDay => eventDate.day.toString().padLeft(2, '0');
  String get dateMonth {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[eventDate.month - 1];
  }

  String get dateYear => eventDate.year.toString();

  @override
  List<Object?> get props => [
        id,
        name,
        desc,
        location,
        videoLink,
        images,
        eventDate,
        createdAt,
        modifiedAt
      ];
}
