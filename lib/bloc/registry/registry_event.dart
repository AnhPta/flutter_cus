import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class RegistryEvent extends Equatable {
  RegistryEvent([List props = const []]) : super(props);
}

//class RegistryEvent extends RegistryEvent {
//  final String oldPass;
//  final String newPass;
//  final String confirmPass;
//
//  ChangePassEvent({this.oldPass, this.newPass, this.confirmPass})
//    : super([oldPass, newPass, confirmPass]);
//
//  @override
//  String toString() {
//    // TODO: implement toString
//    return 'ChangePass {oldPass: $oldPass, newPass: $newPass, confirmPass: $confirmPass}';
//  }
//}

class ProcessRegistryEvent extends RegistryEvent {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirm;

  ProcessRegistryEvent({
    @required this.name,
    @required this.phone,
    @required this.password,
    @required this.passwordConfirm,
  }) : super([name, phone, password, passwordConfirm]);

  @override
  String toString() {
    return '''ProcessRegistryEvent {
      phone: $name,
      phone: $phone,
      password: $password
      password: $passwordConfirm
    }''';
  }
}
