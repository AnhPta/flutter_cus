import 'package:equatable/equatable.dart';

class Statuses extends Equatable {
  final String createdAt;
  final String description;
  final String message;
  final String status;
  final String statusColor;
  final String statusTxt;

  Statuses({
    this.createdAt,
    this.description,
    this.message,
    this.status,
    this.statusColor,
    this.statusTxt,

  }) : super([
    createdAt,
    description,
    message,
    status,
    statusColor,
    statusTxt,
  ]);

  Statuses copyWith({
    String createdAt,
    String description,
    String message,
    String status,
    String statusColor,
    String statusTxt,
  })
  {
    return Statuses(
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      message: message ?? this.message,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      statusTxt: statusTxt ?? this.statusTxt,
    );
  }

  @override
  String toString() => '$createdAt|$description|$message|$status|$statusColor|$statusTxt|$message';
  static Statuses fromJson(dynamic json) {
    return Statuses(
      createdAt: json['created_at'],
      description: json['description'],
      message: json['message'],
      status: json['status'],
      statusColor: json['status_color'],
      statusTxt: json['status_txt'],
    );
  }

  factory Statuses.empty() {
    return Statuses(
      createdAt: '',
      description: '',
      message: '',
      status: '',
      statusColor: '',
      statusTxt: '',
    );
  }
}
