import 'package:equatable/equatable.dart';

class Ward extends Equatable {
  final String name;
  final String code;

  Ward({
    this.name,
    this.code
  }) : super([
    name,
    code
  ]);

  static Ward fromJson(dynamic json) {
    return Ward(
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  String toString() => 'Ward { code: $code, name: $name }';
}
