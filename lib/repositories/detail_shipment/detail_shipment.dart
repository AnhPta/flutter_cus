import 'package:app_customer/repositories/detail_shipment/packages.dart';
import 'package:app_customer/repositories/detail_shipment/statuses.dart';
import 'package:app_customer/repositories/pagination/pagination.dart';
import 'package:equatable/equatable.dart';

class DetailShipment extends Equatable {
  final String pickerName;
  final String pickerPhone;
  final String fromCityCode;
  final String fromDistrictCode;
  final String fromWardCode;
  final String fromCityName;
  final String fromDistrictName;
  final String fromWardName;
  final String fromAddress;
  final String fromFullAddress;

  final String toFullAddress;
  final String payerTxt;
  final double feeDelivery;
  final double feeOtherTotal;
  final double feeOther;
  final double feeVat;
  final double vat;
  final double totalFee;
  final double feeTotalPayer;
  final String deliveryAt;
  final String pickupAt;

  final String receiverName;
  final String receiverPhone;
  final String toCityCode;
  final String toDistrictCode;
  final String toWardCode;
  final String toAddress;
  final Package package;
  final List<Statuses> statuses;
  final String note;
  final String payer;
  final int rateId;
  final bool isPartDelivery;
  final bool pickOnHub;
  final bool receiveOnHub;
  final bool draft;
  final Pagination pagination;
  final String code;
  final String rateName;
  final String status;
  final String statusTxt;
  final String statusColor;
  DetailShipment({
    this.pickerName,
    this.pickerPhone,
    this.fromCityCode,
    this.fromDistrictCode,
    this.fromWardCode,
    this.fromCityName,
    this.fromDistrictName,
    this.fromWardName,
    this.fromAddress,
    this.fromFullAddress,
    this.toFullAddress,
    this.statuses,

    this.payerTxt,
    this.feeDelivery,
    this.feeOtherTotal,
    this.feeOther,
    this.feeVat,
    this.vat,
    this.totalFee,
    this.deliveryAt,
    this.pickupAt,

    this.toCityCode,
    this.toDistrictCode,
    this.toWardCode,
    this.toAddress,
    this.receiverName,
    this.receiverPhone,
    this.package,
    this.note,
    this.payer,
    this.rateId,
    this.isPartDelivery,
    this.pickOnHub,
    this.receiveOnHub,
    this.draft,

    this.pagination,
    this.code,
    this.rateName,
    this.feeTotalPayer,
    this.status,
    this.statusTxt,
    this.statusColor,
  }) : super([
    pickerName,
    pickerPhone,
    fromCityCode,
    fromDistrictCode,
    fromWardCode,
    fromCityName,
    fromDistrictName,
    fromWardName,
    fromAddress,
    fromFullAddress,
    toFullAddress,
    statuses,

    payerTxt,
    feeDelivery,
    feeOtherTotal,
    feeOther,
    feeVat,
    vat,
    totalFee,
    deliveryAt,
    pickupAt,

    receiverName,
    receiverPhone,
    toCityCode,
    toDistrictCode,
    toWardCode,
    toAddress,
    receiverName,
    receiverPhone,
    package,
    note,
    payer,
    rateId,
    isPartDelivery,
    pickOnHub,
    receiveOnHub,
    draft,
    pagination,
    code,
    rateName,
    feeTotalPayer,
    status,
    statusTxt,
    statusColor,
  ]);

  static DetailShipment fromJson(dynamic json) {
    Package package = Package.empty();
    if(json['packages'].length > 0) {
      package = Package.fromJson(json['packages'][0]);
    }

    List<Statuses> statuses = [];
    if (json.containsKey('statuses')) {
      for (final item in json['statuses']) {
        statuses.add(Statuses.fromJson(item));
      }
    }
    return DetailShipment(
      code: json['code'] is String ? json['code'] : '',
      statusTxt: json['status_txt'] is String ? json['status_txt'] : '',
      statusColor: json['status_color'] is String ? json['status_color'] : '',
      receiverName: json['receiver_name'] is String ? json['receiver_name'] : '',
      receiverPhone: json['receiver_phone'] is String ? json['receiver_phone'] : '',
      rateId: json['rate_id'],
      draft: json['draft'],
      isPartDelivery: json['is_part_delivery'],
      pickOnHub: json['pick_on_hub'],
      receiveOnHub: json['receive_on_hub'],
      rateName: json['rate_name'] is String ? json['rate_name'] : '',
      feeTotalPayer: json['fee_total_payer'],
      status: json['status'] is String ? json['status'] : '',
      fromAddress: json['from_address'],
      fromFullAddress: json['from_full_address'],
      toFullAddress: json['to_full_address'],
      fromCityCode: json['from_city_code'],
      fromDistrictCode: json['from_district_code'],
      fromWardCode: json['from_ward_code'],
      fromCityName: json['from_city_name'],
      fromDistrictName: json['from_district_name'],
      fromWardName: json['from_ward_name'],
      note: json['note'],
      pickerName: json['picker_name'],
      payer: json['payer'],
      package: package,
      statuses: statuses,
      pickerPhone: json['picker_phone'],
      toAddress: json['to_address'],
      toCityCode: json['to_city_code'],
      toDistrictCode: json['to_district_code'],
      toWardCode: json['to_ward_code'],
      payerTxt: json['payer_txt'],
      feeDelivery: json['fee_delivery'],
      feeOtherTotal: json['fee_other_total'],
      feeOther: json['fee_other'],
      feeVat: json['fee_vat'],
      vat: json['vat'],
      totalFee: json['total_fee'],
      deliveryAt: json['delivery_at'] is String ? json['delivery_at'] : '',
      pickupAt: json['pickup_at'] is String ? json['pickup_at'] : '',
    );
  }

