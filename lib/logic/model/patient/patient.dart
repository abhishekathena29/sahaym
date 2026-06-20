import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient extends Equatable {
  final int? id;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final int? age;
  final String? gender;
  @JsonKey(name: 'spouse_age')
  final int? spouseAge;
  @JsonKey(name: 'education_level')
  final String? educationLevel;
  @JsonKey(name: 'has_bp')
  final bool? hasBp;
  @JsonKey(name: 'has_diabetes')
  final bool? hasDiabetes;
  @JsonKey(name: 'has_knee_problems')
  final bool? hasKneeProblems;
  @JsonKey(name: 'has_sleep_issues')
  final bool? hasSleepIssues;
  @JsonKey(name: 'has_memory_issues')
  final bool? hasMemoryIssues;
  @JsonKey(name: 'has_weakness')
  final bool? hasWeakness;
  @JsonKey(name: 'had_surgery')
  final bool? hadSurgery;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const Patient({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.age,
    this.gender,
    this.spouseAge,
    this.educationLevel,
    this.hasBp,
    this.hasDiabetes,
    this.hasKneeProblems,
    this.hasSleepIssues,
    this.hasMemoryIssues,
    this.hasWeakness,
    this.hadSurgery,
    this.createdAt,
    this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return _$PatientFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PatientToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      fullName,
      phoneNumber,
      age,
      gender,
      spouseAge,
      educationLevel,
      hasBp,
      hasDiabetes,
      hasKneeProblems,
      hasSleepIssues,
      hasMemoryIssues,
      hasWeakness,
      hadSurgery,
      createdAt,
      updatedAt,
    ];
  }
}
