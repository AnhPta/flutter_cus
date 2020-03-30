import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ContactPlaceEvent extends Equatable {
  ContactPlaceEvent([List props = const []]) : super(props);
}

class SetLoadedContactPlaceEvent extends ContactPlaceEvent {
  @override
  String toString() {
    return 'SetLoadedContactPlaceEvent';
  }
}

class ClearStateCreateContactPlaceEvent extends ContactPlaceEvent {
  @override
  String toString() {
    return 'ClearStateCreateContactPlaceEvent';
  }
}

class UpdateCityContactPlaceEvent extends ContactPlaceEvent {
  final String selectedCityCode;
  final String selectedCityName;
  final bool enableSelectDistrict;

  UpdateCityContactPlaceEvent({
      this.selectedCityCode,
      this.selectedCityName,
      this.enableSelectDistrict,
    }) : super([
    selectedCityCode,
    selectedCityName,
    enableSelectDistrict,
    ]);

  @override
  String toString() {
    return '''UpdateCityContactPlaceEvent {
      code: $selectedCityCode,
      name: $selectedCityName,
      enableSelectDistrict: $enableSelectDistrict,
    }''';
  }
}

class RefreshContactPlaceEvent extends ContactPlaceEvent {
  @override
  String toString() {
    return 'RefreshContactPlaceEvent';
  }
}

class LoadMoreContactPlaceEvent extends ContactPlaceEvent {
  @override
  String toString() => 'LoadMoreContactPlaceEvent';
}

class UpdateDistrictContactPlaceEvent extends ContactPlaceEvent {
  final String selectedDistrictCode;
  final String selectedDistrictName;
  final bool enableSelectWard;

  UpdateDistrictContactPlaceEvent({
      this.selectedDistrictCode,
      this.selectedDistrictName,
      this.enableSelectWard,
    }) : super([
    selectedDistrictCode,
    selectedDistrictName,
    enableSelectWard,
    ]);

  @override
  String toString() {
    return '''UpdateDistrictContactPlaceEvent {
      name: $selectedDistrictName,
      code: $selectedDistrictCode,
      enableSelectWard: $enableSelectWard,
    }''';
  }
}

class UpdateWardContactPlaceEvent extends ContactPlaceEvent {
  final String selectedWardCode;
  final String selectedWardName;

  UpdateWardContactPlaceEvent({
      this.selectedWardCode,
      this.selectedWardName
    }) : super([
    selectedWardCode,
    selectedWardName
    ]);

  @override
  String toString() {
    return '''UpdateWardContactPlaceEvent {
      name: $selectedWardName,
      code: $selectedWardCode,
    }''';
  }
}

class CreateContactPlaceEvent extends ContactPlaceEvent {
  final String name;
  final String phone;
  final String address;
  final bool isMain;

  CreateContactPlaceEvent({
    this.name,
    this.phone,
    this.address,
    this.isMain,
  }) : super([
    name,
    phone,
    address,
    isMain,
  ]);

  @override
  String toString() {
    return '''CreateContactPlaceEvent: { 
      name: $name, 
      phone: $phone, 
      address: $address, 
      isMain: $isMain, 
    }''';
  }
}

class UpdateContactPlaceEvent extends ContactPlaceEvent {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String cityCode;
  final String districtCode;
  final String wardCode;
  final bool isMain;
  final bool isActive;

  UpdateContactPlaceEvent({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.cityCode,
    this.districtCode,
    this.wardCode,
    this.isMain,
    this.isActive,
  }) : super([
    id,
    name,
    phone,
    address,
    cityCode,
    districtCode,
    wardCode,
    isMain,
    isActive,
  ]);

  @override
  String toString() {
    return '''UpdateContactPlaceEvent: { 
      id: $id, 
      name: $name, 
      phone: $phone, 
      address: $address, 
      cityCode: $cityCode, 
      districtCode: $districtCode, 
      wardCode: $wardCode,
      isMain: $isMain, 
      isActive: $isActive, 
    }''';
  }
}

class FetchContactPlaceEvent extends ContactPlaceEvent {
  @override
  String toString() {
    return 'FetchContactPlaceEvent';
  }
}

class FilterContactPlaceEvent extends ContactPlaceEvent {
  final String q;

  FilterContactPlaceEvent({
    this.q,
  }) :
    super([
      q,
    ]);

  @override
  String toString() => 'FilterContactPlaceEvent { q: $q }';
}

class UpdateFormContactPlaceEvent extends ContactPlaceEvent {
  final String name;
  final String phone;
  final String address;
  final String cityCode;
  final String districtCode;
  final String wardCode;
  final String cityName;
  final String districtName;
  final String wardName;
  final bool isMain;

  UpdateFormContactPlaceEvent({
    this.name,
    this.phone,
    this.address,
    this.cityCode,
    this.districtCode,
    this.wardCode,
    this.cityName,
    this.districtName,
    this.wardName,
    this.isMain,
  }) :
      super([

      name,
      phone,
      address,
      cityCode,
      districtCode,
      wardCode,
      cityName,
      districtName,
      wardName,
      isMain,
    ]);

  @override
  String toString() {
    return '''UpdateFormContactPlaceEvent {
      name: $name,
      phone: $phone,
      address: $address,
      cityCode: $cityCode,
      districtCode: $districtCode,
      wardCode: $wardCode,
      cityName: $cityName,
      districtName: $districtName,
      wardName: $wardName,
      isMain: $isMain,
    }''';
  }
}
