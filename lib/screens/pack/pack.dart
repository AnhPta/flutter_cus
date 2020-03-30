import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/screens/pack/pack_scan.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';

class PackPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final NavigationBloc navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text('Danh sách gói'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            navigationBloc.dispatch(HomeNavigationEvent());
          }
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            tooltip: 'Tạo gói',
            onPressed: () => _openDialogPackScan(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[],
        ),
      ),
    );
  }

  _openDialogPackScan(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return PackScan();
        },
        fullscreenDialog: true));
  }
}

class MiddleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.blue,
      ),
    );
  }
}

class BottomSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 50,
    );
  }
}
