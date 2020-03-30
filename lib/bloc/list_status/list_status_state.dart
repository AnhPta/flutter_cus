import 'package:app_customer/repositories/list_status/list_status.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ListStatusState extends Equatable {
  ListStatusState([List props = const []]) : super(props);
}

class InitialListStatusState extends ListStatusState {
  @override
  String toString() {
    return 'InitialListStatusState';
  }
}

class LoadingListStatusState extends ListStatusState {
  @override
  String toString() {
    return 'LoadingListStatusState';
  }
}

class LoadedListStatusState extends ListStatusState {
  final List<ListStatus> listStatus;
  final bool showDialog;
  final bool showIcon;
  final String status;
  final bool isSuccess;
  final bool isFailure;
  final String messageSuccess;
  final String messageFailure;
  LoadedListStatusState({@required this.listStatus, this.isFailure = false, this.isSuccess = false, this.status,
    this.messageSuccess = '', this.messageFailure = '', this.showDialog = false, this.showIcon = false})
    : super([listStatus, isFailure, isSuccess, messageSuccess, messageFailure, showDialog, showIcon, status]);

  @override
  String toString() {
    return 'LoadedListStatusState {shipment: $listStatus, isSuccess: $isSuccess, isFailure: $isFailure, showDialog: $showDialog, messageSuccess: $messageSuccess, messageFailure: $messageFailure, }';
  }
  LoadedListStatusState copyWith({
    String messageSuccess,
    String messageFailure,
    List<ListStatus> shipment,
    bool isSuccess,
    String status,
    bool showIcon,
    bool isFailure,
    bool showDialog,
  })
  {
    return LoadedListStatusState(
      messageSuccess: messageSuccess ?? this.messageSuccess,
      messageFailure: messageFailure ?? this.messageFailure,
      listStatus: listStatus ?? this.listStatus,
      isSuccess: isSuccess ?? this.isSuccess,
      status: status ?? this.status,
      showDialog: showDialog ?? this.showDialog,
      showIcon: showIcon ?? this.showIcon,
      isFailure: isFailure ?? this.isFailure,
    );
  }
  static LoadedListStatusState initialFromJson(dynamic json) {
    return LoadedListStatusState(
      listStatus: json['data'],
    );
  }
}

class FailureListStatusState extends ListStatusState {
  final String error;
  FailureListStatusState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'LoadedListStatusState {error: $error}';
  }
}
