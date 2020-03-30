import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LogoutEvent extends Equatable {
  LogoutEvent([List props = const []]) : super(props);
}

class ProcessLogoutEvent extends LogoutEvent {
  @override
  String toString() {
    return 'ProcessLogoutEvent';
  }
}
