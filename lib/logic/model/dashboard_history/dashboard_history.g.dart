// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardHistory _$DashboardHistoryFromJson(Map<String, dynamic> json) =>
    DashboardHistory(
      month: json['month'] as String?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DashboardHistoryToJson(DashboardHistory instance) =>
    <String, dynamic>{
      'month': instance.month,
      'count': instance.count,
    };
