import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/repositories/user/user_repository.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/registry/bloc.dart';
import 'package:app_customer/screens/registry/registry_form.dart';

class RegistryPage extends StatelessWidget {
  final UserRepository userRepository;

  RegistryPage({Key key, @required this.userRepository})
    : assert(userRepository != null),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        builder: (context) {
          return RegistryBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: RegistryForm(),
      ),
    );
  }
}
