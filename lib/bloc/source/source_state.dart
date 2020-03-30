import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:app_customer/repositories/source/source.dart';

@immutable
abstract class SourceState extends Equatable {
  SourceState([List props = const []]) : super(props);
}

class InitialSourceState extends SourceState {
  @override
  String toString() {
    return 'InitialSourceState';
  }
}

class LoadingSourceState extends SourceState {
  @override
  String toString() {
    return 'LoadingSourceState';
  }
}

class LoadedSourceState extends SourceState {
  final List<Source> sources;

  LoadedSourceState({@required this.sources}) : super([sources]);
}

class FailureSourceState extends SourceState {
  final String error;
  FailureSourceState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'FailureSourceState {error: $error}';
  }
}

