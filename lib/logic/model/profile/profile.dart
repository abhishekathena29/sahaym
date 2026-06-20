import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  @JsonKey(name: 'email_verified_at')
  final dynamic emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const Profile({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return _$ProfileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      emailVerifiedAt,
      createdAt,
      updatedAt,
    ];
  }
}
