import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final int balance;

  Wallet(
      {this.balance = 0})
      : super([balance]);

  static Wallet fromJson(dynamic json) {
    return Wallet(
      balance: json['balance'],
    );
  }

  Wallet copyWith({
    int balance,
  })
  {
    return Wallet(
      balance: balance ?? this.balance,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'balance': this.balance,
    };
  }
  @override
  String toString() => '$balance';
}
