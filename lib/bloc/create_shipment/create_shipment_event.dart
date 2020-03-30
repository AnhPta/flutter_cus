import 'package:app_customer/repositories/shipment/package.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateShipmentEvent extends Equatable {
  CreateShipmentEvent([List props = const []]) : super(props);
}

class SetLoadedCreateShipmentEvent extends CreateShipmentEvent {
  @override
  String toString() {
    return 'SetLoadedCreateShipmentEvent';
  }
}

// Nhấn vào nút thêm ghi chú
class AddNoteCreateShipmentEvent extends CreateShipmentEvent {
  final String note;

  AddNoteCreateShipmentEvent({this.note})
    : super([note]);

  @override
  String toString() {
    return 'AddNoteCreateShipmentEvent';
  }
}

class ApplyCreateShipmentEvent extends CreateShipmentEvent {
  final bool isDraft;
  final Package package;
  final String note;

  ApplyCreateShipmentEvent({
    this.isDraft,
    this.package,
    this.note,
  }) :
    super([
      isDraft,
      package,
      note,
    ]);

  @override
  String toString() {
    return 'ApplyCreateShipmentEvent';
  }
}
class ApplyUpdateShipmentEvent extends CreateShipmentEvent {
  final bool isDraft;
  final Package package;
  final String note;
  final String code;

  ApplyUpdateShipmentEvent({
    this.isDraft,
    this.package,
    this.note,
    this.code,
  }) :
    super([
      isDraft,
      package,
      note,
      code,
    ]);

  @override
  String toString() {
    return 'ApplyUpdateShipmentEvent';
  }
}
class UpdatePackageCreateShipmentEvent extends CreateShipmentEvent {
  final Package package;

  UpdatePackageCreateShipmentEvent({this.package})
    : super([package]);

  @override
  String toString() {
    return 'UpdatePackageCreateShipmentEvent';
  }
}
class UpdateTotalFeeCreateShipmentEvent extends CreateShipmentEvent {
  final double feeRate;
  final double feeCod;
  final double feeInsurrance;
  final double feeGiftCode;

  UpdateTotalFeeCreateShipmentEvent({
    this.feeRate,
    this.feeCod,
    this.feeInsurrance,
    this.feeGiftCode,
  }) : super([
    feeRate,
    feeCod,
    feeInsurrance,
    feeGiftCode,
  ]);

  @override
  String toString() {
    return 'UpdateTotalFeeCreateShipmentEvent';
  }
}

class UpdateInfoReceiverCreateShipmentEvent extends CreateShipmentEvent {
  final bool isUpdateReceiver;
  final String receiverName;
  final String receiverPhone;
  final String toAddress;
  final String toCityCode;
  final String toDistrictCode;
  final String toWardCode;
  final String toCityName;
  final String toDistrictName;
  final String toWardName;
  final bool enableSelectWard;

  UpdateInfoReceiverCreateShipmentEvent({
    this.isUpdateReceiver,
    this.receiverName,
    this.receiverPhone,
    this.toAddress,
    this.toCityCode,
    this.toDistrictCode,
    this.toWardCode,
    this.toCityName,
    this.toDistrictName,
    this.toWardName,
    this.enableSelectWard,
  }) :
    super([
      isUpdateReceiver,
      receiverName,
      receiverPhone,
      toAddress,
      toCityCode,
      toDistrictCode,
      toWardCode,
      toCityName,
      toDistrictName,
      toWardName,
      enableSelectWard,
    ]);

  @override
  String toString() {
    return '''UpdateInfoReceiverCreateShipmentEvent {
      isUpdateReceiver: $isUpdateReceiver,
      receiverName: $receiverName,
      receiverPhone: $receiverPhone,
      toAddress: $toAddress,
      toCityCode: $toCityCode,
      toDistrictCode: $toDistrictCode,
      toWardCode: $toWardCode,
      toCityName: $toCityName,
      toDistrictName: $toDistrictName,
      toWardName: $toWardName,
      enableSelectWard: $enableSelectWard,
    }''';
  }
}
class FetchRateCreateShipmentEvent extends CreateShipmentEvent {
  final String from;
  final String to;
  final String weight;
  final String length;
  final String width;
  final String height;

  FetchRateCreateShipmentEvent({
    this.from,
    this.to,
    this.weight,
    this.length,
    this.width,
    this.height,
  }) : super([
    from,
    to,
    weight,
    length,
    width,
    height,
  ]);

  @override
  String toString() {
    return 'FetchRateCreateShipmentEvent';
  }
}
class FetchApplyPromotionCreateShipmentEvent extends CreateShipmentEvent {
  final String code;

  FetchApplyPromotionCreateShipmentEvent({this.code})
    : super([code]);

  @override
  String toString() {
    return 'FetchApplyPromotionCreateShipmentEvent';
  }
}
class OpenTabCreateShipmentEvent extends CreateShipmentEvent {
  final String tab;

