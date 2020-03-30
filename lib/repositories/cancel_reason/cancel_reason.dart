import 'package:equatable/equatable.dart';

class Reason extends Equatable {
  final String code;
  final String name;
//  final String otherReason;
//  final String reason;

  Reason({
    this.code,
    this.name,
//    this.otherReason,
//    this.reason,

  }) : super([
    code,
    name,
//    otherReason,
//    reason,
  ]);

  Reason copyWith({
    String code,
    String name,
//    String otherReason,
//    String reason,
  })
  {
    return Reason(
      code: code ?? this.code,
      name: name ?? this.name,
//      otherReason: otherReason ?? this.otherReason,
//      reason: reason ?? this.reason,
    );
  }

  @override
  String toString() => '$code|$name';
  static Reason fromJson(dynamic json) {
    return Reason(
      code: json['code'],
      name: json['name'],
    );
  }

//  static Reason toJson(dynamic json) {
//    return Reason(
//      otherReason: json['other_reason'],
//      reason: json['reason'],
//    );
//  }

  factory Reason.empty() {
    return Reason(
      code: '',
      name: '',
//      otherReason: '',
//      reason: '',
    );
  }
}
