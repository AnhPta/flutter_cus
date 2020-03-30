import 'package:app_customer/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/registry/bloc.dart';
import 'package:app_customer/screens/registry/registry_button.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';

class RegistryForm extends StatefulWidget {
  @override
  State<RegistryForm> createState() => _RegistryFormState();
}

class _RegistryFormState extends State<RegistryForm> {
  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;
  RegistryBloc registryBloc;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  final _registryForm = GlobalKey<FormState>();
  bool _autoValidateFrom = false;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();
  bool _obscureText = true;
  bool _agreeTerms = false;
  void _isCheckAgreeTerms(bool value) => setState(() => _agreeTerms = value);

  @override
  void initState() {
    super.initState();
    registryBloc = BlocProvider.of<RegistryBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
  }

  void _onRegistryButtonPressed() {
    if (_registryForm.currentState.validate()) {
      if (!_agreeTerms) {
        notifyBloc.dispatch(ShowNotifyEvent(
            type: NotifyEvent.WARNING,
            message: 'Vui lòng đồng ý điều khoản sử dụng'));
      } else {
        registryBloc.dispatch(ProcessRegistryEvent(
          name: _nameController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          passwordConfirm: _passwordConfirmController.text,
        ));
      }
    } else {
      setState(() {
        _autoValidateFrom = true;
      });
      notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.WARNING,
          message: 'Vui lòng kiểm tra lại thông tin cần nhập'));
    }
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: IconButton(
        highlightColor: Colors.transparent,
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
        onPressed: () {
          navigationBloc.dispatch(HomeNavigationEvent());
        }),
      bottom: PreferredSize(
        preferredSize: Size(0.0, 40.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Đăng ký",
              style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Form(
            key: _registryForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    cursorColor: colorPrimary,
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorPrimary)),
                      labelText: 'Tên cửa hàng/Khách hàng',
                      labelStyle: TextStyle(color: Colors.black)),
                    focusNode: _nameFocus,
                    autovalidate: _autoValidateFrom,
                    autocorrect: false,
                    validator: (_) {
                      if (_.isEmpty) {
                        return 'Tên cửa hàng/khách hàng không được để trống';
                      }
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _nameFocus, _phoneFocus);
                    }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    cursorColor: colorPrimary,
                    controller: _phoneController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorPrimary)),
                      labelText: 'Số điện thoại',
                      labelStyle: TextStyle(color: Colors.black)),
                    keyboardType: TextInputType.number,
                    focusNode: _phoneFocus,
                    autovalidate: _autoValidateFrom,
                    autocorrect: false,
                    validator: (_) {
                      if (_.isEmpty) {
                        return 'Số điện thoại không được để trống';
                      }
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _phoneFocus, _passwordFocus);
                    }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    cursorColor: colorPrimary,
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorPrimary)),
                      labelText: 'Mật khẩu',
                      labelStyle: TextStyle(color: Colors.black),
                      suffixIcon: IconButton(
                        icon: _obscureText
                          ? Icon(FontAwesomeIcons.eyeSlash)
                          : Icon(FontAwesomeIcons.eye),
                        color: colorPrimary,
                        onPressed: _toggle,
                      )),
                    keyboardType: TextInputType.emailAddress,
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
                      _fieldFocusChange(context, _passwordFocus, _passwordConfirmFocus);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    cursorColor: colorPrimary,
                    controller: _passwordConfirmController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorPrimary)),
                      labelText: 'Nhập lại Mật khẩu',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: _obscureText,
                    autovalidate: _autoValidateFrom,
                    focusNode: _passwordConfirmFocus,
                    autocorrect: false,
                    validator: (_) {
                      if (_.isEmpty) {
                        return 'Nhập lại Mật khẩu không được để trống';
                      }
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _passwordConfirmFocus.unfocus();
                      _onRegistryButtonPressed();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _agreeTerms,
                            onChanged: _isCheckAgreeTerms,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap
                          ),
                          Text('Tôi đồng ý với '),
                          Text('điều khoản ',
                            style: TextStyle(
                              color: colorPrimary,
                            )),
                          Text('của FUTAID'),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RegistryButton(onPressed: _onRegistryButtonPressed),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Bạn đã có tài khoản?'),
                      GestureDetector(
                        onTap: () {
                          navigationBloc.dispatch(HomeNavigationEvent());
                        },
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment(0.0, 0.0),
                          height: 40,
                          child: Text(' Đăng nhập',
                            style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.bold
                            )
                          ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<RegistryBloc, RegistryState>(
            listener: (context, state) {
              if (state is FailureRegistryState) {
                notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
                notifyBloc.dispatch(ShowNotifyEvent(
                    type: NotifyEvent.ERROR, message: state.error));
              }

              if (state is LoadingRegistryState) {
                notifyBloc.dispatch(LoadingNotifyEvent(isLoading: true));
              }

              if (state is SuccessRegistryState) {
                notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
                notifyBloc.dispatch(ShowNotifyEvent(
                    type: NotifyEvent.SUCCESS, message: 'Đăng ký thành công'));
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
            appBar: _buildAppBar(),
            body: _buildContent(),
          ),
        ));
  }
}