  factory DetailShipment.empty() {
    return DetailShipment(
      pickerName: '',
      pickerPhone: '',
      fromCityCode: '',
      fromDistrictCode: '',
      fromWardCode: '',
      fromCityName: '',
      fromDistrictName: '',
      fromWardName: '',
      fromAddress: '',
      fromFullAddress: '',
      toFullAddress: '',
      payerTxt: '',
      feeDelivery: 0,
      feeOtherTotal: 0,
      feeOther: 0,
      feeVat: 0,
      vat: 0,
      feeTotalPayer: 0,
      totalFee: 0,
      deliveryAt: '',

      receiverName: '',
      receiverPhone: '',
      toCityCode: '',
      toDistrictCode: '',
      toWardCode: '',
      toAddress: '',
      status: '',
      statusColor: '',
      package: Package.empty(),
      statuses: [],
      note: '',
      rateId: 0,
      payer: 'picker',
      isPartDelivery: false,
      pickOnHub: false,
      receiveOnHub: false,
      draft: true,
    );
  }

  DetailShipment copyWith({
    String pickerName,
    String pickerPhone,
    String fromCityCode,
    String fromDistrictCode,
    String fromWardCode,
    String fromCityName,
    String fromDistrictName,
    String fromWardName,
    String fromAddress,
    String fromFullAddress,
    String toFullAddress,
    String payerTxt,
    double feeDelivery,
    double feeOtherTotal,
    double feeOther,
    double feeVat,
    double vat,
    double totalFee,

    String receiverName,
    String receiverPhone,
    String toCityCode,
    String toDistrictCode,
    String toWardCode,
    String toAddress,
//    Package package,
    String note,
    String payer,
    int rateId,
    bool isPartDelivery,
    bool pickOnHub,
    bool receiveOnHub,
    double draft,
    Pagination pagination,
    String code,
    String rateName,
    double feeTotalPayer,
    String status,
    String statusTxt,
    String statusColor,
  }) {
    return DetailShipment(
      pickerName: pickerName ?? this.pickerName,
      pickerPhone: pickerPhone ?? this.pickerPhone,
      fromCityCode: fromCityCode ?? this.fromCityCode,
      fromDistrictCode: fromDistrictCode ?? this.fromDistrictCode,
      fromWardCode: fromWardCode ?? this.fromWardCode,
      fromCityName: fromCityName ?? this.fromCityName,
      fromDistrictName: fromDistrictName ?? this.fromDistrictName,
      fromWardName: fromWardName ?? this.fromWardName,
      fromAddress: fromAddress ?? this.fromAddress,
      fromFullAddress: fromFullAddress ?? this.fromFullAddress,
      toFullAddress: toFullAddress ?? this.toFullAddress,
      payerTxt: payerTxt ?? this.payerTxt,
      feeDelivery: feeDelivery ?? this.feeDelivery,
      feeOtherTotal: feeOtherTotal ?? this.feeOtherTotal,
      feeOther: feeOther ?? this.feeOther,
      feeVat: feeVat ?? this.feeVat,
      vat: vat ?? this.vat,
      totalFee: totalFee ?? this.totalFee,

      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      toCityCode: toCityCode ?? this.toCityCode,
      toDistrictCode: toDistrictCode ?? this.toDistrictCode,
      toWardCode: toWardCode ?? this.toWardCode,
      toAddress: toAddress ?? this.toAddress,
      package: package ?? this.package,
      note: note ?? this.note,
      payer: payer ?? this.payer,
      rateId: rateId ?? this.rateId,
      isPartDelivery: isPartDelivery ?? this.isPartDelivery,
      pickOnHub: pickOnHub ?? this.pickOnHub,
      receiveOnHub: receiveOnHub ?? this.receiveOnHub,
      draft: draft ?? this.draft,

      code: code ?? this.code,
      rateName: rateName ?? this.rateName,
      feeTotalPayer: feeTotalPayer ?? this.feeTotalPayer,
      status: status ?? this.status,
      statusTxt: statusTxt ?? this.statusTxt,
      statusColor: statusColor ?? this.statusColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'picker_name': this.pickerName,
      'picker_phone': this.pickerPhone,
      'from_city_code': this.fromCityCode,
      'from_district_code': this.fromDistrictCode,
      'from_ward_code': this.fromWardCode,
      'from_city_name': this.fromCityName,
      'from_district_name': this.fromDistrictName,
      'from_ward_name': this.fromWardName,
      'from_address': this.fromAddress,

      'receiver_name': this.receiverName,
      'receiver_phone': this.receiverPhone,
      'to_city_code': this.toCityCode,
      'to_district_code': this.toDistrictCode,
      'to_ward_code': this.toWardCode,
      'to_address': this.toAddress,

      'packages': [this.package.toJson()],
      'note': this.note,
      'payer': this.payer,
      'rate_id': this.rateId,
      "is_part_delivery": this.isPartDelivery,
      'pick_on_hub': this.pickOnHub,
      "receive_on_hub": this.receiveOnHub,
      "draft": this.draft,
      "code": this.code,
    };
  }

  @override
  String toString() =>
    '''$pickerName|$pickerPhone|$fromCityCode|$fromDistrictCode|$fromWardCode|$fromAddress|
       $receiverName|$receiverPhone|$toCityCode|$toDistrictCode|$toWardCode|$toAddress|
       $package| $statuses |
       $note|$payer|$rateId|$isPartDelivery|$pickOnHub|$receiveOnHub
       $code|$rateName|$feeTotalPayer|$statusTxt
    ''';
}
