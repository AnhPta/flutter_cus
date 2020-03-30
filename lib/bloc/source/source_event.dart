import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SourceEvent extends Equatable {
  SourceEvent([List props = const []]) : super(props);
}

class FetchSourceEvent extends SourceEvent{
  @override
  String toString() {
    return 'FetchSourceEvent';
  }
}
