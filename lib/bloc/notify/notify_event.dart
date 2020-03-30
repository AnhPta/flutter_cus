import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class NotifyEvent extends Equatable {
  static const ERROR = 0;
  static const SUCCESS = 1;
  static const WARNING = 2;
  static const INFO = 3;

  NotifyEvent([List props = const []]) : super(props);
}

class ShowNotifyEvent extends NotifyEvent {
  final int type;
  final String message;
  ShowNotifyEvent({@required this.type, @required this.message})
      : super([type, message]);

  @override
  String toString() {
    return '''ShowNotifyEvent {
      type: $type,
      message: $message
    }''';
  }
}

class LoadingNotifyEvent extends NotifyEvent {
  final bool isLoading;

  LoadingNotifyEvent({@required this.isLoading})
    : super([isLoading]);

  @override
  String toString() {
    return 'LoadingNotifyEvent {is_loading: $isLoading}';
  }

}
