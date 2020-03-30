import 'package:app_customer/repositories/contact_place/contact_place.dart';
import 'package:app_customer/repositories/contact_place/contact_place_filter.dart';
import 'package:app_customer/repositories/pagination/pagination.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ContactPlaceState extends Equatable {
  ContactPlaceState([List props = const []]) : super(props);
}

class InitialContactPlaceState extends ContactPlaceState {
  @override
  String toString() => 'InitialContactPlaceState';
}

class LoadingContactPlaceState extends ContactPlaceState {
  @override
  String toString() => 'LoadingContactPlaceState';
}

class LoadedContactPlaceState extends ContactPlaceState {
  final Pagination pagination;
  final ContactPlace contactPlace;
  final List<ContactPlace> contactPlaces;
  final ContactPlaceFilter contactPlaceFilter;
  final bool isSuccess;
  final bool isFailure;
  final String messageSuccess;
  final String messageFailure;
  final bool showDialog;
  final bool isUpdateReceiver;

  final bool enableSelectWard;
  final bool enableSelectDistrict;
  final String cityName;
  final String districtName;
  final String wardName;

  LoadedContactPlaceState({
    this.pagination,
    this.contactPlace,
    this.contactPlaces,
    this.contactPlaceFilter,
    this.isFailure = false,
    this.isSuccess = false,
    this.messageSuccess = '',
    this.messageFailure = '',
    this.showDialog = false,
    this.isUpdateReceiver = false,

    this.enableSelectWard = false,
    this.enableSelectDistrict = false,
    this.cityName = '',
    this.districtName = '',
    this.wardName = ''
  }) : super([
    pagination,
    contactPlace,
    contactPlaces,
    contactPlaceFilter,
    isFailure,
    isSuccess,
    messageSuccess,
    messageFailure,
    showDialog,
    isUpdateReceiver,

    enableSelectWard,
    enableSelectDistrict,
    cityName,
    districtName,
    wardName
  ]);

  @override
  String toString() => '''LoadedContactPlaceState {
      contact_place: $contactPlace, 
      contact_places: $contactPlaces, 
      contactPlaceFilter: $contactPlaceFilter, 
    }''';

  factory LoadedContactPlaceState.empty() {
    return LoadedContactPlaceState(
      pagination: Pagination.empty(),
      messageSuccess: '',
      messageFailure: '',
      contactPlace: ContactPlace.empty(),
      contactPlaceFilter: ContactPlaceFilter.empty(),
      contactPlaces: [],
      isSuccess: false,
      isFailure: false,
      showDialog: false,

      enableSelectWard: false,
      enableSelectDistrict: false,
    );
  }

  LoadedContactPlaceState copyWith({
    Pagination pagination,
    String messageSuccess,
    String messageFailure,
    ContactPlace contactPlace,
    List<ContactPlace> contactPlaces,
    ContactPlaceFilter contactPlaceFilter,
    bool isSuccess,
    bool isFailure,
    bool showDialog,
    bool isUpdateReceiver,

    bool enableSelectWard,
    bool enableSelectDistrict,
    String cityName,
    String districtName,
    String wardName
  }) {
    return LoadedContactPlaceState(
      pagination: pagination ?? this.pagination,
      messageSuccess: messageSuccess ?? this.messageSuccess,
      messageFailure: messageFailure ?? this.messageFailure,
      contactPlace: contactPlace ?? this.contactPlace,
      contactPlaces: contactPlaces ?? this.contactPlaces,
      contactPlaceFilter: contactPlaceFilter ?? this.contactPlaceFilter,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      showDialog: showDialog ?? this.showDialog,
      isUpdateReceiver: isUpdateReceiver ?? this.isUpdateReceiver,

      enableSelectWard: enableSelectWard ?? this.enableSelectWard,
      enableSelectDistrict: enableSelectDistrict ?? this.enableSelectDistrict,
      cityName: cityName ?? this.cityName,
      districtName: districtName ?? this.districtName,
      wardName: wardName ?? this.wardName
    );
  }
}

class FailureContactPlaceState extends ContactPlaceState {
  final String error;
  FailureContactPlaceState({@required this.error}) : super([error]);

  @override
  String toString() => 'LoadedContactPlaceState {error: $error}';
}
