import 'dart:async';
import 'package:app_customer/repositories/wallet/wallet_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  WalletState get initialState => InitialWalletState();
  WalletBloc({
    @required this.walletRepository,
    @required this.authenticationBloc,
  })  : assert(walletRepository != null),
        assert(authenticationBloc != null);

  @override
  Stream<WalletState> mapEventToState(
      WalletEvent event,
      ) async* {
    if (event is FetchWalletEvent) {
      yield* _mapFetchWalletEventToState();
    }
  }

  Stream<WalletState> _mapFetchWalletEventToState() async* {
    try {
      yield LoadingWalletState();
      final wallet = await walletRepository.getWallet();
      yield LoadedWalletState(wallet: wallet);
    } on DioError catch (e) {
      yield* processDioError(e);
    } catch (error) {
      yield FailureWalletState(error: error.toString());
    }
  }

  Stream<WalletState> processDioError (e) async* {
    Map response = {};
    Map errors = {};
    String errorMessage = "Không xác định";
    if (e.response == null) {
      yield FailureWalletState(error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
    }
    if (e.response != null) {
      switch (e.response.statusCode) {
        case 401:
          yield FailureWalletState(error: 'Phiên làm việc của bạn đã hết hạn');
          authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
          break;
        case 403:
          yield FailureWalletState(error: 'Bạn không có quyền thực hiện chức năng này');
          break;
        case 404:
          yield FailureWalletState(
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
          yield FailureWalletState(error: errorMessage);
          break;
        case 500:
          yield FailureWalletState(
            error: 'Server gặp sự cố, vui lòng thử lại sau');
          break;
        default:
          yield FailureWalletState(error: e.toString());
          break;
      }
    }
  }
}
