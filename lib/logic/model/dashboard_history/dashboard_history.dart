import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_history.g.dart';

@JsonSerializable()
class DashboardHistory extends Equatable {
  final String? month;
  final int? count;

  const DashboardHistory({this.month, this.count});

  factory DashboardHistory.fromJson(Map<String, dynamic> json) {
    return _$DashboardHistoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DashboardHistoryToJson(this);

  @override
  List<Object?> get props => [month, count];
}
