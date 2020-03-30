import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ShipmentEvent extends Equatable {
  ShipmentEvent([List props = const []]) : super(props);
}

class FetchShipmentEvent extends ShipmentEvent {
  final bool isFetched;

  FetchShipmentEvent({
    this.isFetched
  }) : super([isFetched]);

  @override
  String toString() {
    return 'FetchShipmentEvent';
  }
}

class FetchDraftShipmentEvent extends ShipmentEvent {
  @override
  String toString() {
    return 'FetchDraftShipmentEvent';
  }
}

class SetLoadedShipmentEvent extends ShipmentEvent {
  @override
  String toString() {
    return 'SetLoadedShipmentEvent';
  }
}

class RefreshShipmentEvent extends ShipmentEvent {
  @override
  String toString() {
    return 'RefreshShipmentEvent';
  }
}

class LoadMoreShipmentEvent extends ShipmentEvent {
  @override
  String toString() => 'LoadMoreShipmentEvent';
}

class UpdateFilterStatusEvent extends ShipmentEvent {
  final bool selectStatus;
  final bool selectCityPop;
  final bool selectCityPick;
  final bool selectCreateDate;
  final bool selectDateRanger;
  final String status;
  final String statusTxt;
  final String cityPopName;
  final String cityPopCode;
  final String cityPickName;
  final String cityPickCode;

  UpdateFilterStatusEvent({
    this.selectStatus,
    this.selectCityPop,
    this.selectCityPick,
    this.selectCreateDate,
    this.selectDateRanger,
    this.status,
    this.statusTxt,
    this.cityPopCode,
    this.cityPopName,
    this.cityPickCode,
    this.cityPickName,
  }) : super([
    selectStatus,
    selectCityPop,
    selectCityPick,
    selectCreateDate,
    selectDateRanger,
    status,
    statusTxt,
    cityPickName,
    cityPickCode,
    cityPopName,
    cityPopCode,
  ]);

  @override
  String toString() {
    return '''UpdateFilterStatusEvent {
      selectStatus: $selectStatus,
      selectCityPick: $selectCityPick,
      selectCityPop: $selectCityPop,
      selectCreateDate: $selectCreateDate,
      selectDateRanger: $selectDateRanger,
      status: $status,
      statusTxt: $statusTxt,
      cityPopCode: $cityPopCode,
      cityPopName: $cityPopName,
      cityPickCode: $cityPickCode,
      cityPickName: $cityPickName,
    }''';
  }
}
class UpdateFilterCityPopEvent extends ShipmentEvent {
  final bool selectCityPop;
  final String cityPopName;
  final String cityPopCode;

  UpdateFilterCityPopEvent({
    this.selectCityPop,
    this.cityPopCode,
    this.cityPopName,
  }) : super([
    selectCityPop,
    cityPopName,
    cityPopCode,
  ]);

  @override
  String toString() {
    return '''UpdateFilterCityPopEvent {
      selectCityPop: $selectCityPop,
      cityPopCode: $cityPopCode,
      cityPopName: $cityPopName,
    }''';
  }
}
class UpdateFilterCityPickEvent extends ShipmentEvent {
  final bool selectCityPick;
  final String cityPickName;
  final String cityPickCode;

  UpdateFilterCityPickEvent({
    this.selectCityPick,
    this.cityPickCode,
    this.cityPickName,
  }) : super([
    cityPickName,
    cityPickCode,
    selectCityPick
  ]);

  @override
  String toString() {
    return '''UpdateFilterCityPickEvent {
      selectCityPick: $selectCityPick,
      cityPickCode: $cityPickCode,
      cityPickName: $cityPickName,
    }''';
  }
}
class UpdateFilterCreateDateEvent extends ShipmentEvent {
  final bool selectCreateDate;
  final String createDate;

  UpdateFilterCreateDateEvent({
    this.selectCreateDate,
    this.createDate,
  }) : super([
    createDate,
    selectCreateDate
  ]);

  @override
  String toString() {
    return '''UpdateFilterCreateDateEvent {
      selectCreateDate: $selectCreateDate,
      createDate: $createDate,
    }''';
  }
}
class UpdateFilterDateRangerEvent extends ShipmentEvent {
  final bool selectDateRanger;
  final String dateRanger;
  final String dateRangerTxt;

  UpdateFilterDateRangerEvent({
    this.selectDateRanger,
    this.dateRanger,
    this.dateRangerTxt,
  }) : super([
    dateRanger,
    dateRangerTxt,
    selectDateRanger
  ]);

  @override
  String toString() {
    return '''UpdateFilterDateRangerEvent {
      selectDateRanger: $selectDateRanger,
      dateRanger: $dateRanger,
      dateRangerTxt: $dateRangerTxt,
    }''';
  }
}
class ClearFilterShipmentEvent extends ShipmentEvent {
  final bool selectDelete;
  final String dateRanger;
  final String createDate;
  final String status;
  final String cityPopCode;
  final String cityPickCode;

  ClearFilterShipmentEvent({
    this.selectDelete,
    this.dateRanger,
    this.createDate,
    this.status,
    this.cityPopCode,
    this.cityPickCode,
  }) : super([
    dateRanger,
    createDate,
    status,
    cityPopCode,
    cityPickCode,
    selectDelete
  ]);

  @override
  String toString() {
    return '''ClearFilterShipmentEvent {
      selectDelete: $selectDelete,
      dateRanger: $dateRanger,
      createDate: $createDate,
      cityPickCode: $cityPickCode,
      cityPopCode: $cityPopCode,
      status: $status,
    }''';
  }
}

class ApplyFilterShipmentEvent extends ShipmentEvent {
  final String status;
  final String countFilter;
  ApplyFilterShipmentEvent({
    this.status,
    this.countFilter,
  }) : super([
    status, countFilter
  ]);
  @override
  String toString() {
    return '''ApplyFilterShipmentEvent {
      status: $status,
      countFilter: $countFilter,
    }''';
  }
}

class SearchShipmentEvent extends ShipmentEvent {
  final String q;

  SearchShipmentEvent({
    this.q,
  }) :
      super([
      q,
    ]);

  @override
  String toString() => 'SearchShipmentEvent { q: $q }';
}

class SendShipmentEvent extends ShipmentEvent {
  final String codeShipment;
  SendShipmentEvent({this.codeShipment})
    : super([codeShipment]);
  @override
  String toString() {
    return 'SendShipmentEvent';
  }
}

class DeleteShipmentEvent extends ShipmentEvent {
  final String codeShipment;
  DeleteShipmentEvent({this.codeShipment})
    : super([codeShipment]);
  @override
  String toString() {
    return 'DeleteShipmentEvent';
  }
}

class SendRequestCancelShipmentEvent extends ShipmentEvent {
  final String codeShipment;
  final String codeReason;
  final String reasonTxt;
  SendRequestCancelShipmentEvent({this.codeShipment, this.codeReason, this.reasonTxt})
    : super([codeShipment, codeReason, reasonTxt]);
  @override
  String toString() {
    return 'SendRequestCancelShipmentEvent';
  }
}
