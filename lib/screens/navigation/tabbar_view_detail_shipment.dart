import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/detail_shipment/bloc.dart';
import 'package:app_customer/bloc/detail_shipment/detail_shipment_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:app_customer/bloc/navigation/navigation_bloc.dart';
import 'package:app_customer/bloc/notify/notify_bloc.dart';
import 'package:app_customer/repositories/detail_shipment/detail_shipment_repository.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NestedTabBar extends StatefulWidget {
  final DetailShipmentRepository detailShipmentRepository;

  NestedTabBar({Key key, this.detailShipmentRepository}) : super(key: key);

  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;
  DetailShipmentBloc detailShipmentBloc;

  TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    detailShipmentBloc = BlocProvider.of<DetailShipmentBloc>(context);
    _nestedTabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
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
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocBuilder<DetailShipmentBloc, DetailShipmentState>(
            bloc: detailShipmentBloc,
            builder: (context, state) {
              if (state is LoadedDetailShipmentState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TabBar(
                      controller: _nestedTabController,
                      indicatorColor: colorAccent,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(fontSize: 14, fontFamily: "Roboto"),
                      tabs: <Widget>[
                        Tab(
                          text: "Luân chuyển",
                          icon: Icon(Icons.directions_bus),
                        ),
                        Tab(
                          text: "     Lịch sử     ",
                          icon: Icon(Icons.timeline),
                        ),
                        Tab(
                          text: "Ghi chú khác",
                          icon: Icon(Icons.event_note),
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: TabBarView(
                        controller: _nestedTabController,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 40, left: 40),
                            color: Colors.white,
                            child: Center(
                              child: Text('Hiện vận đơn đang trên đường lấy hàng hoặc chưa nhập kho!',
                              textAlign: TextAlign.center,
                              )
                            )
                          ),
                          SingleChildScrollView(
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: _showTimeLineShipment(state),
                              )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 40, left: 40),
                            color: Colors.white,
                            child: Center(
                              child: Text("Chúng tôi chưa nhận được thông tin ghi chú nào cho vận đơn này!",
                                textAlign: TextAlign.center,
                              ),
                            )
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Center(
                child: Container(),
              );
            }),
      ),
    );
  }

  _showTimeLineShipment(state) {
    List actions = <Widget>[];
    for (int i=0; i < state.detailShipment.statuses.length; i++) {
      var item = state.detailShipment.statuses[i];
      actions.add(
        Stack(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: new Card(
                margin: new EdgeInsets.all(10.0),
                child: new Container(
                  padding: EdgeInsets.all(5.0),
                  width: double.infinity,
                  height: 60.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${item.statusTxt}', style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: <Widget>[
                              Icon(Icons.access_time, size: 15, color: Colors.black45,),
                              Text('  ${item.createdAt}')
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('${item.description}'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            new Positioned(
              top: 0.0,
              bottom: 0.0,
              left: 22.0,
              child: new Container(
                height: double.infinity,
                width: 1.0,
                color: colorLightPrimary,
              ),
            ),
            new Positioned(
              top: 25.0,
              left: 7.0,
              child: new Container(
                height: 30.0,
                width: 30.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorPrimary,
                ),
                child: new Icon(Icons.timer, color: Colors.white, size: 18,),
              ),
            )
          ],
        ),
      );
    }
    return actions;
  }
}
