import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/profile/bloc.dart';
import 'package:app_customer/screens/components/circular_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:app_customer/utils/variables.dart';

class ProInfoPage extends StatefulWidget {
  ProInfoPage({Key key, this.title = 'ProInfo'}) : super(key: key);
  final String title;

  @override
  _ProInfoPageState createState() => _ProInfoPageState();
}

class _ProInfoPageState extends State<ProInfoPage> {
  NavigationBloc navigationBloc;
  ProfileBloc profileBloc;

  String dropdownValue = 'One';
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = new MaskedTextController(mask: '0000-00-00');
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  final _profileForm = GlobalKey<FormState>();
  bool _autoValidateFrom = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _birthdayFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  void _fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    profileBloc = BlocProvider.of<ProfileBloc>(context);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    addressController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _birthdayFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  _getInfoTextField(state, isPop) {
    if (state.user.name != null && nameController.text == '' || isPop) {
      nameController.text = '${state.user.name}';
    }
    if (state.user.phone != null && phoneController.text == '' || isPop) {
      phoneController.text = '${state.user.phone}';
    }
    if (state.user.birthday != null && birthdayController.text == '' || isPop) {
      birthdayController.text = '${state.user.birthday}';
    }
    if (state.user.email != null && emailController.text == '' || isPop) {
      emailController.text = '${state.user.email}';
    }
    if ( addressController.text != '' && state.user.address != null || state.user.address != '' || isPop) {
      addressController.text = '${state.user.address}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    return MultiBlocListener(listeners: [
      BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
        if (state is UnauthenticatedAuthentication) {
          navigationBloc.dispatch(LoginNavigationEvent());
        }
      })
    ], child: _buildChangeInfo(context));
  }

  Widget _buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0.5,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text("Thay đổi thông tin cá nhân",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16
        )),
      leading: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        builder: (context, state) {
          if (state is LoadedProfileState) {
            return IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getInfoTextField(state, true);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            );
          }
          return IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          );
        }
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is LoadedProfileState) {
            _getInfoTextField(state, false);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _profileForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: colorPrimary)),
                          isDense: true,
                          labelText: "Họ và tên",
                          hintText: "Nhập họ tên",
                          labelStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.account_box,
                            color: colorPrimary),
                        ),
                        autocorrect: false,
                        autovalidate: _autoValidateFrom,
                        validator: (_) {
                          if (_.isEmpty) {
                            return 'Họ & tên không được để trống';
                          }
                          return null;
                        },
                        focusNode: _nameFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _nameFocus, _phoneFocus);
                        },
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: phoneController,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        validator: (_) {
                          if (_.isEmpty) {
                            return 'SĐT không được để trống';
                          }
                          return null;
                        },
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _phoneFocus, _birthdayFocus);
                        },
                        focusNode: _phoneFocus,
                        cursorColor: colorPrimary,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: colorPrimary)),
                          isDense: true,
                          labelText: "Số điện thoại",
                          hintText: "Nhập số điện thoại",
                          labelStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.phone_android,
                            color: colorPrimary),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: birthdayController,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        cursorColor: colorPrimary,
                        keyboardType: TextInputType.datetime,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _birthdayFocus, _emailFocus);
                        },
                        focusNode: _birthdayFocus,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colorPrimary)
                          ),
                          isDense: true,
                          labelText: "Ngày sinh",
                          hintText: "YYYY-MM-DD",
                          labelStyle: TextStyle(color: Colors.black),
                          icon:
                          Icon(Icons.date_range, color: colorPrimary),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        cursorColor: colorPrimary,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _emailFocus, _addressFocus);
                        },
                        focusNode: _emailFocus,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: colorPrimary)),
                          isDense: true,
                          labelText: "E-mail",
                          hintText: "Nhập e-mail",
                          labelStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.email, color: colorPrimary),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: addressController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: colorPrimary)),
                          isDense: true,
                          labelText: "Địa chỉ",
                          hintText: "Nhập địa chỉ",
                          labelStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.edit_location, color: colorPrimary),
                        ),
                        focusNode: _addressFocus,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            onPressed: () {
                              if (!state.isLoading) {
                                profileBloc.dispatch(ChangeProfileEvent(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  birthday: birthdayController.text,
                                  email: emailController.text,
                                  address: addressController.text,
                                ));
                                profileBloc.dispatch(FetchProfileEvent());
                              }
                            },
                            color: colorPrimary,
                            child: (state.isLoading)
                              ? CircularLoader()
                              : Text('Cập nhật', style: TextStyle(
                              color: Colors.white, fontSize: 18)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        }),
    );
  }
  Widget _buildChangeInfo(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => GestureDetector(
              onTap: (){ FocusScope.of(context).requestFocus(new FocusNode()); },
              child: Scaffold(
                backgroundColor: colorBackground,
                appBar: _buildAppBar(),
                body: _buildBody()
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
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
                        FontAwesomeIcons.cog,
                        size: 20,
                        color: colorPrimary,
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
                          'Thông tin tài khoản',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Cập nhật thông tin tài khoản',
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
