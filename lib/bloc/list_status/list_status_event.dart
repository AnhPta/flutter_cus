import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ListStatusEvent extends Equatable {
  ListStatusEvent([List props = const []]) : super(props);
}

class FetchListStatusEvent extends ListStatusEvent {
  @override
  String toString() {
    return 'FetchListStatusEvent';
  }
}
class DisplayIconListStatusEvent extends ListStatusEvent {
  final bool isShowIcon;
  final String status;
  DisplayIconListStatusEvent({this.isShowIcon, this.status})
    : super([isShowIcon, status]);
  @override
  String toString() {
    return 'DisplayIconListStatusEvent';
  }
}
