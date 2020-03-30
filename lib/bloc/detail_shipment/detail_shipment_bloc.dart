import 'dart:async';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/repositories/detail_shipment/detail_shipment.dart';
import 'package:app_customer/repositories/detail_shipment/detail_shipment_repository.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

class DetailShipmentBloc extends Bloc<DetailShipmentEvent, DetailShipmentState> {
  final DetailShipmentRepository detailShipmentRepository;
  final AuthenticationBloc authenticationBloc;
  final NotifyBloc notifyBloc;

  @override
  DetailShipmentState get initialState => InitialDetailShipmentState();

  DetailShipmentBloc({
    @required this.authenticationBloc,
     this.notifyBloc,
    this.detailShipmentRepository,
  })  :
      assert(authenticationBloc != null);

  @override
  Stream<DetailShipmentState> mapEventToState(
    DetailShipmentEvent event,
    ) async* {
    if (event is FetchDetailShipmentEvent) {
      yield* _mapLoadedDetailShipmentEventToState(event);
    }
    if (event is SetLoadedDetailShipmentEvent) {
      yield* _mapSetLoadedDetailShipmentEventToState();
    }
  }

  Stream<DetailShipmentState> _mapSetLoadedDetailShipmentEventToState() async* {
    yield LoadedDetailShipmentState.empty();
  }
  Stream<DetailShipmentState> _mapLoadedDetailShipmentEventToState(FetchDetailShipmentEvent event) async* {
    try {
      yield LoadingDetailShipmentState();
      (currentState as LoadedDetailShipmentState).copyWith(codeShipmentSelected: event.codeShipment);
      final response = await detailShipmentRepository.getDetailShipment(event.codeShipment);
      DetailShipment detailShipment = DetailShipment.fromJson(response.data['data']);
      Shipment shipment = Shipment.fromJson(response.data['data']);
      yield LoadedDetailShipmentState.empty().copyWith(
        detailShipment: detailShipment,
        shipment: shipment
      );
    } on DioError catch (e) {
      handlerDioError(e);
      yield FailureDetailShipmentState(error: e.toString());
    } catch (error) {
      yield FailureDetailShipmentState(error: error.toString());
    }
  }

  Stream<DetailShipmentState> handlerDioError (e) async* {
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
        print(e.response.data);
        switch (e.response.statusCode) {
          case 401:
            authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
            notifyBloc.dispatch(ShowNotifyEvent(
              type: NotifyEvent.ERROR,
              message: 'Phiên làm việc của bạn đã hết hạn')
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
}
