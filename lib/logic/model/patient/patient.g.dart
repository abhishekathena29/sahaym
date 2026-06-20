// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      id: (json['id'] as num?)?.toInt(),
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      spouseAge: (json['spouse_age'] as num?)?.toInt(),
      educationLevel: json['education_level'] as String?,
      hasBp: json['has_bp'] as bool?,
      hasDiabetes: json['has_diabetes'] as bool?,
      hasKneeProblems: json['has_knee_problems'] as bool?,
      hasSleepIssues: json['has_sleep_issues'] as bool?,
      hasMemoryIssues: json['has_memory_issues'] as bool?,
      hasWeakness: json['has_weakness'] as bool?,
      hadSurgery: json['had_surgery'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'phone_number': instance.phoneNumber,
      'age': instance.age,
      'gender': instance.gender,
      'spouse_age': instance.spouseAge,
      'education_level': instance.educationLevel,
      'has_bp': instance.hasBp,
      'has_diabetes': instance.hasDiabetes,
      'has_knee_problems': instance.hasKneeProblems,
      'has_sleep_issues': instance.hasSleepIssues,
      'has_memory_issues': instance.hasMemoryIssues,
      'has_weakness': instance.hasWeakness,
      'had_surgery': instance.hadSurgery,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
