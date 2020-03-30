import 'dart:io';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:app_customer/bloc/logout/bloc.dart';
import 'package:app_customer/screens/profile/change_pass.dart';
import 'package:app_customer/screens/profile/contact_place.dart';
import 'package:app_customer/screens/profile/profile_info.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_customer/bloc/profile/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MainProfile());
  }
}

class MainProfile extends StatefulWidget {
  @override
  State<MainProfile> createState() {
    return _MainProfileState();
  }
}

class _MainProfileState extends State<MainProfile> {
  NavigationBloc navigationBloc;
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void initState() {
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is UnauthenticatedAuthentication) {
              navigationBloc.dispatch(LoginNavigationEvent());
            }
          })
      ],
      child: Scaffold(
        backgroundColor: colorBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(220.0),
          child: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            flexibleSpace: _buildAppBar(context),
            backgroundColor: colorBackground,
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              ProInfoPage(),
                              ChangePassPage(),
                              _buildNotify(context),
                              ContactPlaceBoxPage(),
                              _buildRuleRegulation(),
                              _buildTransaction(),
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(30.0),
                                      ),
                                      padding: EdgeInsets.all(15),
                                      color: Colors.white,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title: Text('Thông báo'),
                                              content: Text(
                                                'Đăng xuất khỏi hệ thống'),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  child: new Text('Đóng', style: TextStyle(color: colorPrimary)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  isDefaultAction: true,
                                                  child: Text('Xác nhận', style: TextStyle(color: colorPrimary)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    BlocProvider.of<LogoutBloc>(context).dispatch(ProcessLogoutEvent());
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Đăng xuất',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildAppBar(context) {
  return Stack(
    children: <Widget>[
      _buildCoverImage(),
      _buildBoxInfo(context)],
  );
}
Widget _buildCoverImage() {
  return Container(
    height: 190,
    decoration: new BoxDecoration(
      color: colorPrimary,
      borderRadius: new BorderRadius.only(
        bottomLeft: const Radius.circular(20.0),
        bottomRight: const Radius.circular(20.0))),
  );
}
BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(color: Colors.white, width: 5.0),
    borderRadius: BorderRadius.all(Radius.circular(55.0)),
  );
}
Widget _buildBoxInfo(BuildContext context) {
  return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
    if (state is LoadedProfileState) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              alignment: Alignment.centerLeft,
              child: Text('Phiên bản 1.0.0', style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),),
            ),
            Container(
              height: 130,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: <Widget>[
                  _buildProfileImage(context),
                  SizedBox(height: 10),
                  Text(state.user.name,
                    style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w800)),
                  SizedBox(height: 5),
                  Text(state.user.phone),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  });
}
Widget _buildProfileImage(BuildContext context) {
  ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
  Future<Null> _pickImageGallery() async {
    final File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery);
    profileBloc.dispatch(ChangeAvatarEvent(file: imageFile));
  }

  Future<Null> _pickImageCam() async {
    final File imageFile =
    await ImagePicker.pickImage(source: ImageSource.camera);
    profileBloc.dispatch(ChangeAvatarEvent(file: imageFile));
  }

  void _settingModalBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext bc) {
        return CupertinoActionSheet(
          title: Text('Mời bạn chọn hành động'),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Đóng")),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Chụp ảnh mới'),
              onPressed: ()  async => await _pickImageCam(),
            ),
            CupertinoActionSheetAction(
              child:Text('Ảnh từ thư viện'),
              onPressed: () async => await _pickImageGallery(),
            )
          ],
        );
      }
    );
  }

  return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
    if (state is LoadedProfileState) {
      return Column(
        children: <Widget>[
          Center(
            child: Container(
              decoration: myBoxDecoration(),
              child: GestureDetector(
                child: Hero(
                  tag: 'avatar',
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(state.user.avatarPath),
                  )),
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext bc) {
                      return CupertinoActionSheet(
                        title: Text('Mời bạn chọn hành động'),
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Đóng")),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text('Xem ảnh đại diện'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => Scaffold(
                                      backgroundColor: Colors.black45,
                                      appBar: AppBar(
                                        brightness: Brightness.light,
                                        backgroundColor: Colors.transparent,
                                        leading: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(Icons.close,
                                            size: 25, color: Colors.white),
                                        ),
                                      ),
                                      body: Center(
                                        child: Hero(
                                          tag: 'avatar',
                                          child: Image.network(
                                            state.user.avatarPath),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                            },
                          ),
                          CupertinoActionSheetAction(
                            child:Text('Đổi ảnh đại diện'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _settingModalBottomSheet(context);
                            },
                          )
                        ],
                      );
                    }
                  );
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/avatar.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(55),
            border: Border.all(
              color: Colors.white,
              width: 5,
            )),
        ),
      );
    }
  });
}
Widget _buildNotify(context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
    child: GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Thông báo'),
              content: Text('Tính năng chưa ra mắt!'),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text('Đóng', style: TextStyle(color: colorPrimary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      },
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
                      Icons.notifications,
                      size: 25,
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
                        'Cài đặt thông báo',
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Thay đổi cấu hình thông báo',
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
Widget _buildRuleRegulation() {
  return Padding(
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
                    Icons.verified_user,
                    size: 23,
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
                      'Điều khoản & quy định',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Theo dõi chính sách của chúng tôi',
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
  );
}
Widget _buildTransaction() {
  return Padding(
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
                    Icons.map,
                    size: 23,
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
                      'Mạng lưới phòng giao dịch',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tìm kiếm mạng lưới PGD quanh bạn',
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
  );
}
