import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String birthday;
  final String address;
  final String phone;
  final String avatar;
  final String avatarPath;

  User(
      {this.id,
      this.name,
      this.email,
      this.birthday,
      this.address,
      this.phone,
      this.avatar,
      this.avatarPath})
      : super([id, name, email, birthday, address, phone, avatar, avatarPath]);

  static User fromJson(dynamic json) {
    return User(
      id: json['id'],
      name: json['name'] is String ? json['name'] : '',
      email: json['email'] is String ? json['email'] : '',
      birthday: json['birthday'] is String ? json['birthday'] : '',
      address: json['address'] is String ? json['address'] : '',
      phone: json['phone'] is String ? json['phone'] : '',
      avatar: json['avatar'],
      avatarPath: json['avatar_path'],
    );
  }

  User copyWith({
     int id,
     String name,
     String email,
     String birthday,
     String address,
     String phone,
     String avatar,
     String avatarPath,
  })
  {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'phone': this.phone,
      'address': this.address,
      'birthday': this.birthday,
      'email': this.email,
      'avatar': this.avatar,
    };
  }
  @override
  String toString() => '$name|$email|$phone|$birthday|$address';
}