  OpenTabCreateShipmentEvent({this.tab})
    : super([tab]);

  @override
  String toString() {
    return 'OpenTabCreateShipmentEvent: { tab: $tab }';
  }
}
class ChangePayerCreateShipmentEvent extends CreateShipmentEvent {
  final String payer;

  ChangePayerCreateShipmentEvent({this.payer})
    : super([payer]);

  @override
  String toString() {
    return 'ChangePayerCreateShipmentEvent';
  }
}
class ChangePickOnHubCreateShipmentEvent extends CreateShipmentEvent {
  final bool pickOnHub;

  ChangePickOnHubCreateShipmentEvent({this.pickOnHub})
    : super([pickOnHub]);

  @override
  String toString() {
    return 'ChangePickOnHubCreateShipmentEvent';
  }
}
class ChangeRateIDCreateShipmentEvent extends CreateShipmentEvent {
  final int rateID;
  final String rateName;

  ChangeRateIDCreateShipmentEvent({
    this.rateID,
    this.rateName
  }) :
    super([
      rateID,
      rateName
    ]);

  @override
  String toString() {
    return 'ChangeRateIDCreateShipmentEvent';
  }
}
class FetchSurchargeCreateShipmentEvent extends CreateShipmentEvent {
  final double cod;
  final double amount;

  FetchSurchargeCreateShipmentEvent({
    this.cod,
    this.amount,
  }) : super([
    cod,
    amount
  ]);

  @override
  String toString() {
    return 'FetchSurchargeCreateShipmentEvent';
  }
}
class UpdatePickerEvent extends CreateShipmentEvent {
  final bool isSelectedPicker;
  final String selectedPickerName;
  final String selectedPickerPhone;
  final String selectedFromAddress;
  final String selectedFromCityCode;
  final String selectedFromDistrictCode;
  final String selectedFromWardCode;

  UpdatePickerEvent({
    this.isSelectedPicker,
    this.selectedPickerName,
    this.selectedPickerPhone,
    this.selectedFromAddress,
    this.selectedFromCityCode,
    this.selectedFromDistrictCode,
    this.selectedFromWardCode,
  }) : super([
    isSelectedPicker,
    selectedPickerName,
    selectedPickerPhone,
    selectedFromAddress,
    selectedFromCityCode,
    selectedFromDistrictCode,
    selectedFromWardCode,
  ]);

  @override
  String toString() {
    return '''UpdatePickerEvent {
      isSelectedPicker: $isSelectedPicker,
      selectedPickerName: $selectedPickerName,
      selectedPickerPhone: $selectedPickerPhone,
      selectedFromAddress: $selectedFromAddress,
      selectedFromCityCode: $selectedFromCityCode,
      selectedFromDistrictCode: $selectedFromDistrictCode,
      selectedFromWardCode: $selectedFromWardCode,
    }''';
  }
}
class UpdateCityCreateShipmentEvent extends CreateShipmentEvent {
  final String selectedCityCode;
  final String selectedCityName;
  final bool enableSelectDistrict;

  UpdateCityCreateShipmentEvent({
    this.selectedCityCode,
    this.selectedCityName,
    this.enableSelectDistrict,
  }) : super([
    selectedCityCode,
    selectedCityName,
    enableSelectDistrict,
  ]);

  @override
  String toString() {
    return '''UpdateCityCreateShipmentEvent {
      code: $selectedCityCode,
      name: $selectedCityName,
      enableSelectDistrict: $enableSelectDistrict,
    }''';
  }
}
class UpdateDistrictCreateShipmentEvent extends CreateShipmentEvent {
  final String selectedDistrictCode;
  final String selectedDistrictName;
  final bool enableSelectWard;

  UpdateDistrictCreateShipmentEvent({
    this.selectedDistrictCode,
    this.selectedDistrictName,
    this.enableSelectWard,
  }) : super([
    selectedDistrictCode,
    selectedDistrictName,
    enableSelectWard,
  ]);

  @override
  String toString() {
    return '''UpdateDistrictCreateShipmentEvent {
      code: $selectedDistrictCode,
      name: $selectedDistrictName,
      enableSelectWard: $enableSelectWard,
    }''';
  }
}
class UpdateWardCreateShipmentEvent extends CreateShipmentEvent {
  final String selectedWardCode;
  final String selectedWardName;

  UpdateWardCreateShipmentEvent({
    this.selectedWardCode,
    this.selectedWardName,
  }) : super([
    selectedWardCode,
    selectedWardName,
  ]);

  @override
  String toString() {
    return '''UpdateWardCreateShipmentEvent {
      code: $selectedWardCode,
      name: $selectedWardName,
    }''';
  }
}
class ClearStateCreateShipmentEvent extends CreateShipmentEvent {
  @override
  String toString() {
    return 'ClearStateCreateShipmentEvent';
  }
}
