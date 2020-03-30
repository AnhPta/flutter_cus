import 'package:app_customer/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/login/bloc.dart';
import 'package:app_customer/screens/login/login_button.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  NavigationBloc navigationBloc;

  LoginBloc loginBloc;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginForm = GlobalKey<FormState>();
  bool _autoValidateFrom = false;
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  NotifyBloc notifyBloc;
  bool _obscureText = true;

  bool _rememberMe = false;
  void _isCheckRememberMe(bool value) => setState(() => _rememberMe = value);

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
  }

  void _onLoginButtonPressed() {
    if (_loginForm.currentState.validate()) {
      loginBloc.dispatch(ProcessLoginEvent(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    } else {
      setState(() {
        _autoValidateFrom = true;
      });
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.WARNING,
        message: 'Vui lòng kiểm tra lại thông tin cần nhập')
      );
    }
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is FailureLoginState) {
              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
              notifyBloc.dispatch(ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
            }

            if (state is LoadingLoginState) {
              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: true));
            }

            if (state is SuccessLoginState) {
              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
//              notifyBloc.dispatch(ShowNotifyEvent(type: NotifyEvent.SUCCESS, message: 'Đăng nhập thành công'));
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0.0,
            bottom: PreferredSize(
              child: Padding(
//              padding: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
              ),
              preferredSize: Size(0.0, 40.0),
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Form(
                    key: _loginForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
//                        Padding(
//                          padding: EdgeInsets.symmetric(vertical: 20),
//                          child: Image.asset('assets/futa_logo.jpg', height: 80,),
//                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _usernameController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
//                          icon: Icon(Icons.email),
                              labelText: 'Số điện thoại',
                              labelStyle: TextStyle(
                                color: Colors.black
                              )
                            ),
                            keyboardType: TextInputType.emailAddress,
                            focusNode: _usernameFocus,
                            autovalidate: _autoValidateFrom,
                            autocorrect: false,
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Số điện thoại không được để trống';
                              }
                              return null;
                            },
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(context, _usernameFocus, _passwordFocus);
                            }
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _passwordController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
//                          icon: Icon(Icons.lock),
                              labelText: 'Mật khẩu',
                              labelStyle: TextStyle(
                                color: Colors.black
                              ),
                              suffixIcon: IconButton(
                                icon: _obscureText ? Icon(FontAwesomeIcons.eyeSlash) : Icon(FontAwesomeIcons.eye),
                                color: colorPrimary,
                                onPressed: _toggle,
                              )
                            ),
                            obscureText: _obscureText,
                            autovalidate: _autoValidateFrom,
                            focusNode: _passwordFocus,
                            autocorrect: false,
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Mật khẩu không được để trống';
                              }
                              return null;
                            },
                            onFieldSubmitted: (term) {
                              _passwordFocus.unfocus();
                              _onLoginButtonPressed();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: _isCheckRememberMe,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text('Ghi nhớ tài khoản')
                                ],
                              ),
                              Text('Quên mật khẩu?',
                                style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold
                                )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              LoginButton(onPressed: _onLoginButtonPressed),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Bạn chưa có tài khoản?'),
                              GestureDetector(
                                onTap: () {
                                  navigationBloc.dispatch(RegistryNavigationEvent());
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  alignment: Alignment(0.0, 0.0),
                                  height: 40,
                                  child: Text(' Đăng ký',
                                    style: TextStyle(
                                      color: colorPrimary,
                                      fontWeight: FontWeight.bold
                                    )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
