import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final String code;

  City({
    this.name,
    this.code
  }) : super([
    name,
    code
  ]);

  static City fromJson(dynamic json) {
    return City(
      name: json['name'],
      code: json['code'],
    );
  }

//  City copyWith({
//    String name,
//    String code,
//  }) {
//    return City(
//      name: name ?? this.name,
//      code: code ?? this.code,
//    );
//  }

//  Map<String, dynamic> toJson() {
//    return {
//      'name': this.name,
//      'code': this.code,
//    };
//  }

  @override
  String toString() => 'City { code: $code, name: $name }';
}
