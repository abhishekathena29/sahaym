import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final int id;
  final String name;
  final int seqNumber;
  final String photo;
  final String createdAt;
  final String modifiedAt;

  const Photo({
    required this.id,
    required this.name,
    required this.seqNumber,
    required this.photo,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      name: json['name'] as String,
      seqNumber: json['seq_number'] as int,
      photo: json['photo'] as String,
      createdAt: json['created_at'] as String,
      modifiedAt: json['modified_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'seq_number': seqNumber,
      'photo': photo,
      'created_at': createdAt,
      'modified_at': modifiedAt,
    };
  }

  String get photoUrl {
    // Extract the filename from the path and build the full URL
    final filename = photo.split('/').last;
    return 'https://api.sahaym.in/.photos/$filename';
  }

  @override
  List<Object?> get props =>
      [id, name, seqNumber, photo, createdAt, modifiedAt];
}
