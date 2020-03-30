import 'package:flutter/material.dart';
import 'package:app_customer/screens/app.dart';
import 'package:bloc/bloc.dart';
import 'package:app_customer/bloc/simple_bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}
