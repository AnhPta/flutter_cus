import 'package:equatable/equatable.dart';

class ContactPlace extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String cityCode;
  final String cityName;
  final String districtCode;
  final String districtName;
  final String wardCode;
  final String wardName;
  final String address;
  final String fullAddress;
  final bool isMain;
  final bool isPick;
  final bool status;
  final String statusTxt;
  final bool isActive;

  ContactPlace({
    this.id,
    this.name,
    this.phone,
    this.cityCode,
    this.cityName,
    this.districtCode,
    this.districtName,
    this.wardCode,
    this.wardName,
    this.address,
    this.fullAddress,
    this.isMain,
    this.isPick,
    this.status,
    this.statusTxt,
    this.isActive,
  }) : super([
    id,
    name,
    phone,
    cityCode,
    districtCode,
    districtName,
    wardCode,
    address,
    fullAddress,
    isMain,
    isPick,
    status,
    statusTxt,
    isActive,
  ]);

  factory ContactPlace.empty() {
    return ContactPlace(
      id: 0,
      name: '',
      phone: '',
      cityCode: '',
      districtCode: '',
      wardCode: '',
      cityName: '',
      districtName: '',
      wardName: '',
      address: '',
      isMain: false,
      isPick: false,
      isActive: false,
    );
  }

  static ContactPlace fromJson(dynamic json) {
    return ContactPlace(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      cityCode: json['city_code'],
      cityName: json['city_name'],
      districtCode: json['district_code'],
      districtName: json['district_name'],
      wardCode: json['ward_code'],
      wardName: json['ward_name'],
      address: json['address'],
      fullAddress: json['full_address'],
      isMain: json['is_main'],
      isPick: json['is_pick'],
      status: json['status'],
      statusTxt: json['status_txt'],
    );
  }

  ContactPlace copyWith({
    int id,
    String name,
    String phone,
    String cityCode,
    String districtCode,
    String wardCode,
    String cityName,
    String districtName,
    String wardName,

    String address,
    bool isMain,
    bool isPick,
    String fullAddress,
    bool status,
    String statusTxt,
    bool isActive,
  }) {
    return ContactPlace(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cityCode: cityCode ?? this.cityCode,
      districtCode: districtCode ?? this.districtCode,
      wardCode: wardCode ?? this.wardCode,
      cityName: cityName ?? this.cityName,
      districtName: districtName ?? this.districtName,
      wardName: wardName ?? this.wardName,

      address: address ?? this.address,
      isMain: isMain ?? this.isMain,
      isPick: isPick ?? this.isPick,
      fullAddress: fullAddress ?? this.fullAddress,
      statusTxt: statusTxt ?? this.statusTxt,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'phone': this.phone,
      'city_code': this.cityCode,
      'district_code': this.districtCode,
      'ward_code': this.wardCode,
      'address': this.address,
      'is_main': this.isMain,
      'is_pick': this.isPick,
      'status': this.isActive,
    };
  }

  @override
  String toString() => '''ContactPlace { 
    id: $id, 
    name: $name, 
    phone: $phone, 
    cityCode: $cityCode, 
    districtCode: $districtCode, 
    wardCode: $wardCode,
    address: $address,  
    isMain: $isMain, 
    isPick: $isPick
  }''';
}
