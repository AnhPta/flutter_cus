import 'package:app_customer/repositories/shipment/rate.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:app_customer/repositories/shipment/surcharge.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CreateShipmentState extends Equatable {
  CreateShipmentState([List props = const []]) : super(props);
}

class InitialCreateShipmentState extends CreateShipmentState {
  @override
  String toString() {
    return 'InitialCreateShipmentState';
  }
}

class LoadedCreateShipmentState extends CreateShipmentState {
  final Shipment shipment;
  final bool loadingSubmitDraft;
  final bool loadingSubmitSend;
  final List<Rate> rates;
  final Surcharge surcharges;
  final String tab;
  final bool loadingRate;
  final bool isSelectedPicker;
  final double discount;

  final bool isUpdateReceiver;
  final bool enableSelectWard;
  final bool enableSelectDistrict;

  final double feeRate;
  final double feeCod;
  final double feeInsurrance;
  final double feeGiftCode;


  LoadedCreateShipmentState({
    @required this.shipment,
    this.loadingSubmitDraft,
    this.loadingSubmitSend,
    this.rates,
    this.surcharges,
    this.tab,
    this.loadingRate,
    this.isSelectedPicker,
    this.isUpdateReceiver,
    this.enableSelectDistrict,
    this.enableSelectWard,
    this.discount,
    this.feeRate,
    this.feeCod,
    this.feeInsurrance,
    this.feeGiftCode,
  }) : super([
    shipment,
    loadingSubmitDraft,
    loadingSubmitSend,
    rates,
    surcharges,
    tab,
    loadingRate,
    isSelectedPicker,
    isUpdateReceiver,
    enableSelectDistrict,
    enableSelectWard,
    discount,
    feeRate,
    feeCod,
    feeInsurrance,
    feeGiftCode,
  ]);

  factory LoadedCreateShipmentState.empty() {
    return LoadedCreateShipmentState(
      shipment: Shipment.empty(),
      loadingSubmitDraft: false,
      loadingSubmitSend: false,
      rates: [],
      surcharges: Surcharge.empty(),
      tab: '',
      loadingRate: false,
      isSelectedPicker: false,
      isUpdateReceiver: false,
      enableSelectDistrict: false,
      enableSelectWard: false,
      discount: 0,
      feeRate: 0,
      feeCod: 0,
      feeInsurrance: 0,
      feeGiftCode: 0,
    );
  }

  @override
  String toString() {
    return 'LoadedCreateShipmentState { feeRate: $feeRate, shipment: $shipment, rate: $rates, surcharge: $surcharges }';
  }
  LoadedCreateShipmentState copyWith({
    Shipment shipment,
    bool loadingSubmitDraft,
    bool loadingSubmitSend,
    List<Rate> rates,
    Surcharge surcharges,
    String tab,
    bool loadingRate,
    bool isSelectedPicker,
    bool isUpdateReceiver,
    bool enableSelectDistrict,
    bool enableSelectWard,
    double discount,
    double feeRate,
    double feeCod,
    double feeInsurrance,
    double feeGiftCode,
  })
  {
    return LoadedCreateShipmentState(
      shipment: shipment ?? this.shipment,
      loadingSubmitDraft: loadingSubmitDraft ?? this.loadingSubmitDraft,
      loadingSubmitSend: loadingSubmitSend ?? this.loadingSubmitSend,
      rates: rates ?? this.rates,
      surcharges: surcharges ?? this.surcharges,
      tab: tab ?? this.tab,
      loadingRate: loadingRate ?? this.loadingRate,
      isSelectedPicker: isSelectedPicker ?? this.isSelectedPicker,
      isUpdateReceiver: isUpdateReceiver ?? this.isUpdateReceiver,
      enableSelectDistrict: enableSelectDistrict ?? this.enableSelectDistrict,
      enableSelectWard: enableSelectWard ?? this.enableSelectWard,
      discount: discount ?? this.discount,
      feeRate: feeRate ?? this.feeRate,
      feeCod: feeCod ?? this.feeCod,
      feeInsurrance: feeInsurrance ?? this.feeInsurrance,
      feeGiftCode: feeGiftCode ?? this.feeGiftCode,
    );
  }
}
