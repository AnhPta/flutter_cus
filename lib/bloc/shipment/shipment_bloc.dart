import 'dart:async';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/repositories/pagination/pagination.dart';
import 'package:app_customer/repositories/shipment/filter_shipment.dart';
import 'package:app_customer/repositories/shipment/search_shipment.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:app_customer/repositories/shipment/shipment_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  final ShipmentRepository shipmentRepository;
  final AuthenticationBloc authenticationBloc;
  final NotifyBloc notifyBloc;

  @override
  ShipmentState get initialState => InitialShipmentState();
  ShipmentBloc({
    this.shipmentRepository,
    @required this.notifyBloc,
    @required this.authenticationBloc,
  }) :
      assert(notifyBloc != null),
      assert(authenticationBloc != null);

  @override
  Stream<ShipmentState> mapEventToState(
    ShipmentEvent event,
    ) async* {
    if (event is FetchShipmentEvent) {
      yield* _mapFetchShipmentEventToState();
    }
    if (event is FetchDraftShipmentEvent) {
      yield* _mapFetchDraftShipmentEventToState();
    }
    if (event is SetLoadedShipmentEvent) {
      yield* _mapSetLoadedShipmentEventToState();
    }
    if (event is RefreshShipmentEvent) {
      yield* _mapRefreshShipmentEventToState();
    }
    if (event is LoadMoreShipmentEvent) {
      yield* _mapLoadMoreShipmentEventToState(event);
    }
    if (event is UpdateFilterStatusEvent) {
      yield* _mapUpdateFilterStatusEventToState(event);
    }
    if (event is UpdateFilterCityPopEvent) {
      yield* _mapUpdateFilterCityPopEventToState(event);
    }
    if (event is UpdateFilterCityPickEvent) {
      yield* _mapUpdateFilterCityPickEventToState(event);
    }
    if (event is UpdateFilterCreateDateEvent) {
      yield* _mapUpdateFilterCreateDateEventToState(event);
    }
    if (event is UpdateFilterDateRangerEvent) {
      yield* _mapUpdateFilterDateRangerEventToState(event);
    }
    if (event is ClearFilterShipmentEvent) {
      yield* _mapClearFilterShipmentEventToState();
    }
    if (event is ApplyFilterShipmentEvent) {
      yield* _mapApplyFilterShipmentEventToState(event);
    }
    if (event is SearchShipmentEvent) {
      yield* _mapSearchShipmentEventToState(event);
    }
    if (event is SendShipmentEvent) {
      yield* _mapSendShipmentEventToState(event);
    }
    if (event is DeleteShipmentEvent) {
      yield* _mapDeleteShipmentEventToState(event);
    }
    if (event is SendRequestCancelShipmentEvent) {
      yield* _mapSendRequestCancelShipmentEventToState(event);
    }
  }

  Stream<ShipmentState> _mapSetLoadedShipmentEventToState() async* {
    yield LoadedShipmentState.empty();
  }

  Stream<ShipmentState> _mapFetchShipmentEventToState() async* {
    try {
      if (currentState is LoadedShipmentState &&
        (currentState as LoadedShipmentState).shipments.length > 0) {
        return;
      }
      yield LoadingShipmentState();
      final response = await shipmentRepository.getShipment(
        { 'page': 1, "ignore_statuses[]": "draft"});
      yield LoadedShipmentState.empty().copyWith(
        isFetched: true,
        shipments: response['data'],
        pagination: response['pagination'],
      );
    } on DioError catch (e) {
      yield* processDioError(e);
    } catch (error) {
      yield FailureShipmentState(error: error.toString());
    }
  }

  Stream<ShipmentState> _mapFetchDraftShipmentEventToState() async* {
    try {
//      yield LoadingShipmentState();
      final response = await shipmentRepository.getShipment(
        { 'page': 1});
      yield LoadedShipmentState.empty().copyWith(
        shipments: response['data'],
        isFetchDraft: true,
        pagination: response['pagination'],
      );
    } on DioError catch (e) {
      yield* processDioError(e);
    } catch (error) {
      yield FailureShipmentState(error: error.toString());
    }
  }

  Stream<ShipmentState> _mapSearchShipmentEventToState(SearchShipmentEvent event) async* {
    try {
      if (currentState is LoadedShipmentState) {
        SearchShipment searchShipment = (currentState as LoadedShipmentState).searchShipment ;
        if (event.q == '') {
          searchShipment = searchShipment.copyWith(q: event.q, page: 1, ignoreDraft: 'draft');
        } else {
          searchShipment = searchShipment.copyWith(q: event.q, page: 1, ignoreDraft: '');
        }
        final response = await shipmentRepository.getShipment(
          searchShipment.toJson());
        yield (currentState as LoadedShipmentState).copyWith(
          shipments: response['data'],
            searchShipment: searchShipment,
          pagination: response['pagination'],
        );
      }
    } on DioError catch (e) {
      yield* processDioError(e);
    } catch (error) {
      yield FailureShipmentState(error: error.toString());
    }
  }

  Stream<ShipmentState> _mapDeleteShipmentEventToState(DeleteShipmentEvent event) async* {
    try {
      if (currentState is LoadedShipmentState) {
        await shipmentRepository.deleteShipment(event.codeShipment);
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.SUCCESS,
          message: 'Hủy vận đơn thành công')
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


  Stream<ShipmentState> _mapSendRequestCancelShipmentEventToState(SendRequestCancelShipmentEvent event) async* {
    try {
      if (currentState is LoadedShipmentState) {
        await shipmentRepository.sendRequestCancelShipment(event.codeShipment, event.codeReason, event.reasonTxt);
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.SUCCESS,
          message: 'Gửi yêu cầu hủy thành công')
        );
      }
    }on DioError catch (e) {
      yield* handlerDioError(e);
    } catch (error) {
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.ERROR,
        message: error.toString())
      );
    }
  }

  Stream<ShipmentState> _mapSendShipmentEventToState(SendShipmentEvent event) async* {
    if (currentState is LoadedShipmentState) {
      try {
        await shipmentRepository.sendShipment(event.codeShipment);
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.SUCCESS,
          message: 'Gửi vận đơn thành công')
        );
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

  Stream<ShipmentState> _mapLoadMoreShipmentEventToState(LoadMoreShipmentEvent event) async* {
    if (event is LoadMoreShipmentEvent) {
      try {
        if (currentState is LoadedShipmentState) {
          FilterShipment filterShipment = (currentState as LoadedShipmentState).filterShipment;
          Pagination pagination = (currentState as LoadedShipmentState).pagination;
          List<Shipment> shipments = (currentState as LoadedShipmentState).shipments;
          if (pagination.currentPage < pagination.totalPages) {
            filterShipment = filterShipment.copyWith(page: pagination.currentPage + 1);
            final response = await shipmentRepository.getShipment(filterShipment.toJson());
            if (response['data'].isNotEmpty) {
              shipments = shipments + response['data'];
              pagination = response['pagination'];
            }
            yield (currentState as LoadedShipmentState).copyWith(
              shipments: shipments,
              pagination: pagination,
              filterShipment: filterShipment
            );
          }
        }
      } on DioError catch (e) {
        yield* processDioError(e);
      } catch (error) {
        yield FailureShipmentState(error: error.toString());
      }
    }
  }

  Stream<ShipmentState> _mapRefreshShipmentEventToState() async* {
    try {
      yield LoadingShipmentState();
      final response = await shipmentRepository.getShipment({ 'page': 1 , "ignore_statuses[]": "draft"});
      yield LoadedShipmentState.empty().copyWith(
        isFetchFilter: false,
        shipments: response['data'],
        isFetchDraft: false,
        pagination: response['pagination'],
      );
    } on DioError catch (e) {
      yield* processDioError(e);
    } catch (error) {
      yield FailureShipmentState(error: error.toString());
    }
  }

  Stream<ShipmentState> _mapUpdateFilterStatusEventToState(UpdateFilterStatusEvent event) async* {
    if (currentState is LoadedShipmentState) {
      FilterShipment filterShipment = (currentState as LoadedShipmentState).filterShipment;
      filterShipment = filterShipment.copyWith(status: event.status, statusTxt: event.statusTxt, ignoreDraft: '');

      yield (currentState as LoadedShipmentState).copyWith(
        selectStatus: true,
        filterShipment: filterShipment,
      );
    }
  }

  Stream<ShipmentState> _mapUpdateFilterCityPopEventToState(UpdateFilterCityPopEvent event) async* {
    if (currentState is LoadedShipmentState) {
      FilterShipment filterShipment = (currentState as LoadedShipmentState).filterShipment;
      filterShipment = filterShipment.copyWith(cityPopName: event.cityPopName, cityPopCode: event.cityPopCode, ignoreDraft: '');

      yield (currentState as LoadedShipmentState).copyWith(
        selectCityPop: true,
        filterShipment: filterShipment,
      );
    }
  }

  Stream<ShipmentState> _mapUpdateFilterCityPickEventToState(UpdateFilterCityPickEvent event) async* {
    if (currentState is LoadedShipmentState) {
      FilterShipment filterShipment = (currentState as LoadedShipmentState).filterShipment;
      filterShipment = filterShipment.copyWith(cityPickCode: event.cityPickCode, cityPickName: event.cityPickName, ignoreDraft: '');

      yield (currentState as LoadedShipmentState).copyWith(
        selectCityPick: true,
        filterShipment: filterShipment,
      );
    }
  }

  Stream<ShipmentState> _mapUpdateFilterCreateDateEventToState(UpdateFilterCreateDateEvent event) async* {
    if (currentState is LoadedShipmentState) {
      FilterShipment filterShipment = (currentState as LoadedShipmentState).filterShipment;
      filterShipment = filterShipment.copyWith(createDate: event.createDate, ignoreDraft: '');

      yield (currentState as LoadedShipmentState).copyWith(
        selectCreateDate: true,
        filterShipment: filterShipment,
      );
    }
  }

  Stream<ShipmentState> _mapUpdateFilterDateRangerEventToState(UpdateFilterDateRangerEvent event) async* {
    if (currentState is LoadedShipmentState) {
      FilterShipment filterShipment = (currentState as LoadedShipmentState).filterShipment;
      filterShipment = filterShipment.copyWith(dateRanger: event.dateRanger, ignoreDraft: '', dateRangerTxt: event.dateRangerTxt);

      yield (currentState as LoadedShipmentState).copyWith(
        selectDateRanger: true,
        filterShipment: filterShipment,
      );
    }
  }

  Stream<ShipmentState> _mapClearFilterShipmentEventToState() async* {
    if (currentState is LoadedShipmentState) {
      FilterShipment filterShipment = (currentState as LoadedShipmentState).filterShipment;
      filterShipment = filterShipment.copyWith(
        ignoreDraft: 'draft',
        cityPickCode: '',
        cityPopCode: '',
        createDate: '',
        dateRanger: '',
        dateRangerTxt: '',
        status: '',
        cityPopName: '',
        statusTxt: '',
        cityPickName: '',
        );

      yield (currentState as LoadedShipmentState).copyWith(
        isFetchFilter: false,
        selectDelete: true,
        filterShipment: filterShipment,
      );
    }
  }

  Stream<ShipmentState> _mapApplyFilterShipmentEventToState(ApplyFilterShipmentEvent event) async* {
    try {
      FilterShipment filterShipment = (currentState as LoadedShipmentState).filterShipment;
      filterShipment.copyWith(page: 1);
      yield (currentState as LoadedShipmentState).copyWith(
        isLoadingFilter: true
      );
      final response = await shipmentRepository.getShipment(
        filterShipment.toJson());
      yield (currentState as LoadedShipmentState).copyWith(
        isFetchFilter: true,
        isLoadingFilter: false,
        countFilter: event.countFilter,
        shipments: response['data'],
        pagination: response['pagination'],
      );
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 401) {
        authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
      }
      yield FailureShipmentState(error: e.toString());
    } catch (error) {
      yield FailureShipmentState(error: error.toString());
    }
  }

  Stream<ShipmentState> processDioError (e) async* {
    Map response = {};
    Map errors = {};
    String errorMessage = "Không xác định";
    if (e.response == null) {
      yield FailureShipmentState(error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
    }
    if (e.response != null) {
      switch (e.response.statusCode) {
        case 401:
          yield FailureShipmentState(error: 'Phiên làm việc của bạn đã hết hạn');
          authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
          break;
        case 404:
          yield FailureShipmentState(
            error: 'Tính năng đang hoàn thiện, vui lòng chờ phiên bản sau');
          break;
        case 422:
          response = e.response.data;
          if (response.containsKey('data') &&
            response['data'] is Map &&
            response['data'].containsKey('errors')) {
            errors = response['data']['errors'];
            errorMessage = errors.values.first[0];
          } else {
            errorMessage = response['message'];
          }
          yield FailureShipmentState(error: errorMessage);
          break;
        case 500:
          yield FailureShipmentState(
            error: 'Server gặp sự cố, vui lòng thử lại sau');
          break;
        default:
          yield FailureShipmentState(error: e.toString());
          break;
      }
    }
  }

  Stream<ShipmentState> handlerDioError (e) async* {
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
