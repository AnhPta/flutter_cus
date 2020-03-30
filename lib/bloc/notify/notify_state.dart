import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class NotifyState extends Equatable {
  NotifyState([List props = const []]) : super(props);
}

class InitialNotifyState extends NotifyState {
  @override
  String toString() {
    return 'InitialNotifyState';
  }
}

class SuccessNotifyState extends NotifyState {
  final String message;
  SuccessNotifyState({@required this.message}) : super([message]);

  @override
  String toString() {
    return 'SuccessNotifyState {message: $message}';
  }
}

class ErrorNotifyState extends NotifyState {
  final String message;
  ErrorNotifyState({@required this.message}) : super([message]);

  @override
  String toString() {
    return 'ErrorNotifyState {message: $message}';
  }
}

class WarningNotifyState extends NotifyState {
  final String message;
  WarningNotifyState({@required this.message}) : super([message]);

  @override
  String toString() {
    return 'WarningNotifyState {message: $message}';
  }
}

class InfoNotifyState extends NotifyState {
  final String message;
  InfoNotifyState({@required this.message}) : super([message]);

  @override
  String toString() {
    return 'InfoNotifyState {message: $message}';
  }
}

class LoadingNotifyState extends NotifyState {
  final bool isLoading;

  LoadingNotifyState({@required this.isLoading}) : super([isLoading]);

  @override
  String toString() {
    return 'LoadingNotifyState {is_loading: $isLoading}';
  }
}
