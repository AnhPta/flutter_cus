import 'package:bloc/bloc.dart';
import './bloc.dart';

class NotifyBloc extends Bloc<NotifyEvent, NotifyState> {
  @override
  NotifyState get initialState => InitialNotifyState();

  @override
  Stream<NotifyState> mapEventToState(NotifyEvent event,) async* {
    if (event is ShowNotifyEvent) {
      switch (event.type) {
        case NotifyEvent.SUCCESS:
          yield SuccessNotifyState(message: event.message);
          break;
        case NotifyEvent.ERROR:
          yield ErrorNotifyState(message: event.message);
          break;
        case NotifyEvent.WARNING:
          yield WarningNotifyState(message: event.message);
          break;
        case NotifyEvent.INFO:
          yield InfoNotifyState(message: event.message);
          break;
      }
      yield InitialNotifyState();
    }

    if (event is LoadingNotifyEvent) {
      yield LoadingNotifyState(isLoading: event.isLoading);
      if (!event.isLoading) {
        yield InitialNotifyState();
      }
    }
  }
}
