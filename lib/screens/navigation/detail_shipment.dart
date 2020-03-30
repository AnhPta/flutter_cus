import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/cancel_reason/bloc.dart';
import 'package:app_customer/bloc/create_shipment/bloc.dart';
import 'package:app_customer/bloc/detail_shipment/bloc.dart';
import 'package:app_customer/bloc/list_status/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/shipment/bloc.dart';
import 'package:app_customer/screens/components/circular_color.dart';
import 'package:app_customer/screens/navigation/alert_dialog_delete.dart';
import 'package:app_customer/screens/navigation/tabbar_view_detail_shipment.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailShipmentPage extends StatelessWidget {
  final NavigationEvent eventBack;

  DetailShipmentPage({
    Key key,
    this.eventBack,
  }) :
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainDetailShipment(eventBack: eventBack));
  }
}

class MainDetailShipment extends StatefulWidget {
  final NavigationEvent eventBack;
  MainDetailShipment({
    Key key,
    this.eventBack,
  }) :
      assert(eventBack != null),
      super(key: key);

  @override
  _MainDetailShipmentState createState() => _MainDetailShipmentState(eventBack: eventBack);
}

class _MainDetailShipmentState extends State<MainDetailShipment> {
  final NavigationEvent eventBack;
  _MainDetailShipmentState({
    Key key,
    this.eventBack,
  }) : assert(eventBack != null);

  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;
  DetailShipmentBloc detailShipmentBloc;
  ShipmentBloc shipmentBloc;
  ListStatusBloc listStatusBloc;
  CreateShipmentBloc createShipmentBloc;
  CancelReasonBloc cancelReasonBloc;
  var sizeIconMat = 14.0;
  var sizeIconFont = 13.0;
  textStyleItalic() {
    return new TextStyle(color: Colors.green, fontStyle: FontStyle.italic);
  }

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    detailShipmentBloc = BlocProvider.of<DetailShipmentBloc>(context);
    cancelReasonBloc = BlocProvider.of<CancelReasonBloc>(context);
    shipmentBloc = BlocProvider.of<ShipmentBloc>(context);
    listStatusBloc = BlocProvider.of<ListStatusBloc>(context);
    createShipmentBloc = BlocProvider.of<CreateShipmentBloc>(context);
    cancelReasonBloc.dispatch(FetchCancelReasonEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          navigationBloc.dispatch(eventBack);
        },
        icon: Icon(Icons.chevron_left, color: colorBlack),
      ),
      title: Text('Chi tiết', style: TextStyle(color: colorBlack, fontSize: 16),),
      actions: <Widget>[
        makeActionAppbar(),
      ],
    );
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
                navigationBloc.dispatch(ChangeIndexPageEvent(index: 1));
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

  _showModalDelete(item) {
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
  }

  _fillDataFormShipment (type, item) {
    navigationBloc.dispatch(CreateShipmentNavigationEvent(
      type: type,
      shipment: item,
      redirectDetail: true
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

  Widget makeActionAppbar() {
    return BlocBuilder<DetailShipmentBloc, DetailShipmentState>(
      bloc: detailShipmentBloc,
      builder: (context, state) {
        if (state is LoadedDetailShipmentState) {
          var item = state.shipment;
          return Container(
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _fillDataFormShipment('copy', item);
                  },
                  icon: Icon(
                    Icons.content_copy,
                    size: sizeIconMat,
                    color: colorBlack,
                  ),
                ),
                (item.status == 'draft') ?
                IconButton(
                  onPressed: () {
                    return showGeneralDialog(
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
                                    text: 'Bạn có chắc muốn gửi vận đơn ',
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
                                      navigationBloc.dispatch(ChangeIndexPageEvent(index: 1));
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
                  icon: Icon(
                    FontAwesomeIcons.telegramPlane,
                    size: 14,
                    color: colorBlack,
                  ),
                )
                  : Container(),
                (item.status == 'draft') ?
                IconButton(
                  onPressed: () {
                    _fillDataFormShipment('update', item);
                  },
                  icon: Icon(
                    FontAwesomeIcons.edit,
                    size: 14,
                    color: colorBlack,
                  ),
                )
                  : Container(),
                (item.status == 'draft'
                  ||item.status == 'delivering'
                  ||item.status == 'picked_up'
                  ||item.status == 'picking_up'
                  ||item.status == 'pickup') ?
                IconButton(
                  onPressed: () {
                    _showModalDelete(item);
                  },
                  icon: Icon(
                    FontAwesomeIcons.trashAlt,
                    size: sizeIconFont,
                    color: colorBlack,
                  ),
                )
                  : Container(),
              ],
            )
          );
        }
        return Container();
      }
    );
  }

  _showTextRate(item) {
    List actions = <Widget>[];
    actions.add(
      Container(),
    );
    if (item.status == 'picked_up' || item.status == 'delivering') {
      actions.add(
        (item.deliveryAt != '')
        ? Text('- Dự kiến giao: ${item.deliveryAt}', style: textStyleItalic())
        : Container()
      );
    }
    if (item.status == 'pickup' || item.status == 'picking_up') {
      actions.add(
        (item.pickupAt != '')
        ? Text('- Dự kiến lấy: ${item.pickupAt}', style: textStyleItalic())
        : Container()
      );
    }
    return actions;
  }

  detailShipment(state) {
    var item = state.shipment;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.box, size: sizeIconFont),
                    Text(
                      '   ${item.code}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                    child:Wrap(
                      children: <Widget>[
                        Text('${item.rateName}', style: textStyleItalic(),),
                        Wrap(
                          children: _showTextRate(item),
                        ),
                      ],
                    )
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(
                      color: ((item.statusColor != null && item.statusColor != '') && item.statusColor != '#000')
                        ? Color(int.parse('${item.statusColor}'.substring(1, 7), radix: 16) + 0xFF000000)
                        : colorBlack
                      )
                  ),
                  child: Text('${item.statusTxt}',
                    style: TextStyle(
                      color: ((item.statusColor != null && item.statusColor != '') && item.statusColor != '#000')
                        ? Color(int.parse('${item.statusColor}'.substring(1, 7), radix: 16) + 0xFF000000)
                        : colorBlack
                      )
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    child: Text(
                      'Địa chỉ giao / nhận',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: Icon(Icons.gps_fixed, size: sizeIconMat, color: colorBlack),
                      ),
                      Expanded(
                        child: Text('${item.fromFullAddress}', style: TextStyle(fontSize: 15, color: colorBlack)),
                      )
                    ],
                  ),
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 15.0,
                      runSpacing: 4.0,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: <Widget>[
                       Chip(
                         backgroundColor: colorChip,
                         avatar: CircleAvatar(child: Icon(Icons.account_circle, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
                         label: Text('${item.pickerName}'),
                       ),
                       Chip(
                         backgroundColor: colorChip,
                         avatar: CircleAvatar(child: Icon(Icons.phone, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
                         label: Text('${item.pickerPhone}'),
                       )
                     ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: Icon(Icons.location_on, size: sizeIconMat, color: colorBlack),
                      ),
                      Expanded(
                        child: Text('${item.toFullAddress}', style: TextStyle(fontSize: 15, color: colorBlack)),
                      )
                    ],
                  ),
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 15.0,
                      runSpacing: 4.0,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: <Widget>[
                       Chip(
                         backgroundColor: colorChip,
                         avatar: CircleAvatar(child: Icon(Icons.account_circle, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
                         label: Text('${item.receiverName}'),
                       ),
                       Chip(
                         backgroundColor: colorChip,
                         avatar: CircleAvatar(child: Icon(Icons.phone, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
                         label: Text('${item.receiverPhone}'),
                       )
                     ],
                    ),
                  ],
                ),
              ],
            )
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    child: Text(
                      'Phí và tiền thu hộ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Phí ship', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${formatMoney.format(double.parse('${item.feeDelivery}'))}' + ' đ'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Phụ phí', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${formatMoney.format(double.parse('${item.feeOtherTotal}'))}' + ' đ'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Phụ phí khác', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${formatMoney.format(double.parse('${item.feeOther}'))}' + ' đ'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('VAT', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('  ${formatMoney.format(double.parse('${item.vat}'))}%', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Text('${formatMoney.format(double.parse('${item.feeVat}'))}' + ' đ'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('Tổng phí', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(' (${item.payerTxt})', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          Text('${formatMoney.format(double.parse('${item.totalFee}'))}' + ' đ', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Tiền thu hộ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${formatMoney.format(double.parse('${item.package.cod}'))}' + ' đ', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),

                    ),
                  ],
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Tiền thu người nhận', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${formatMoney.format(double.parse('${item.feeTotalPayer}'))}' + ' đ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            )
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    child: Text(
                      'Thông tin hàng hóa',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: Icon(Icons.filter_1, size: sizeIconMat, color: colorBlack,),
                      ),
                      Expanded(
                        child: Text('${item.package.name}', style: TextStyle(color: colorBlack)),
                      )
                    ],
                  ),
                  children: <Widget>[
                    Wrap(
                      spacing: 15.0,
                      runSpacing: 4.0,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Chip(
                          backgroundColor: colorChip,
                          avatar: CircleAvatar(child: Icon(Icons.assignment_late, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
                          label: Text('${formatNumber.format(double.parse('${item.package.weight}'))}' + ' kg'),
                        ),
                        Chip(
                          backgroundColor: colorChip,
                          avatar: CircleAvatar(child: Icon(Icons.assignment, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
                          label: Text('${formatNumber.format(double.parse('${item.package.length}'))}'
                            + ' x ' + '${formatNumber.format(double.parse('${item.package.width}'))}'
                            + ' x ' + '${formatNumber.format(double.parse('${item.package.height}'))}'
                          ),
                        ),
                        Chip(
                          backgroundColor: colorChip,
                          avatar: CircleAvatar(child: Icon(Icons.monetization_on, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
                          label: Text('${formatMoney.format(double.parse('${item.package.amount}'))}' + ' đ '),
                        ),
                        Chip(
                          backgroundColor: colorChip,
                          avatar: CircleAvatar(child: Icon(Icons.monetization_on, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
//                          label: Text('${formatMoney.format(double.parse('${item.package.cod}'))}' + ' đ'),
                          label: Text('${item.package.cod}' + ' đ'),
                        ),
                        Chip(
                          backgroundColor: colorChip,
                          avatar: CircleAvatar(child: Icon(Icons.sort, color: colorBlack, size: sizeIconMat),backgroundColor: colorGray,),
                          label: Text('${item.note}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            child: NestedTabBar(),
          )
        ],
      ),
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
          }
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          body: BlocBuilder<DetailShipmentBloc, DetailShipmentState>(
            bloc: detailShipmentBloc,
            builder: (context, state) {
              if (state is FailureDetailShipmentState) {
                return
                  Container(
                    height: 500,
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 50,),
                        Text('Tải vận đơn thất bại!'),
                        FlatButton.icon(
                          onPressed: () {
                            navigationBloc.dispatch(ChangeIndexPageEvent(index: 1));
                          },
                          icon: Icon(Icons.arrow_left),
                          label: Text('Quay lại')
                        )
                      ],
                    ),
                  );
              }
              if (state is LoadingDetailShipmentState) {
                return Center(
                  child: LoaderTwo(),
                );
              }
              if (state is LoadedDetailShipmentState) {
                return Scaffold(
                  backgroundColor: Color(0xfff2f5f5),
                  body: detailShipment(state),
                );
              }
              return Center(
                child: Container(),
              );
            }
          ),
        )
      ),
    );
  }
}

