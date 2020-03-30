import 'package:app_customer/repositories/pagination/pagination.dart';
import 'package:app_customer/repositories/shipment/filter_shipment.dart';
import 'package:app_customer/repositories/shipment/search_shipment.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ShipmentState extends Equatable {
  ShipmentState([List props = const []]) : super(props);
}

class InitialShipmentState extends ShipmentState {
  @override
  String toString() {
    return 'InitialShipmentState';
  }
}

class LoadingShipmentState extends ShipmentState {
  @override
  String toString() {
    return 'LoadingShipmentState';
  }
}

class LoadedShipmentState extends ShipmentState {
  final String countFilter;
  final Pagination pagination;
  final List<Shipment> shipments;
  final FilterShipment filterShipment;
  final bool isLoadingFilter;
  final SearchShipment searchShipment;
  final bool showDialog;
  final bool isSuccess;
  final bool isFailure;
  final String messageSuccess;
  final String messageFailure;
  final String status;
  final String statusTxt;
  final String cityPopName;
  final bool selectStatus;
  final bool selectCityPick;
  final bool selectCityPop;
  final bool selectCreateDate;
  final bool selectDateRanger;
  final bool selectDelete;
  final bool isFetchDraft;
  final bool isFetched;
  final bool isFetchFilter;
  LoadedShipmentState({
    this.pagination,
    this.countFilter,
    this.filterShipment,
    this.isLoadingFilter = false,
    this.searchShipment,
    this.shipments,
    this.isFailure = false,
    this.isSuccess = false,
    this.messageSuccess = '',
    this.messageFailure = '',
    this.status = '',
    this.statusTxt = '',
    this.cityPopName = '',
    this.selectStatus = false,
    this.selectCityPick = false,
    this.selectCityPop = false,
    this.selectCreateDate = false,
    this.selectDateRanger = false,
    this.selectDelete = false,
    this.showDialog = false,
    this.isFetchDraft = false,
    this.isFetched = false,
    this.isFetchFilter = false,
  }) : super([
    countFilter,
    pagination,
    filterShipment,
    isLoadingFilter,
    searchShipment,
    shipments,
    isFailure,
    isSuccess,
    messageSuccess,
    messageFailure,
    status,
    statusTxt,
    cityPopName,
    selectStatus,
    selectCityPick,
    selectCityPop,
    selectCreateDate,
    selectDateRanger,
    selectDelete,
    showDialog,
    isFetchDraft,
    isFetched,
    isFetchFilter,
  ]);

  @override
  String toString() {
    return '''LoadedShipmentState {
      countFilter: $countFilter, 
      pagination: $pagination, 
      filterShipment: $filterShipment, 
      isLoadingFilter: $isLoadingFilter, 
      searchShipment: $searchShipment, 
      shipments: $shipments, 
      isSuccess: $isSuccess, 
      isFailure: $isFailure, 
      showDialog: $showDialog, 
      selectCreateDate: $selectCreateDate, 
      messageSuccess: $messageSuccess, 
      status: $status, 
      statusTxt: $statusTxt, 
      cityPopName: $cityPopName, 
      selectStatus: $selectStatus, 
      selectStatus: $selectCityPop, 
      selectStatus: $selectCityPick, 
      selectStatus: $selectDateRanger, 
      selectDelete: $selectDelete, 
      messageFailure: $messageFailure, 
      isFetchFilter: $isFetchFilter, 
    }''';
  }

  factory LoadedShipmentState.empty() {
    return LoadedShipmentState(
       countFilter: '0',
       pagination: Pagination.empty(),
       filterShipment: FilterShipment.empty(),
      isLoadingFilter: false,
       searchShipment: SearchShipment.empty(),
       messageSuccess: '',
       messageFailure: '',
       status: '',
       statusTxt: '',
       cityPopName: '',
       selectStatus: false,
       selectCityPop: false,
       selectCityPick: false,
       selectDateRanger: false,
       shipments: [],
       isSuccess: false,
       isFailure: false,
       showDialog: false,
       selectCreateDate: false,
       selectDelete: false,
       isFetchDraft: false,
       isFetched: false,
      isFetchFilter: false,
    );
  }

  LoadedShipmentState copyWith({
    String countFilter,
    Pagination pagination,
    FilterShipment filterShipment,
    bool isLoadingFilter,
    SearchShipment searchShipment,
    String messageSuccess,
    String messageFailure,
    String status,
    String statusTxt,
    String cityPopName,
    bool selectStatus,
    bool selectCityPick,
    bool selectCityPop,
    bool selectCreateDate,
    bool selectDateRanger,
    bool selectDelete,
    List<Shipment> shipments,
    bool isSuccess,
    bool isFailure,
    bool showDialog,
    bool isFetchDraft,
    bool isFetched,
    bool isFetchFilter,
  })
  {
    return LoadedShipmentState(
      countFilter: countFilter ?? this.countFilter,
      pagination: pagination ?? this.pagination,
      filterShipment: filterShipment ?? this.filterShipment,
      isLoadingFilter: isLoadingFilter ?? this.isLoadingFilter,
      searchShipment: searchShipment ?? this.searchShipment,
      messageSuccess: messageSuccess ?? this.messageSuccess,
      messageFailure: messageFailure ?? this.messageFailure,
      status: status ?? this.status,
      statusTxt: statusTxt ?? this.statusTxt,
      cityPopName: cityPopName ?? this.cityPopName,
      selectStatus: selectStatus ?? this.selectStatus,
      selectCityPop: selectCityPop ?? this.selectCityPop,
      selectCityPick: selectCityPick ?? this.selectCityPick,
      selectDateRanger: selectDateRanger ?? this.selectDateRanger,
      shipments: shipments ?? this.shipments,
      isSuccess: isSuccess ?? this.isSuccess,
      showDialog: showDialog ?? this.showDialog,
      selectCreateDate: selectCreateDate ?? this.selectCreateDate,
      selectDelete: selectDelete ?? this.selectDelete,
      isFailure: isFailure ?? this.isFailure,
      isFetchDraft: isFetchDraft ?? this.isFetchDraft,
      isFetched: isFetched ?? this.isFetched,
      isFetchFilter: isFetchFilter ?? this.isFetchFilter,
    );
  }
}

class FailureShipmentState extends ShipmentState {
  final String error;
  FailureShipmentState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'LoadedListStatusState {error: $error}';
  }
}
