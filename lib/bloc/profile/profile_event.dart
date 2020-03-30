import 'dart:io';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  ProfileEvent([List props = const []]) : super(props);
}

class FetchProfileEvent extends ProfileEvent {
  @override
  String toString() {
    return 'FetchProfileEvent';
  }
}
class ChangePassEvent extends ProfileEvent {
  final String oldPass;
  final String newPass;
  final String confirmPass;

  ChangePassEvent({this.oldPass, this.newPass, this.confirmPass})
    : super([oldPass, newPass, confirmPass]);

  @override
  String toString() {
    // TODO: implement toString
    return 'ChangePass {oldPass: $oldPass, newPass: $newPass, confirmPass: $confirmPass}';
  }
}
class ChangeProfileEvent extends ProfileEvent {
  final String name;
  final String phone;
  final String birthday;
  final String email;
  final String address;

  ChangeProfileEvent({this.name, this.phone, this.birthday, this.email, this.address})
    : super([name, phone, birthday, email, address]);

  @override
  String toString() {
    // TODO: implement toString
    return 'ChangeProfile {name: $name, phone: $phone, birthday: $birthday, email: $email, address: $address}';
  }
}
class ChangeAvatarEvent extends ProfileEvent {
  final File file;
  ChangeAvatarEvent({this.file})
    : super([file]);
  @override
  String toString() {
    // TODO: implement toString
    return 'ChangeAvatar {file: $file}';
  }
}
class ShowDiaLogChangePassEvent extends ProfileEvent {
  @override
  String toString() {
    return 'ShowDiaLogChangePassEvent';
  }
}
class CloseDiaLogChangePassEvent extends ProfileEvent {
  @override
  String toString() {
    return 'CloseDiaLogChangePassEvent';
  }
}
class ChangePassSuccessEvent extends ProfileEvent {
  @override
  String toString() {
    return 'ChangePassSuccessEvent';
  }
}
