import 'package:equatable/equatable.dart';

class FilterShipment extends Equatable {
  final String ignoreDraft;
  final String statusTxt;
  final String status;
  final String cityPopCode;
  final String cityPopName;
  final String cityPickCode;
  final String cityPickName;
  final String createDate;
  final String dateRanger;
  final String dateRangerTxt;
  final int page;

  FilterShipment({
    this.ignoreDraft,
    this.statusTxt,
    this.status,
    this.cityPickName,
    this.cityPickCode,
    this.cityPopCode,
    this.cityPopName,
    this.createDate,
    this.dateRanger,
    this.dateRangerTxt,
    this.page,
  }) : super([
    ignoreDraft,
    statusTxt,
    status,
    cityPopCode,
    cityPopName,
    cityPickCode,
    cityPickName,
    createDate,
    dateRanger,
    dateRangerTxt,
    page,
  ]);

  static FilterShipment fromJson(dynamic json) {
    return FilterShipment(
      statusTxt: json['status_txt'] is String ? json['status_txt'] : '',
      status: json['status'] is String ? json['status'] : '',
      cityPickCode: json['cityPickCode'] is String ? json['cityPickCode'] : '',
      cityPickName: json['cityPickName'] is String ? json['cityPickName'] : '',
      cityPopName: json['cityPopName'] is String ? json['cityPopName'] : '',
      cityPopCode: json['cityPopCode'] is String ? json['cityPopCode'] : '',
      page: json['page'] is int ? json['page'] : 0,
    );
  }
  factory FilterShipment.empty() {
    return FilterShipment(
      status: '',
      ignoreDraft: 'draft',
      statusTxt: '',
      cityPopCode: '',
      cityPopName: '',
      cityPickName: '',
      cityPickCode: '',
      createDate: '',
      dateRanger: '',
      dateRangerTxt: '',
      page: 1,
    );
  }

  FilterShipment copyWith({
    String statusTxt,
    String ignoreDraft,
    String status,
    String cityPopCode,
    String cityPopName,
    String cityPickCode,
    String cityPickName,
    String createDate,
    String dateRanger,
    String dateRangerTxt,
    int page
  }) {
    return FilterShipment(
      statusTxt: statusTxt ?? this.statusTxt,
      ignoreDraft: ignoreDraft ?? this.ignoreDraft,
      status: status ?? this.status,
      cityPickName: cityPickName ?? this.cityPickName,
      cityPickCode: cityPickCode ?? this.cityPickCode,
      cityPopName: cityPopName ?? this.cityPopName,
      cityPopCode: cityPopCode ?? this.cityPopCode,
      createDate: createDate ?? this.createDate,
      dateRanger: dateRanger ?? this.dateRanger,
      dateRangerTxt: dateRangerTxt ?? this.dateRangerTxt,
      page: page ?? this.page,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ignore_statuses': [this.ignoreDraft],
      'status': this.status,
      'to_city': this.cityPickCode,
      'from_city': this.cityPopCode,
      'date': this.createDate,
      'date_period': this.dateRanger,
      'page': this.page,
    };
  }

  filterShipmentLenght() {
    List arr = [
      this.statusTxt,
      this.cityPopName,
      this.cityPickName,
      this.createDate,
      this.dateRangerTxt,
    ];
    List arr2 = [];
    for (final item in arr) {
      if (item != '') {
        arr2.add(item);
      }
    }
    return arr2.length.toString();
  }

  @override
  String toString() =>
    '$status|$cityPopCode|$cityPickCode|$createDate|$dateRanger|$page';
}

