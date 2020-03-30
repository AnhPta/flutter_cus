import 'package:equatable/equatable.dart';

class ListStatus extends Equatable {
  final String id;
  final String value;

  ListStatus(
    {this.id, this.value})
    : super([id, value]);

  static ListStatus fromJson(dynamic json) {
    return ListStatus(
      id: json['id'] is String ? json['id'] : '',
      value: json['value'] is String ? json['value'] : '',
    );
  }

  ListStatus copyWith({
    String id,
    String value,
  })
  {
    return ListStatus(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'value': this.value,
    };
  }
  @override
  String toString() => '$id|$value';
}
