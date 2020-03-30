import 'package:equatable/equatable.dart';

class District extends Equatable {
  final String name;
  final String code;

  District({
    this.name,
    this.code
  }) : super([
    name,
    code
  ]);

  static District fromJson(dynamic json) {
    return District(
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  String toString() => 'District { code: $code, name: $name }';
}
