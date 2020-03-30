import 'package:equatable/equatable.dart';

class Surcharge extends Equatable {
  final double feeCod;
  final double amount;
  final double feeInsurrance;

  Surcharge({
    this.feeCod,
    this.amount,
    this.feeInsurrance,
  }) : super([
    feeCod,
    amount,
    feeInsurrance
  ]);

  Surcharge copyWith({
    double feeCod,
    double amount,
    double feeInsurrance,
  })
  {
    return Surcharge(
      feeCod: feeCod ?? this.feeCod,
      amount: amount ?? this.amount,
      feeInsurrance: feeInsurrance ?? this.feeInsurrance,
    );
  }
  static Surcharge fromJson(dynamic json) {
    return Surcharge(
      feeInsurrance: double.tryParse(json['fee_insurrance'].toString()),
      feeCod: double.tryParse(json['fee_cod'].toString()),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'amount': this.amount,
      'cod': this.feeCod,
    };
  }
  @override
  String toString() => '$feeCod|$amount|$feeInsurrance';

  factory Surcharge.empty() {
    return Surcharge(
      feeCod: 0,
      amount: 0,
      feeInsurrance: 0,
    );
  }
}
