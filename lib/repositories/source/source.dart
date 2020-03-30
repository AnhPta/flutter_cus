import 'package:equatable/equatable.dart';

class Source extends Equatable {
  final String code;
  final String name;

  Source({
    this.name,
    this.code,
  }) : super([name, code]);

  static Source fromJson(dynamic json) {
    return Source(
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  String toString() => 'Source($code,$name)';
}
