import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/profile/bloc.dart';
import 'package:app_customer/bloc/wallet/bloc.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title = 'Home'}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;
  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is UnauthenticatedAuthentication) {
              navigationBloc.dispatch(LoginNavigationEvent());
            }
          }),
        BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is FailureWalletState) {
//              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
              notifyBloc.dispatch(
                ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
            }
          }),
      ],
      child: BlocProvider.value(
        value: BlocProvider.of<AuthenticationBloc>(context),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(240.0),
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
                    _buildCoverImage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(context) {
    return Stack(
      children: <Widget>[
        _buildBackground(),
        _buildAppbarTitle(context),
        _buildBodyHomePage(context),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      height: 190,
      decoration: new BoxDecoration(
          color: colorPrimary,
          borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(20.0),
              bottomRight: const Radius.circular(20.0))),
    );
  }

  Widget _buildAppbarTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 25.0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          makeAppTitle(),
        ],
      ),
    );
  }

  Widget makeAppTitle() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        if (state is LoadedProfileState) {
          return Text("Xin chào, " + state.user.name,
              style: TextStyle(fontSize: 20, color: Colors.white));
        }
        return Text('Xin chào, ...',
            style: TextStyle(fontSize: 20, color: Colors.white));
      }),
    );
  }

  Widget _buildBodyHomePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 80),
          Container(
            height: 130,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.black12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Tài khoản chính',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            _buildBalance(context),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                FontAwesomeIcons.arrowCircleRight,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        navigationBloc.dispatch(CreateShipmentNavigationEvent(type: 'create', redirectDetail: false));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(FontAwesomeIcons.telegramPlane),
                            ),
                            Text('Gửi hàng')
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: () {
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
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.account_balance_wallet),
                            ),
                            Text('Nạp tiền')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalance(BuildContext context) {
    return Container(
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is LoadedWalletState) {
              return Text(
                '${formatMoney.format(int.parse('${state.wallet.first}'))}' + ' đ ',
                style:
                TextStyle(fontSize: 18, color: Color(0xff0047cc)),
              );
            } else {
              return Text('...',
                  style: TextStyle(fontSize: 16, color: Colors.black));
            }
          },
        )
    );

  }

  Widget _buildCoverImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: AssetImage(
              'assets/banner.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
