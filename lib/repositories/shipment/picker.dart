import 'package:equatable/equatable.dart';

class Picker extends Equatable {
  final String weight;
  final String name;
  final String length;
  final String width;
  final String height;
  final String cod;
  final String amount;
  final String quantity;
  final String note;

  Picker({
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

  Picker copyWith({
    String weight,
    String name,
    String length,
    String width,
    String height,
    String cod,
    String amount,
    String quantity,
    String note,
  })
  {
    return Picker(
      weight: weight ?? this.weight,
      name: name ?? this.name,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      cod: cod ?? this.cod,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
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
  String toString() => '$weight|$name';

  factory Picker.empty() {
    return Picker(
      weight: '',
      name: '',
      length: '',
      width: '',
      height: '',
      cod: '',
      amount: '',
      quantity: '',
      note: 'Cho xem hàng không cho thử',
    );
  }
}
