import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  int currentIndex = 0;
  @override
  NavigationState get initialState => HomeNavigationState();

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is ChangeIndexPageEvent) {
      this.currentIndex = event.index;
      yield InitialNavigationState(currentIndex: this.currentIndex);

      if (this.currentIndex == 0) {
        yield HomeNavigationState();
      }
      if (this.currentIndex == 1) {
        yield ShipmentNavigationState(loadedShipmentState: event.loadedShipmentState);
      }
      if (this.currentIndex == 2) {
        yield ProfileNavigationState();
      }
      if (this.currentIndex == 3) {
        yield StatisticalNavigationState();
      }
    }

    if (event is HomeNavigationEvent) {
      yield HomeNavigationState();
    }

    if (event is ShipmentNavigationState) {
      yield ShipmentNavigationState();
    }

    if (event is StatisticalNavigationState) {
      yield StatisticalNavigationState();
    }

    if (event is ProfileNavigationEvent) {
      yield ProfileNavigationState();
    }

    if (event is CounterNavigationEvent) {
      yield CounterNavigationState();
    }

    if (event is NotifyNavigationEvent) {
      yield NotifyNavigationState();
    }

    if (event is PackNavigationEvent) {
      yield PackNavigationState();
    }

    if (event is DetailShipmentNavigationEvent) {
      yield DetailShipmentNavigationState(eventBack: event.eventBack);
    }

    if (event is RegistryNavigationEvent) {
      yield RegistryNavigationState();
    }

    if (event is CreateShipmentNavigationEvent) {
      yield CreateShipmentNavigationState(shipment: event.shipment, type: event.type, redirectDetail: event.redirectDetail);
    }

    if (event is ContactPlaceNavigationEvent) {
      yield ContactPlaceNavigationState();
    }
    if (event is ChangePassNavigationEvent) {
      yield ChangePassNavigationState();
    }
  }
}
