import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:app_customer/repositories/source/source_repository.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';

class SourceBloc extends Bloc<SourceEvent, SourceState> {
  final AuthenticationBloc authenticationBloc;
  final SourceRepository sourceRepository;

  SourceBloc({@required this.authenticationBloc,
    @required this.sourceRepository})
    : assert(authenticationBloc != null),
      assert(sourceRepository != null);

  @override
  SourceState get initialState => InitialSourceState();

  @override
  Stream<SourceState> mapEventToState(
    SourceEvent event,
  ) async* {
    if (event is FetchSourceEvent) {
      yield* _mapFetchSourceEventToState();
    }
  }

  Stream<SourceState> _mapFetchSourceEventToState() async* {
    if (currentState is InitialSourceState) {
      yield LoadingSourceState();
    }
    try {
      final sources =
      await sourceRepository.getSources();
      yield LoadedSourceState(sources: sources);
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 401) {
        authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
      } else {
        yield FailureSourceState(error: e.toString());
      }
    } catch (error) {
      yield FailureSourceState(error: error.toString());
    }
  }
}
