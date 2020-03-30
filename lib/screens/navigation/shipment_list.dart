import 'dart:async';
//import 'dart:math';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/cancel_reason/bloc.dart';
import 'package:app_customer/bloc/city/bloc.dart';
import 'package:app_customer/bloc/create_shipment/bloc.dart';
import 'package:app_customer/bloc/detail_shipment/bloc.dart';
import 'package:app_customer/bloc/list_status/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/shipment/bloc.dart';
import 'package:app_customer/screens/components/circular_color.dart';
import 'package:app_customer/screens/filter_shipment/filter_shipment.dart';
import 'package:app_customer/screens/navigation/alert_dialog_delete.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:vector_math/vector_math.dart' show radians;
//import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class ShipmentScreen extends StatelessWidget {
  final LoadedShipmentState loadedShipmentState;
  ShipmentScreen({
    Key key,
    this.loadedShipmentState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MainShipmentList(loadedShipmentState: loadedShipmentState)
    );
  }
}

class MainShipmentList extends StatefulWidget {
  final LoadedShipmentState loadedShipmentState;

  MainShipmentList({
    Key key,
    this.loadedShipmentState,
  }) : super(key: key);


  @override
  _MainShipmentListState createState() => _MainShipmentListState(loadedShipmentState: loadedShipmentState);
}

class _MainShipmentListState extends State<MainShipmentList>
      with SingleTickerProviderStateMixin{
  final LoadedShipmentState loadedShipmentState;

  _MainShipmentListState({
    Key key,
    this.loadedShipmentState,
  });

  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;
  ShipmentBloc shipmentBloc;
  ListStatusBloc listStatusBloc;
  CityBloc cityBloc;
  DetailShipmentBloc detailShipmentBloc;
  CreateShipmentBloc createShipmentBloc;
  CancelReasonBloc cancelReasonBloc;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.clear();
    FocusScope.of(context).requestFocus(new FocusNode());
    shipmentBloc.dispatch(RefreshShipmentEvent());
    listStatusBloc.dispatch(DisplayIconListStatusEvent(isShowIcon: false, status: ''));
    return null;
  }

  Future _fetchDraft(context) async {
    shipmentBloc.dispatch(FetchDraftShipmentEvent());
    await Future.delayed(Duration(seconds: 1));
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 205,
          alignment: Alignment.center,
          child: Text('Không có dữ liệu. Vuốt xuống để thử lại.'),
        ),
      )
    );
  }

  Future<Null> _filterShipment() async {
    await Future.delayed(Duration(milliseconds: 800));
    shipmentBloc.dispatch(SearchShipmentEvent(q: _controller.text));
    return null;
  }

  final _controller = TextEditingController();
  String selectedState ;

  AnimationController controller;
  Animation<double> scale;
  Animation<double> translation;
  Animation<double> rotation;

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);

    shipmentBloc = BlocProvider.of<ShipmentBloc>(context);
    createShipmentBloc = BlocProvider.of<CreateShipmentBloc>(context);
    listStatusBloc = BlocProvider.of<ListStatusBloc>(context);
    cityBloc = BlocProvider.of<CityBloc>(context);
    detailShipmentBloc = BlocProvider.of<DetailShipmentBloc>(context);
    cancelReasonBloc = BlocProvider.of<CancelReasonBloc>(context);
