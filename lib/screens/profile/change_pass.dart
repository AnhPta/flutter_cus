import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/profile/bloc.dart';
import 'package:app_customer/screens/components/circular_progress_indicator.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePassPage extends StatefulWidget {
  ChangePassPage({Key key, this.title = 'ChangePass'}) : super(key: key);
  final String title;

  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  NavigationBloc navigationBloc;
  ProfileBloc profileBloc;
  NotifyBloc notifyBloc;
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool _autoValidateFrom = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
  }

//  @override
//  void dispose() {
//    oldPassController.dispose();
//    confirmPassController.dispose();
//    newPassController.dispose();
//    super.dispose();
//  }

  _onChangePassPressed() {
    if (_formKey.currentState.validate()) {
      profileBloc.dispatch(ChangePassEvent(
        oldPass: oldPassController.text,
        newPass: newPassController.text,
        confirmPass: confirmPassController.text,
      ));
    } else {
      setState(() {
        _autoValidateFrom = true;
      });
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.WARNING,
        message: 'Vui lòng kiểm tra lại thông tin cần nhập'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LoadedProfileState) {
            if (state.isSuccess) {
              Navigator.of(context).pop();
              oldPassController.text = '';
              newPassController.text = '';
              confirmPassController.text = '';
              setState(() {
                _autoValidateFrom = false;
              });
            }
          }
          if(state is FailureProfileState){

          }
        },
      ),
      BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
        if (state is UnauthenticatedAuthentication) {
          navigationBloc.dispatch(LoginNavigationEvent());
        }
      })
    ], child: _buildChangePass(context));
  }

  Widget _buildChangePass(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (ctx) => GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                backgroundColor: colorBackground,
                appBar: AppBar(
                  brightness: Brightness.light,
                  elevation: 0.5,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text("Thay đổi mật khẩu",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      )),
                  leading: IconButton(
                    onPressed: () {
                      oldPassController.text = '';
                      newPassController.text = '';
                      confirmPassController.text = '';
                      setState(() {
                        _autoValidateFrom = false;
                      });
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: TextFormField(
                            autofocus: true,
                            controller: oldPassController,
                            textCapitalization: TextCapitalization.words,
                            autovalidate: _autoValidateFrom,
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Mật khẩu không được để trống';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock_outline,
                                    color: colorPrimary),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: colorPrimary)),
                                labelText: 'Mật khẩu cũ',
                                labelStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: TextFormField(
                            controller: newPassController,
                            textCapitalization: TextCapitalization.words,
                            autovalidate: _autoValidateFrom,
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Mật khẩu mới không được để trống';
                              }
                              if(_.length < 5) {
                                return 'Mật khẩu mới phải nhiều hơn 4 ký tự!';
                              }
                              return null;
                            },
                            cursorColor: colorPrimary,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock_outline,
                                    color: colorPrimary),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: colorPrimary)),
                                labelText: 'Mật khẩu mới',
                                labelStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: TextFormField(
                            controller: confirmPassController,
                            textCapitalization: TextCapitalization.words,
                            autovalidate: _autoValidateFrom,
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Mật khẩu không được để trống';
                              }
                              return null;
                            },
                            cursorColor: colorPrimary,
                            decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.checkCircle,
                                    size: 20,
                                    color: colorPrimary),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: colorPrimary)),
                                labelText: 'Nhập lại mật khẩu',
                                labelStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              BlocBuilder<ProfileBloc, ProfileState>(
                                bloc: null,
                                builder: (context, state) {
                                  if(state is LoadedProfileState) {
                                    return RaisedButton(
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      onPressed: () {
                                        if(!state.isLoading) {
                                          _onChangePassPressed();
                                        }
                                      },
                                      color: colorPrimary,
                                      child: (state.isLoading) ? CircularLoader()
                                        : Text('Cập nhật', style: TextStyle(color: Colors.white, fontSize: 18)),
                                    );
                                  }
                                    return Container();
                                }
                              )
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
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
        child: Container(
          alignment: Alignment(0, 0),
          height: 60,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(10))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: Icon(
                        FontAwesomeIcons.lock,
                        color: colorPrimary,
                        size: 20,
                      ),
                      height: 50,
                      width: 50,
                      decoration: new BoxDecoration(
                          color: colorLightPrimary,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(13, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Đổi mật khẩu',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Thay đổi mật khẩu của bạn',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.chevronRight,
                    color: Colors.black12, size: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
