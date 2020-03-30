import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ConfigState extends Equatable {
  ConfigState([List props = const []]) : super(props);
}

class InitialConfigState extends ConfigState {
  @override
  String toString() {
    return 'InitialConfigState';
  }
}

class LoadingConfigState extends ConfigState {
  @override
  String toString() {
    return 'LoadingConfigState';
  }
}

class LoadedConfigState extends ConfigState {
  final double config;

  LoadedConfigState({
    @required this.config
  }) : super([config]);

  @override
  String toString() {
    return 'LoadedConfigState: $config';
  }
  LoadedConfigState copyWith({
    double config,
  })
  {
    return LoadedConfigState(
      config: config ?? this.config,
    );
  }
}

class FailureConfigState extends ConfigState {
  final String error;
  FailureConfigState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'LoadedConfigState {error: $error}';
  }
}
