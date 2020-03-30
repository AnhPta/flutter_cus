import 'package:app_customer/bloc/navigation/navigation_event.dart';
import 'package:app_customer/bloc/shipment/bloc.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NavigationState extends Equatable {
  NavigationState([List props = const <dynamic>[]]) : super(props);
}
class InitialNavigationState extends NavigationState {
  final int currentIndex;

  InitialNavigationState({@required this.currentIndex}) : super([currentIndex]);

  @override
  String toString() => 'InitialNavigationState to $currentIndex';
}
class HomeNavigationState extends NavigationState {
  final int itemIndex = 0;
  @override
  String toString() => 'HomeNavigationState';
}
class ShipmentNavigationState extends NavigationState {
  final LoadedShipmentState loadedShipmentState;

  ShipmentNavigationState({this.loadedShipmentState}) : super([loadedShipmentState]);

  @override
  String toString() => 'ShipmentNavigationState';
}
class ProfileNavigationState extends NavigationState {
  @override
  String toString() => 'ProfileNavigationState';
}

class StatisticalNavigationState extends NavigationState {
  @override
  String toString() {
    return 'StatisticalNavigationState';
  }
}
class CounterNavigationState extends NavigationState {
  @override
  String toString() {
    return 'CounterNavigationState';
  }
}
class NotifyNavigationState extends NavigationState {
  @override
  String toString() {
    return 'NotifyNavigationState';
  }
}
class PackNavigationState extends NavigationState {
  @override
  String toString() {
    return 'PackNavigationState';
  }
}
class F2PackNavigationState extends NavigationState {
  @override
  String toString() {
    return 'F2PackNavigationState';
  }
}
// guest page
class LoginNavigationState extends NavigationState {
  @override
  String toString() {
    return 'LoginNavigationState';
  }
}
// Profile page
//class ProfileNavigationState extends NavigationState {
//  @override
//  String toString() {
//    return 'ProfileNavigationState';
//  }
//}
// Profile page
class DetailShipmentNavigationState extends NavigationState {
  final NavigationEvent eventBack;

  DetailShipmentNavigationState({this.eventBack}) : super([eventBack]);

  @override
  String toString() {
    return 'DetailShimentNavigationState';
  }
}
class RegistryNavigationState extends NavigationState {
  @override
  String toString() {
    return 'RegistryNavigationState';
  }
}
class CreateShipmentNavigationState extends NavigationState {
  final Shipment shipment;
  final String type;
  final bool redirectDetail;

  CreateShipmentNavigationState({
    this.shipment,
    this.type,
    this.redirectDetail,
  }) : super([
    shipment,
    type,
    redirectDetail,
  ]);

  @override
  String toString() {
    return 'CreateShipmentNavigationState';
  }
}
class ContactPlaceNavigationState extends NavigationState {
  @override
  String toString() {
    return 'ContactPlaceNavigationState';
  }
}
class ChangePassNavigationState extends NavigationState {
  @override
  String toString() {
    return 'ChangePassNavigationState';
  }
}
