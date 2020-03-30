import 'package:equatable/equatable.dart';

class Package extends Equatable {
  final double weight;
  final String name;
  final double length;
  final double width;
  final double height;
  final double cod;
  final double amount;
  final int quantity;
  final String note;
  final String code;

  Package({
    this.code,
    this.weight,
    this.name,
    this.length,
    this.width,
    this.height,
    this.cod,
    this.amount,
    this.quantity,
    this.note,

  }) : super([
    weight, name, length, width, height, cod, amount, quantity, note
  ]);

  Package copyWith({
    double weight,
    String code,
    String name,
    double length,
    double width,
    double height,
    double cod,
    double amount,
    int quantity,
    String note,
  })
  {
    return Package(
      weight: weight ?? this.weight,
      name: name ?? this.name,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      cod: cod ?? this.cod,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      code: code ?? this.code,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'weight': this.weight,
      'name': this.name,
      'length': this.length,
      'width': this.width,
      'height': this.height,
      'cod': this.cod,
      'amount': this.amount,
      'quantity': this.quantity,
      'note': this.note,
    };
  }
  @override
  String toString() => '$weight|$name|$weight|$width|$amount|$cod|$height|$quantity|$length';
  static Package fromJson(dynamic json) {
    return Package(
      weight: json['weight'],
      width: json['width'],
      amount: json['amount'],
      cod: json['cod'],
      code: json['code'],
      height: json['height'],
      length: json['length'],
      name: json['name'],
      note: json['note'],
      quantity: json['quantity'],
    );
  }

  factory Package.empty() {
    return Package(
      weight: 0,
      code: '',
      name: '',
      length: 0,
      width: 0,
      height: 0,
      cod: 0,
      amount: 0,
      quantity: 0,
      note: 'Cho xem hàng không cho thử',
    );
  }
}
