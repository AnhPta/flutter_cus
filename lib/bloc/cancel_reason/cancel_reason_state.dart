import 'package:app_customer/repositories/cancel_reason/cancel_reason.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CancelReasonState extends Equatable {
  CancelReasonState([List props = const []]) : super(props);
}

class InitialCancelReasonState extends CancelReasonState {
  @override
  String toString() {
    return 'InitialCancelReasonState';
  }
}

class LoadingCancelReasonState extends CancelReasonState {
  @override
  String toString() {
    return 'LoadingCancelReasonState';
  }
}

class LoadedCancelReasonState extends CancelReasonState {
  final List<Reason> reason;

  LoadedCancelReasonState({
    this.reason,
  }) : super([
    reason
  ]);

  @override
  String toString() => 'LoadedCancelReasonState: $reason';

  factory LoadedCancelReasonState.empty() {
    return LoadedCancelReasonState(
      reason: [],
    );
  }

  LoadedCancelReasonState copyWith({
    List<Reason> reason,
  })

  {
    return LoadedCancelReasonState(
      reason: reason,
    );
  }
}

class FailureCancelReasonState extends CancelReasonState {
  final String error;
  FailureCancelReasonState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'FailureCancelReasonState {error: $error}';
  }
}
