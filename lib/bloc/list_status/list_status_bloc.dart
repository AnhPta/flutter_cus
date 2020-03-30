import 'dart:async';
import 'package:app_customer/repositories/list_status/list_status_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';

class ListStatusBloc extends Bloc<ListStatusEvent, ListStatusState> {
  final ListStatusRepository listStatusRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  ListStatusState get initialState => InitialListStatusState();
  ListStatusBloc({
    this.listStatusRepository,
    @required this.authenticationBloc,
  })  :
      assert(authenticationBloc != null);

  @override
  Stream<ListStatusState> mapEventToState(
    ListStatusEvent event,
    ) async* {
    if (event is FetchListStatusEvent) {
      yield* _mapFetchListStatusEventToState();
    }
    if (event is DisplayIconListStatusEvent) {
      yield* _mapDisplayIconListStatusEventToState(event);
    }
  }

  Stream<ListStatusState> _mapFetchListStatusEventToState() async* {
    try {
      if (currentState is LoadedListStatusState && (currentState as LoadedListStatusState).listStatus.length > 0) {
        return;
      }
      yield LoadingListStatusState();
      final listStatus = await listStatusRepository.getListStatus();
      yield LoadedListStatusState(listStatus: listStatus);
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 401) {
        authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
      }
      yield FailureListStatusState(error: e.toString());
    } catch (error) {
      yield FailureListStatusState(error: error.toString());
    }
  }

  Stream<ListStatusState> _mapDisplayIconListStatusEventToState(DisplayIconListStatusEvent event) async* {
      yield (currentState as LoadedListStatusState).copyWith(
        showIcon: event.isShowIcon,
        status: event.status
      );
  }
}
