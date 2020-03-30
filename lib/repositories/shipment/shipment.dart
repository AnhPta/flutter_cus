//import 'package:app_customer/repositories/detail_shipment/packages.dart';
import 'package:app_customer/repositories/detail_shipment/statuses.dart';
import 'package:app_customer/repositories/pagination/pagination.dart';
import 'package:equatable/equatable.dart';
import 'package:app_customer/repositories/shipment/package.dart';

class Shipment extends Equatable {
  final Pagination pagination;
  final String code;

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

  final String receiverName;
  final String receiverPhone;
  final String toCityCode;
  final String toDistrictCode;
  final String toWardCode;
  final String toCityName;
  final String toDistrictName;
  final String toWardName;
  final String toAddress;
  final String toFullAddress;

  final Package package;
  final String note;
  final String payer;
  final String payerTxt;

  final int rateId;
  final String rateName;
  final String selectedRateName;
  final bool isPartDelivery;
  final bool pickOnHub;
  final bool receiveOnHub;
  final bool draft;

  final List<Statuses> statuses;
  final String status;
  final String statusTxt;
  final String statusColor;

  final double feeTotalPayer;
  final double feeDelivery;
  final double feeOtherTotal;
  final double feeOther;
  final double feeVat;
  final double vat;
  final double totalFee;
  final String deliveryAt;
  final String pickupAt;


  Shipment({
    this.pagination,
    this.code,

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

    this.receiverName,
    this.receiverPhone,
    this.toCityCode,
    this.toDistrictCode,
    this.toWardCode,
    this.toCityName,
    this.toDistrictName,
    this.toWardName,
    this.toAddress,
    this.toFullAddress,

    this.package,
    this.note,
    this.payer,
    this.payerTxt,

    this.rateId,
    this.rateName,
    this.selectedRateName,
    this.isPartDelivery,
    this.pickOnHub,
    this.receiveOnHub,
    this.draft,

    this.statuses,
    this.status,
    this.statusTxt,
    this.statusColor,

    this.feeTotalPayer,
    this.feeDelivery,
    this.feeOtherTotal,
    this.feeOther,
    this.feeVat,
    this.vat,
    this.totalFee,
    this.deliveryAt,
    this.pickupAt,
  }) : super([
    pagination,
    code,

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

    receiverName,
    receiverPhone,
    toCityCode,
    toDistrictCode,
    toWardCode,
    fromCityName,
    fromDistrictName,
    fromWardName,
    toAddress,
    toFullAddress,

    package,
    note,
    payer,
    payerTxt,

    rateId,
    rateName,
    selectedRateName,
    isPartDelivery,
    pickOnHub,
    receiveOnHub,
    draft,

    statuses,
    status,
    statusTxt,
    statusColor,

    feeTotalPayer,
    feeDelivery,
    feeOtherTotal,
    feeOther,
    feeVat,
    vat,
    totalFee,
    deliveryAt,
    pickupAt,
  ]);