//    shipmentBloc.dispatch(FetchShipmentEvent());
    _scrollController.addListener(_onScroll);

    controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    scale = Tween<double>(
      begin: 1.5,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn
      ),
    );
    translation = Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear
      ),
    );
    rotation = Tween<double>(
      begin: 0.0,
      end: 360.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.3, 0.9,
          curve: Curves.decelerate,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

//  _open() {
//    controller.forward();
//  }
//
//  _close() {
//    controller.reverse();
//  }
//
//  _buildActionBtn(double angle, { Color color, IconData icon }) {
//    final double rad = radians(angle);
//    return Transform(
//      transform: Matrix4.identity()..translate(
//        (translation.value) * cos(rad),
//        (translation.value) * sin(rad)
//      ),
//
//      child: FloatingActionButton(
//        child: Icon(icon), backgroundColor: color, onPressed: _close, elevation: 0)
//
//    );
//  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      shipmentBloc.dispatch(LoadMoreShipmentEvent());
    }
  }

  void _showFilterShipment(state) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return FilterDialog(shipmentBloc: shipmentBloc, state: state);
      });
  }

  _fillDataFormShipment (type, item) {
    navigationBloc.dispatch(CreateShipmentNavigationEvent(
      type: type,
      shipment: item,
      redirectDetail: false
    ));
    createShipmentBloc.dispatch(UpdatePickerEvent(
      isSelectedPicker: true,
      selectedPickerName: item.pickerName,
      selectedPickerPhone: item.pickerPhone,

      selectedFromAddress: item.fromAddress,
      selectedFromCityCode: item.fromCityCode,
      selectedFromDistrictCode: item.fromDistrictCode,
      selectedFromWardCode: item.fromWardCode,
    ));

    if (type == 'update') {
      createShipmentBloc.dispatch(UpdateInfoReceiverCreateShipmentEvent(
        isUpdateReceiver: true,
        receiverName: item.receiverName,
        receiverPhone: item.receiverPhone,
        toAddress: item.toAddress,
        toCityCode: item.toCityCode,
        toDistrictCode: item.toDistrictCode,
        toWardCode: item.toWardCode,
        toCityName: item.toCityName,
        toDistrictName: item.toDistrictName,
        toWardName: item.toWardName,
        enableSelectWard: true,
      ));
      createShipmentBloc.dispatch(ChangeRateIDCreateShipmentEvent(
        rateID: item.rateId,
        rateName: item.rateName
      ));
    }
  }
  _listShipment(state) {
    List actions = <Widget>[];
    for (int i = 0; i < state.shipments.length; i++) {
      var item = state.shipments[i];
      actions.add(
        new Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FlatButton(
            onPressed: () {
              detailShipmentBloc.dispatch(FetchDetailShipmentEvent(codeShipment: item.code));
              navigationBloc.dispatch(DetailShipmentNavigationEvent(
                eventBack: ChangeIndexPageEvent(index: 1, loadedShipmentState: loadedShipmentState))
              );
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Text(
                              '${item.code}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff213f9a)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            decoration: BoxDecoration(
                              color: ( item.statusColor != '#000')
                              ? Color(int.tryParse('${item.statusColor}'.substring(1, 7), radix: 16) + 0xFF000000)
                              : Color(0xff000000),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Text(
                              '${item.statusTxt}',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
//                          AnimatedBuilder(
//                            animation: controller,
//                            builder: (context, builder) {
//                              return Transform.rotate(
//                                angle: radians(rotation.value),
//                                child: Container(
//                                  height: 30,
//                                  child: Stack(
//                                    alignment: Alignment.center,
//                                    children: [
//                                      _buildActionBtn(180, color: Colors.indigo, icon:FontAwesomeIcons.paw),
//                                      _buildActionBtn(135, color: Colors.pink, icon: FontAwesomeIcons.bong),
//                                      _buildActionBtn(90, color: Colors.yellow, icon:FontAwesomeIcons.bolt),
//                                      Transform.scale(
//                                        scale: scale.value - 1.5, // subtract the beginning value to run the opposite animation
//                                        child: Container(
//                                          height: 20,
//                                          child: FloatingActionButton(
//                                            child: Icon(Icons.clear, size: 15, color:  Colors.black),
//                                            onPressed: _close,
//                                            backgroundColor: Colors.red
//                                          ),
//                                        ),
//                                      ),
//
//                                      Transform.scale(
//                                        scale: scale.value,
//                                        child:Container(
//                                          height: 20,
//                                          child: FloatingActionButton(
//                                            backgroundColor: Colors.white,
//                                            child: Icon(Icons.add, size: 16, color:  Colors.black),
//                                            onPressed: _open
//                                          ),
//                                        ),
//                                      )
//                                    ]),
//                                ),
//                              );
//                            }
//                          ),
                          IconButton(
                            onPressed: () {
                              _fillDataFormShipment('copy', item);
                            },
                            icon: Icon(
                              Icons.content_copy,
                              size: 15,
                              color: Colors.black,
                            ),
                          ),
                          (item.status == 'draft') ?
                            PopupMenuButton<String>(
                            icon: Icon(
                              FontAwesomeIcons.ellipsisV,
                              size: 14,
                              color: Colors.black),
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _fillDataFormShipment('update', item);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon( FontAwesomeIcons.edit, size: 14, color: Colors.black),
                                        Text('Sửa vận đơn')
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      return
                                        showGeneralDialog(
                                          barrierColor: Colors.black.withOpacity(0.5),
                                          transitionBuilder: (context, a1, a2, widget) {
                                            return Center(
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                children: <Widget>[
                                                  CupertinoAlertDialog(
                                                    title: Text('Thông báo'),
                                                    content: RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                                        text: 'Bạn có chắc chắn muốn gửi vận đơn ',
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: '${item.code}',
                                                            style: TextStyle(fontWeight: FontWeight.bold)
                                                          ),
                                                          TextSpan(text: '?'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        child: new Text('Không', style: TextStyle(color: colorPrimary)),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        child: Text('Đồng ý', style: TextStyle(color: colorPrimary)),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          shipmentBloc.dispatch(SendShipmentEvent(codeShipment: item.code));
                                                          shipmentBloc.dispatch(RefreshShipmentEvent());
                                                          listStatusBloc.dispatch(DisplayIconListStatusEvent(isShowIcon: false, status: ''));
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          transitionDuration: Duration(milliseconds: 200),
                                          barrierDismissible: true,
                                          barrierLabel: '',
                                          context: context,
                                          // ignore: missing_return
                                          pageBuilder: (context, animation1, animation2) {});
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.telegramPlane, size: 16,),
                                        Text('Gửi vận đơn')
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      return
                                        showGeneralDialog(
                                          barrierColor: Colors.black.withOpacity(0.5),
                                          transitionBuilder: (context, a1, a2, widget) {
                                            return Center(
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                children: _modalDeleteRequest(item),
                                              ),
                                            );
                                          },
                                          transitionDuration: Duration(milliseconds: 200),
                                          barrierDismissible: true,
                                          barrierLabel: '',
                                          context: context,
                                          // ignore: missing_return
                                          pageBuilder: (context, animation1, animation2) {});
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.trashAlt, size: 16,),
                                        Text('Hủy vận đơn')
                                      ],
                                    ),
                                  ),
                                ),
                              ];
                            },
                          )
                            : (item.status == 'pickup' || item.status == 'picking_up'
                              || item.status == 'picked_up' || item.status == 'delivering') ?
                            IconButton(
                            onPressed: () {
                              return showGeneralDialog(
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionBuilder: (context, a1, a2, widget) {
                                  return Center(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: _modalDeleteRequest(item),
                                    ),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 200),
                                barrierDismissible: true,
                                barrierLabel: '',
                                context: context,
                                // ignore: missing_return
                                pageBuilder: (context, animation1, animation2) {});
                            },
                            icon: Icon(FontAwesomeIcons.trashAlt, size: 16),
                          )
                            : Container(),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                                child: Icon(
                                  FontAwesomeIcons.user,
                                  color: Colors.black,
                                  size: 15,
                                ),
                              ),
                              Text(
                                '${item.receiverName}' +
                                    ' - ' '${item.receiverPhone}',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                                child: Icon(
                                  FontAwesomeIcons.borderAll,
                                  size: 14,
                                ),
                              ),
                              Text('${formatMoney.format(double.parse('${item.feeTotalPayer}'))}' + ' đ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                                child: Icon(
                                  FontAwesomeIcons.flag,
                                  size: 15,
                                ),
                              ),
                              Text(
                                '${item.rateName}',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    actions.add(state.pagination.currentPage < state.pagination.totalPages
        ? BottomLoader()
        : Container());
    return actions;
  }

  _modalDeleteRequest(item) {
    List actions = <Widget>[];
    actions.add(
      Container(),
    );
    if(item.status == 'draft' || item.status == 'pickup' || item.status == 'picking_up') {
      actions.add(
        CupertinoAlertDialog(
          title: Text('Thông báo'),
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              text: 'Bạn có chắc muốn hủy vận đơn ',
              children: <TextSpan>[
                TextSpan(
                  text: '${item.code}',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextSpan(text: '?'),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: new Text('Không', style: TextStyle(color: colorPrimary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Đồng ý', style: TextStyle(color: colorPrimary)),
              onPressed: () {
                Navigator.of(context).pop();
                shipmentBloc.dispatch(DeleteShipmentEvent(codeShipment: item.code));
                shipmentBloc.dispatch(RefreshShipmentEvent());
                listStatusBloc.dispatch(DisplayIconListStatusEvent(isShowIcon: false, status: ''));
              },
            )
          ],
        ),
      );
    }
    if (item.status == 'picked_up' || item.status == 'delivering') {
      actions.add(
        MyDialog(item: item),
      );
    }
    return actions;
  }

  Widget _buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0,
      backgroundColor: Colors.white,
      title: makeTopAppbar(),
      bottom: makeBottomAppbar(),
    );
  }

  Widget makeTopAppbar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              cursorColor: colorPrimary,
              controller: _controller,
              autocorrect: false,
              onChanged: (searchText) {
                _filterShipment();
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                suffix: Container(
                  width: 40,
                  child: FlatButton(
                    shape: CircleBorder(),
                    onPressed: () {
                      _controller.clear();
                      FocusScope.of(context).requestFocus(new FocusNode());
                      shipmentBloc.dispatch(SearchShipmentEvent(q: ''));
                    },
                    child: Icon(
                      FontAwesomeIcons.times,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorPrimary)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorGray)),
                hintText: "Tìm kiếm vận đơn",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeBottomAppbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: Container(
        padding: EdgeInsets.only(left: 5),
        color: Color(0xfff2f5f5),
        child: BlocBuilder<ShipmentBloc, ShipmentState>(
        builder: (context, state) {
          if (state is LoadedShipmentState) {
            return new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () {
                        _showFilterShipment(state);
                      },
                      icon: Icon(
                        FontAwesomeIcons.filter,
                        size: 13,
                      ),
                      label: Text(
                        'Bộ lọc' + '${
                          state.filterShipment != null
                          ? ' (' + state.countFilter + ')'
                          : ' (0)'
                        }',
                        style: TextStyle(fontSize: 16)
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                      Container(),
//                    Container(
//                      child: Row(
//                        children: <Widget>[
//                          IconButton(
//                            onPressed: () {},
//                            icon: Icon(
//                              FontAwesomeIcons.print,
//                              size: 16,
//                              color: Colors.black,
//                            ),
//                          ),
//                          IconButton(
//                            onPressed: () {},
//                            icon: Icon(
//                              FontAwesomeIcons.fileExcel,
//                              size: 17,
//                              color: Colors.black,
//                            ),
//                          ),
//                          MaterialButton(
//                            onPressed: () async {
//                              final List<
//                                DateTime> picked = await DateRagePicker
//                                .showDatePicker(
//                                context: context,
//                                initialFirstDate: new DateTime.now(),
//                                initialLastDate: (new DateTime.now()).add(
//                                  new Duration(days: 7)),
//                                firstDate: new DateTime(2019),
//                                lastDate: new DateTime(2030)
//                              );
//                              if (picked != null && picked.length == 2) {
//                                print(picked);
//                              }
//                            },
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(FontAwesomeIcons.calendarAlt, size: 15),
//                                Text(' 01/01-11/11',
//                                  style: TextStyle(fontSize: 14))
//                              ],
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
                  ],
                )
              ],
            );
          }
          return new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Container(
                    child: Row(
                      children: <Widget>[
                        new MaterialButton(
                          onPressed: () async {

                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        }),
      )
    );
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
        child: Scaffold(
          backgroundColor: Color(0xfff2f5f5),
          appBar: _buildAppBar(),
          body: BlocBuilder<ShipmentBloc, ShipmentState>(
            builder: (context, state) {
              if (state is FailureShipmentState) {
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 205,
                      alignment: Alignment.center,
                      child: Text('Tải danh sách thất bại. Vuốt xuống để thử lại.'),
                    ),
                  ),
                );
              }
              if (state is LoadingShipmentState) {
                return Center(
                  child: LoaderTwo(),
                );
              }
              if (state is LoadedShipmentState) {
                if (state.isLoadingFilter) {
                  return Center(
                    child: LoaderTwo(),
                  );
                }
                if (state.shipments.isEmpty) {
                  if (!state.isFetchFilter) {
                    if (!state.isFetchDraft && state.isFetched) {
                      _fetchDraft(context);
                    }
//                  else {
//                    return Container(color: Colors.red);
//                  }
                    shipmentBloc.dispatch(FetchDraftShipmentEvent());
                  }
                  return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 205,
                        alignment: Alignment.center,
                        child: Text('Không có dữ liệu. Vuốt xuống để thử lại.'),
                      ),
                    )
                  );
                }

                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    children: _listShipment(state),
                  ),
                );
              }
              return Center(
                child: Container(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: LoaderTwo()
         ),
      ),
    );
  }
}
