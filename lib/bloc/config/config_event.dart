import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConfigEvent extends Equatable {
  ConfigEvent([List props = const []]) : super(props);
}

class FetchConfigEvent extends ConfigEvent {
  @override
  String toString() {
    return 'FetchConfigEvent';
  }
}
