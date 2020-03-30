import 'package:app_customer/bloc/shipment/bloc.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NavigationEvent extends Equatable {
  NavigationEvent([List props = const <dynamic>[]]) : super(props);
}

class ChangeIndexPageEvent extends NavigationEvent {
  final int index;
  final LoadedShipmentState loadedShipmentState;

  ChangeIndexPageEvent({
    @required this.index,
    this.loadedShipmentState
  }) : super([
    index,
    loadedShipmentState
  ]);

  @override
  String toString() => 'ChangeIndexPageEvent: $index';
}

//auth page
class HomeNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'HomeNavigationEvent';
  }
}
// Profile page
class ProfileNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'ProfileNavigationState';
  }
}
class StatisticalNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'StatisticalNavigationState';
  }
}
class ShipmentNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'ShipmentNavigationEvent';
  }
}

class CounterNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'CounterNavigationEvent';
  }
}

class NotifyNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'NotifyNavigationEvent';
  }
}

class PackNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'PackNavigationEvent';
  }
}

//guest page
class LoginNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'LoginNavigationEvent';
  }
}
// demo detail page
class DetailShipmentNavigationEvent extends NavigationEvent {
  final NavigationEvent eventBack;

  DetailShipmentNavigationEvent({
     this.eventBack
  }) : super([eventBack]);

  @override
  String toString() {
    return 'DetailShipmentNavigationEvent';
  }
}

// trang dang ki
class RegistryNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'RegistryNavigationEvent';
  }
}

// Create Shipment
class CreateShipmentNavigationEvent extends NavigationEvent {
  final Shipment shipment;
  final String type;
  final bool redirectDetail;

  CreateShipmentNavigationEvent({
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
    return 'CreateShipmentNavigationEvent';
  }
}

//Diem nhan / gui
class ContactPlaceNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'ContactPlaceNavigationEvent';
  }
}

//Thay doi mat khau
class ChangePassNavigationEvent extends NavigationEvent {
  @override
  String toString() {
    return 'ChangePassNavigationEvent';
  }
}
