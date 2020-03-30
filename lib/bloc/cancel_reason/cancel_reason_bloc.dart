import 'dart:async';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/repositories/cancel_reason/cancel_reason_repository.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

class CancelReasonBloc extends Bloc<CancelReasonEvent, CancelReasonState> {
  final CancelReasonRepository cancelReasonRepository;
  final AuthenticationBloc authenticationBloc;
  final NotifyBloc notifyBloc;

  @override
  CancelReasonState get initialState => InitialCancelReasonState();

  CancelReasonBloc({
    @required this.authenticationBloc,
    this.notifyBloc,
    this.cancelReasonRepository,
  })  :
      assert(authenticationBloc != null);

  @override
  Stream<CancelReasonState> mapEventToState(
    CancelReasonEvent event,
    ) async* {
    if (event is FetchCancelReasonEvent) {
      yield* _mapFetchCancelReasonEventToState();
    }
    if (event is SetLoadedReasonEvent) {
      yield* _mapSetLoadedReasonEventToState();
    }
  }

  Stream<CancelReasonState> _mapSetLoadedReasonEventToState() async* {
    yield LoadedCancelReasonState.empty();
  }

  Stream<CancelReasonState> _mapFetchCancelReasonEventToState() async* {
    try {
      if (currentState is LoadedCancelReasonState && (currentState as LoadedCancelReasonState).reason.length > 0) {
        yield LoadedCancelReasonState(reason: (currentState as LoadedCancelReasonState).reason);
        return;
      }
      final reason = await cancelReasonRepository.getReason();
      yield LoadedCancelReasonState(reason: reason);
    } on DioError catch (e) {
      handlerDioError(e);
      yield FailureCancelReasonState(error: e.toString());
    } catch (error) {
      yield FailureCancelReasonState(error: error.toString());
    }
  }

  Stream<CancelReasonState> handlerDioError (e) async* {
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