  static Shipment fromJson(dynamic json) {
    Package package = Package.empty();
    if(json.containsKey('packages') && json['packages'].length > 0) {
      package = Package.fromJson(json['packages'][0]);
    }

    List<Statuses> statuses = [];
    if (json.containsKey('statuses')) {
      for (final item in json['statuses']) {
        statuses.add(Statuses.fromJson(item));
      }
    }

    return Shipment(
      code: json['code'] is String ? json['code'] : '',
      statusTxt: json['status_txt'] is String ? json['status_txt'] : '',
      receiverName: json['receiver_name'] is String
        ? json['receiver_name']
        : '',
      receiverPhone: json['receiver_phone'] is String
        ? json['receiver_phone']
        : '',
      rateName: json['rate_name'] is String ? json['rate_name'] : '',
      feeTotalPayer: json['fee_total_payer'],
      status: json['status'],
      statusColor: json['status_color'],

      rateId: json['rate_id'],
      draft: json['draft'],
      isPartDelivery: json['is_part_delivery'],
      pickOnHub: json['pick_on_hub'],
      receiveOnHub: json['receive_on_hub'],
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
      toCityName: json['to_city_name'],
      toDistrictName: json['to_district_name'],
      toWardName: json['to_ward_name'],
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

  factory Shipment.empty() {
    return Shipment(
      pickerName: '',
      pickerPhone: '',
      fromCityCode: '',
      fromDistrictCode: '',
      fromWardCode: '',
      fromAddress: '',

      receiverName: '',
      receiverPhone: '',
      toCityCode: '',
      toDistrictCode: '',
      toWardCode: '',
      toAddress: '',

      package: Package.empty(),
      note: '',
      rateId: 0,
      selectedRateName: '',
      payer: 'picker',
      isPartDelivery: false,
      pickOnHub: false,
      receiveOnHub: false,
      draft: true,

      fromCityName: '',
      fromDistrictName: '',
      fromWardName: '',
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

      status: '',
      statusColor: '',
      statuses: [],
    );
  }

  Shipment copyWith({
    String pickerName,
    String pickerPhone,
    String fromCityCode,
    String fromDistrictCode,
    String fromWardCode,
    String fromAddress,

    String receiverName,
    String receiverPhone,
    String toCityCode,
    String toDistrictCode,
    String toWardCode,
    String toAddress,
    Package package,
    String note,
    String payer,
    int rateId,
    String selectedRateName,
    bool isPartDelivery,
    bool pickOnHub,
    bool receiveOnHub,
    bool draft,

    Pagination pagination,
    String code,
    String rateName,
    double feeTotalPayer,
    String status,
    String statusTxt,

    String fromCityName,
    String fromDistrictName,
    String fromWardName,
    String toCityName,
    String toDistrictName,
    String toWardName,
    String fromFullAddress,
    String toFullAddress,
    String payerTxt,
    double feeDelivery,
    double feeOtherTotal,
    double feeOther,
    double feeVat,
    double vat,
    double totalFee,

    String statusColor,
  }) {
    return Shipment(
      pickerName: pickerName ?? this.pickerName,
      pickerPhone: pickerPhone ?? this.pickerPhone,
      fromCityCode: fromCityCode ?? this.fromCityCode,
      fromDistrictCode: fromDistrictCode ?? this.fromDistrictCode,
      fromWardCode: fromWardCode ?? this.fromWardCode,
      fromAddress: fromAddress ?? this.fromAddress,

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
      selectedRateName: selectedRateName ?? this.selectedRateName,
      isPartDelivery: isPartDelivery ?? this.isPartDelivery,
      pickOnHub: pickOnHub ?? this.pickOnHub,
      receiveOnHub: receiveOnHub ?? this.receiveOnHub,
      draft: draft ?? this.draft,

      code: code ?? this.code,
      rateName: rateName ?? this.rateName,
      feeTotalPayer: feeTotalPayer ?? this.feeTotalPayer,
      status: status ?? this.status,
      statusTxt: statusTxt ?? this.statusTxt,

      fromCityName: fromCityName ?? this.fromCityName,
      fromDistrictName: fromDistrictName ?? this.fromDistrictName,
      fromWardName: fromWardName ?? this.fromWardName,
      toCityName: toCityName ?? this.toCityName,
      toDistrictName: toDistrictName ?? this.toDistrictName,
      toWardName: toWardName ?? this.toWardName,
      fromFullAddress: fromFullAddress ?? this.fromFullAddress,
      toFullAddress: toFullAddress ?? this.toFullAddress,
      payerTxt: payerTxt ?? this.payerTxt,
      feeDelivery: feeDelivery ?? this.feeDelivery,
      feeOtherTotal: feeOtherTotal ?? this.feeOtherTotal,
      feeOther: feeOther ?? this.feeOther,
      feeVat: feeVat ?? this.feeVat,
      vat: vat ?? this.vat,
      totalFee: totalFee ?? this.totalFee,

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
    };
  }

  @override
  String toString() =>
    '''$pickerName|$pickerPhone|$fromCityCode|$fromDistrictCode|$fromWardCode|$fromAddress-$receiverName|$receiverPhone|$toCityCode|$toDistrictCode|$toWardCode|$toAddress|
       $package|
       $note|$payer|$rateId|$isPartDelivery|$pickOnHub|$receiveOnHub
       $code|$rateName|$feeTotalPayer|$statusTxt
    ''';
}
