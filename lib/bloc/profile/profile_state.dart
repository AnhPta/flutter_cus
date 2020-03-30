import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:app_customer/repositories/user/user.dart';

@immutable
abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super(props);
}

class InitialProfileState extends ProfileState {
  @override
  String toString() {
    return 'InitialProfileState';
  }
}

class LoadingProfileState extends ProfileState {
  @override
  String toString() {
    return 'LoadingProfileState';
  }
}

class LoadedProfileState extends ProfileState {
  final User user;
  final bool showDialog;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;
  final String messageSuccess;
  final String messageFailure;
  LoadedProfileState({@required this.user, this.isFailure = false, this.isSuccess = false, this.isLoading = false,
    this.messageSuccess = '', this.messageFailure = '', this.showDialog = false})
    : super([user, isFailure, isSuccess, isLoading, messageSuccess, messageFailure, showDialog]);

  @override
  String toString() {
    return 'LoadedProfileState {user: $user, isSuccess: $isSuccess,, isLoading: $isLoading, isFailure: $isFailure, showDialog: $showDialog, messageSuccess: $messageSuccess, messageFailure: $messageFailure, }';
  }
  LoadedProfileState copyWith({
    String messageSuccess,
    String messageFailure,
    User user,
    bool isSuccess,
    bool isFailure,
    bool isLoading,
    bool showDialog,
  })
  {
    return LoadedProfileState(
      messageSuccess: messageSuccess ?? this.messageSuccess,
      messageFailure: messageFailure ?? this.messageFailure,
      user: user ?? this.user,
      isSuccess: isSuccess ?? this.isSuccess,
      showDialog: showDialog ?? this.showDialog,
      isFailure: isFailure ?? this.isFailure,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FailureProfileState extends ProfileState {
  final String error;
  FailureProfileState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'LoadedProfileState {error: $error}';
  }
}
