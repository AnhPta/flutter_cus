import 'dart:async';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/repositories/shipment/package.dart';
import 'package:app_customer/repositories/shipment/rate.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:app_customer/repositories/shipment/shipment_repository.dart';
import 'package:app_customer/repositories/shipment/surcharge.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class CreateShipmentBloc extends Bloc<CreateShipmentEvent, CreateShipmentState> {
  final ShipmentRepository shipmentRepository;
  final AuthenticationBloc authenticationBloc;
  final NotifyBloc notifyBloc;
  final NavigationBloc navigationBloc;

  @override
  CreateShipmentState get initialState => InitialCreateShipmentState();

  CreateShipmentBloc({
    @required this.navigationBloc,
    @required this.authenticationBloc,
    @required this.notifyBloc,
    @required this.shipmentRepository,
  })  :
      assert(navigationBloc != null),
      assert(notifyBloc != null),
      assert(authenticationBloc != null),
      assert(shipmentRepository != null);

  @override
  Stream<CreateShipmentState> mapEventToState(
    CreateShipmentEvent event,
  ) async* {
    if (event is SetLoadedCreateShipmentEvent) {
      yield* _mapSetLoadedCreateShipmentEventToState();
    }
    if (event is AddNoteCreateShipmentEvent) {
      yield* _mapAddNoteCreateShipmentEventToState(event.note);
    }
    if (event is ApplyCreateShipmentEvent) {
      yield* _mapApplyCreateShipmentEventToState(event);
    }
    if (event is ApplyUpdateShipmentEvent) {
      yield* _mapApplyUpdateShipmentEventToState(event);
    }
    if (event is UpdatePackageCreateShipmentEvent) {
      yield* _mapUpdatePackageCreateShipmentEventToState(event.package);
    }
    if (event is FetchRateCreateShipmentEvent) {
      yield* _mapFetchRateCreateShipmentEventToState(event);
    }
    if (event is OpenTabCreateShipmentEvent) {
      yield* _mapOpenTabCreateShipmentEventToState(event);
    }
    if (event is ChangePayerCreateShipmentEvent) {
      yield* _mapChangePayerCreateShipmentEventToState(event.payer);
    }
    if (event is ChangePickOnHubCreateShipmentEvent) {
      yield* _mapChangePickOnHubCreateShipmentEventToState(event.pickOnHub);
    }
    if (event is ChangeRateIDCreateShipmentEvent) {
      yield* _mapChangeRateIDCreateShipmentEventToState(event);
    }
    if (event is FetchApplyPromotionCreateShipmentEvent) {
      yield* _mapFetchApplyPromotionCreateShipmentEventToState(event.code);
    }
    if (event is UpdatePickerEvent) {
      yield* _mapUpdatePickerEventToState(event);
    }
    if (event is UpdateCityCreateShipmentEvent) {
      yield* _mapUpdateCityCreateShipmentEventToState(event);
    }
    if (event is UpdateDistrictCreateShipmentEvent) {
      yield* _mapUpdateDistrictCreateShipmentEventToState(event);
    }
    if (event is UpdateWardCreateShipmentEvent) {
      yield* _mapUpdateWardCreateShipmentEventToState(event);
    }
    if (event is UpdateInfoReceiverCreateShipmentEvent) {
      yield* _mapUpdateInfoReceiverCreateShipmentEventToState(event);
    }
    if (event is UpdateTotalFeeCreateShipmentEvent) {
      yield* _mapUpdateTotalFeeCreateShipmentEventToState(event);
    }
    if (event is FetchSurchargeCreateShipmentEvent) {
      yield* _mapFetchSurchargeCreateShipmentEventToState(event);
    }
    if (event is ClearStateCreateShipmentEvent) {
      yield* _mapClearStateCreateShipmentEventToState();
    }
  }

  Stream<CreateShipmentState> _mapClearStateCreateShipmentEventToState() async* {
    if (currentState is LoadedCreateShipmentState) {
      Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
      shipment = shipment.copyWith(
        toCityCode: '',
        toDistrictCode: '',
        toWardCode: '',
        toCityName: '',
        toDistrictName: '',
        toWardName: '',
      );
      yield (currentState as LoadedCreateShipmentState).copyWith(
        shipment: shipment,
        enableSelectDistrict: false,
        enableSelectWard: false
      );
    }
  }

  Stream<CreateShipmentState> _mapUpdateTotalFeeCreateShipmentEventToState(UpdateTotalFeeCreateShipmentEvent event) async* {
    yield (currentState as LoadedCreateShipmentState).copyWith(
      feeRate: event.feeRate
    );
  }

  bool validateCreateShipment (shipment) {
    List errors = [];

    if (shipment.pickerName == '') {
      errors.add('Vui lòng nhập thông tin người gửi');
    }


    if (shipment.receiverName == '' && shipment.receiverPhone == '') {
      errors.add('Vui lòng nhập thông tin người nhận');
    }
    if (shipment.receiverName == '') {
      errors.add('Vui lòng nhập tên người nhận');
    }
    if (shipment.receiverPhone == '') {
      errors.add('Vui lòng nhập số điện thoại người nhận');
    }
    if (shipment.receiverPhone.length < 10 || shipment.receiverPhone.length > 11) {
      errors.add('Số điện thoại người nhận có độ dài từ 10 đến 11 kí tự');
    }
    if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(shipment.receiverPhone) == false) {
      errors.add('Số điện thoại người nhận không đúng định dạng');
    }
    if (shipment.toCityCode == '') {
      errors.add('Vui lòng nhập Tỉnh/thành phố người nhận');
    }
    if (shipment.toDistrictCode == '') {
      errors.add('Vui lòng nhập Quận/huyện người nhận');
    }
    if (shipment.toWardCode == '') {
      errors.add('Vui lòng nhập Phường/xã người nhận');
    }
    if (shipment.toAddress == '') {
      errors.add('Vui lòng nhập địa chỉ người nhận');
    }
    if (shipment.package.name == '') {
      errors.add('Vui lòng nhập thông tin hàng hóa');
    }


    if (shipment.rateId == 0) {
      errors.add('Vui lòng chọn bảng giá dịch vụ');
    }

    if (errors.length > 0) {
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.WARNING,
        message: errors.first)
      );
      return false;
    }
    return true;
  }

  Stream<CreateShipmentState> handlerDioError (e) async* {
    try {
      Map response = {};
      Map errors = {};
      String errorMessage = "Không xác định";
      if (e.response == null) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố')
        );
      }
      if (e.response != null) {
        switch (e.response.statusCode) {
          case 401:
            authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.WARNING,
              message: 'Phiên làm việc của bạn đã hết hạn')
            );
            break;
          case 402:
            response = e.response.data;
            if (response.containsKey('data') && response['data'] is Map && response['data'].containsKey('errors')) {
              errors = response['data']['errors'];
              errorMessage = errors.values.first[0];
            } else {
              errorMessage = response['message'];
            }
            yield (currentState as LoadedCreateShipmentState).copyWith(
              loadingSubmitDraft: false,
              loadingSubmitSend: false
            );
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.WARNING,
              message: errorMessage is String ? errorMessage : '')
            );
            break;
          case 403:
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: 'Bạn không có quyền thực hiện tác vụ này')
            );
            break;
          case 404:
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: 'Dữ liệu không tồn tại')
            );
            break;
          case 422:
            response = e.response.data;
            if (response.containsKey('data') && response['data'] is Map && response['data'].containsKey('errors')) {
              errors = response['data']['errors'];
              errorMessage = errors.values.first[0];
            } else {
              errorMessage = response['message'];
            }
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: errorMessage is String ? errorMessage : '')
            );
            break;
          case 500:
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: 'Server gặp sự cố, vui lòng thử lại sau')
            );
            break;
          default:
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: e.toString())
            );
            break;
        }
      }
    } catch (error) {
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.ERROR,
        message: error.toString())
      );
      return;
    }
  }

  Stream<CreateShipmentState> _mapUpdateCityCreateShipmentEventToState(UpdateCityCreateShipmentEvent event) async* {
    if (currentState is LoadedCreateShipmentState) {
      Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
      shipment = shipment.copyWith(
        toCityCode: event.selectedCityCode,
        toDistrictCode: '',
        toWardCode: '',
        toCityName: event.selectedCityName,
        toDistrictName: '',
        toWardName: '',
      );
      yield (currentState as LoadedCreateShipmentState).copyWith(
        shipment: shipment,
        enableSelectDistrict: event.enableSelectDistrict
      );
    }
  }

  Stream<CreateShipmentState> _mapUpdateDistrictCreateShipmentEventToState(UpdateDistrictCreateShipmentEvent event) async* {
    if (currentState is LoadedCreateShipmentState) {
      Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
      shipment = shipment.copyWith(
        toDistrictCode: event.selectedDistrictCode,
        toWardCode: '',
        toDistrictName: event.selectedDistrictName,
        toWardName: '',
      );
      yield (currentState as LoadedCreateShipmentState).copyWith(
        shipment: shipment,
        enableSelectWard: event.enableSelectWard
      );
    }
  }

  Stream<CreateShipmentState> _mapUpdateWardCreateShipmentEventToState(UpdateWardCreateShipmentEvent event) async* {
    if (currentState is LoadedCreateShipmentState) {
      Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
      shipment = shipment.copyWith(
        toWardCode: event.selectedWardCode,
        toWardName: event.selectedWardName,
      );
      yield (currentState as LoadedCreateShipmentState).copyWith(
        shipment: shipment,
      );
    }
  }

  Stream<CreateShipmentState> _mapUpdatePickerEventToState(UpdatePickerEvent event) async* {
    if (currentState is LoadedCreateShipmentState) {
      Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
      shipment = shipment.copyWith(
        pickerName: event.selectedPickerName,
        pickerPhone: event.selectedPickerPhone,
        fromAddress: event.selectedFromAddress,
        fromCityCode: event.selectedFromCityCode,
        fromDistrictCode: event.selectedFromDistrictCode,
        fromWardCode: event.selectedFromWardCode,
      );
      yield (currentState as LoadedCreateShipmentState).copyWith(
        shipment: shipment,
        isSelectedPicker: event.isSelectedPicker
      );
    }
  }


  Stream<CreateShipmentState> _mapUpdateInfoReceiverCreateShipmentEventToState(UpdateInfoReceiverCreateShipmentEvent event) async* {
    Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
    shipment = shipment.copyWith(
      receiverName: event.receiverName,
      receiverPhone: event.receiverPhone,
      toCityCode: event.toCityCode,
      toDistrictCode: event.toDistrictCode,
      toWardCode: event.toWardCode,
      toCityName: event.toCityName,
      toDistrictName: event.toDistrictName,
      toWardName: event.toWardName,
      toAddress: event.toAddress,
    );
    yield (currentState as LoadedCreateShipmentState).copyWith(
      isUpdateReceiver: event.isUpdateReceiver,
      shipment: shipment,
      enableSelectDistrict: true,
      enableSelectWard: event.enableSelectWard,
    );
  }

  Stream<CreateShipmentState> _mapSetLoadedCreateShipmentEventToState() async* {
    yield LoadedCreateShipmentState.empty();
  }

  Stream<CreateShipmentState> _mapAddNoteCreateShipmentEventToState(String note) async* {
    Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
    shipment = shipment.copyWith(note: note);
    yield (currentState as LoadedCreateShipmentState).copyWith(shipment: shipment);
  }

  Stream<CreateShipmentState> _mapUpdatePackageCreateShipmentEventToState(Package package) async* {
    if (currentState is LoadedCreateShipmentState) {
      try {
        Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
        shipment = shipment.copyWith(package: package);
        yield (currentState as LoadedCreateShipmentState).copyWith(shipment: shipment);
      } on DioError catch (e) {
        yield* handlerDioError(e);
      } catch (error) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: error.toString())
        );
      }
    }
  }
  Stream<CreateShipmentState> _mapApplyCreateShipmentEventToState(ApplyCreateShipmentEvent event) async* {
    if (currentState is LoadedCreateShipmentState) {
      try {
        Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
        shipment = shipment.copyWith(package: event.package, draft: event.isDraft, note: event.note);
        yield (currentState as LoadedCreateShipmentState).copyWith(shipment: shipment);

        if (validateCreateShipment(shipment)) {
          yield (currentState as LoadedCreateShipmentState).copyWith(
            loadingSubmitDraft: event.isDraft,
            loadingSubmitSend: !event.isDraft
          );
          await shipmentRepository.createShipment(shipment);
          notifyBloc.dispatch(ShowNotifyEvent(
            type: NotifyEvent.SUCCESS,
            message: 'Tạo mới thành công')
          );
          yield (currentState as LoadedCreateShipmentState).copyWith(
            loadingSubmitDraft: false,
            loadingSubmitSend: false
          );
          navigationBloc.dispatch(ChangeIndexPageEvent(index: 1));
        }
      } on DioError catch (e) {
        yield* handlerDioError(e);
        yield (currentState as LoadedCreateShipmentState).copyWith(
          loadingSubmitDraft: false,
          loadingSubmitSend: false
        );
      } catch (error) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: error.toString())
        );
        yield (currentState as LoadedCreateShipmentState).copyWith(
          loadingSubmitDraft: false,
          loadingSubmitSend: false
        );
      }
    }
  }
  Stream<CreateShipmentState> _mapApplyUpdateShipmentEventToState(ApplyUpdateShipmentEvent event) async* {
    if (currentState is LoadedCreateShipmentState) {
      try {
        Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
        shipment = shipment.copyWith(package: event.package, draft: event.isDraft, note: event.note, code: event.code);
        yield (currentState as LoadedCreateShipmentState).copyWith(shipment: shipment);

        if (validateCreateShipment(shipment)) {
          yield (currentState as LoadedCreateShipmentState).copyWith(
            loadingSubmitDraft: !event.isDraft,
            loadingSubmitSend: event.isDraft
          );
          await shipmentRepository.updateShipment(shipment);
          notifyBloc.dispatch(ShowNotifyEvent(
            type: NotifyEvent.SUCCESS,
            message: 'Cập nhật thành công')
          );
          yield (currentState as LoadedCreateShipmentState).copyWith(
            loadingSubmitDraft: false,
            loadingSubmitSend: false
          );
          navigationBloc.dispatch(ChangeIndexPageEvent(index: 1));
        }
      } on DioError catch (e) {
        yield* handlerDioError(e);
        yield (currentState as LoadedCreateShipmentState).copyWith(
          loadingSubmitDraft: false,
          loadingSubmitSend: false
        );
      } catch (error) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.ERROR,
          message: error.toString())
        );
        yield (currentState as LoadedCreateShipmentState).copyWith(
          loadingSubmitDraft: false,
          loadingSubmitSend: false
        );
      }
    }
  }
  Stream<CreateShipmentState> _mapFetchSurchargeCreateShipmentEventToState(FetchSurchargeCreateShipmentEvent event) async* {
    if (currentState is LoadedCreateShipmentState) {
      try {
        final response = await shipmentRepository.getSurcharge(event.cod, event.amount);
        yield (currentState as LoadedCreateShipmentState).copyWith(surcharges: Surcharge.fromJson(response));
      } on DioError catch (e) {
        yield* handlerDioError(e);
      } catch (error) {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.WARNING,
          message: error.toString())
        );
      }
    }
  }

  Stream<CreateShipmentState> _mapOpenTabCreateShipmentEventToState(OpenTabCreateShipmentEvent event) async* {
    yield (currentState as LoadedCreateShipmentState).copyWith(
      tab: event.tab
    );
  }

  Stream<CreateShipmentState> _mapFetchRateCreateShipmentEventToState(FetchRateCreateShipmentEvent event) async*
  {
    try {
      if ((currentState as LoadedCreateShipmentState).shipment.fromDistrictCode != ''
        && (currentState as LoadedCreateShipmentState).shipment.toDistrictCode != '') {
        List<Rate> rates = await this.shipmentRepository.getRate(
          {
            "from": (currentState as LoadedCreateShipmentState).shipment.fromDistrictCode,
            "to": (currentState as LoadedCreateShipmentState).shipment.toDistrictCode,
            "weight": event.weight,
            "length": event.length,
            "width": event.width,
            "height": event.height,
          }
        );

        // Thay đổi phí dịch vụ khi fetch lại bảng giá mới
        if ((currentState as LoadedCreateShipmentState).shipment.rateId != 0) {
          yield (currentState as LoadedCreateShipmentState).copyWith(
            feeRate:  rates[0].fee,
            rates: rates,
          );
          return;
        }

        yield (currentState as LoadedCreateShipmentState).copyWith(
          rates: rates,
          loadingRate: false
        );
      }
    } on DioError catch (e) {
      yield* handlerDioError(e);
    } catch (error) {
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.ERROR,
        message: error.toString())
      );
    }
  }

  Stream<CreateShipmentState> _mapChangePayerCreateShipmentEventToState(
    String payer) async* {
    Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
    shipment = shipment.copyWith(payer: payer);
    yield (currentState as LoadedCreateShipmentState).copyWith(shipment: shipment);
  }

  Stream<CreateShipmentState> _mapChangePickOnHubCreateShipmentEventToState(bool pickOnHub) async* {
    Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
    shipment = shipment.copyWith(pickOnHub: pickOnHub);
    yield (currentState as LoadedCreateShipmentState).copyWith(shipment: shipment);
  }

  Stream<CreateShipmentState> _mapChangeRateIDCreateShipmentEventToState(ChangeRateIDCreateShipmentEvent event) async* {
    Shipment shipment = (currentState as LoadedCreateShipmentState).shipment;
    shipment = shipment.copyWith(
      rateId: event.rateID,
      selectedRateName: event.rateName
    );
    yield (currentState as LoadedCreateShipmentState).copyWith(shipment: shipment);
  }

  Stream<CreateShipmentState> _mapFetchApplyPromotionCreateShipmentEventToState(
    String code) async* {
     try {
       Map data = {
         "promotion_code": code,
         "amount": 200000,
         "source_code": "app_shop",
         "district_from_code": "11300",
         "district_to_code": "11700"
       };
       final response = await this.shipmentRepository.applyPromotion(data);
       double discount = response.data['data']['discount'];
       notifyBloc.dispatch(ShowNotifyEvent(
         type: NotifyEvent.SUCCESS,
         message: 'Áp dụng mã thành công, giảm ' + discount.toString() + ' đ')
       );
       yield (currentState as LoadedCreateShipmentState).copyWith(
         discount: discount
       );
     } on DioError catch (e) {
       yield* handlerDioError(e);
     } catch (error) {
       print(error);
       print('error----');
     }
  }
}
