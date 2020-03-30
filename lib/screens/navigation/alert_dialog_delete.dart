import 'package:app_customer/bloc/cancel_reason/bloc.dart';
import 'package:app_customer/bloc/list_status/bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:app_customer/bloc/shipment/bloc.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDialog extends StatefulWidget {
  final item;
  MyDialog({
    Key key,
    this.item,
  }) : super(key: key);
  @override
  _MyDialogState createState() => _MyDialogState(item: item);
}

class _MyDialogState extends State<MyDialog> {
  final item;
  _MyDialogState({
    Key key,
    this.item,
  });

  NavigationBloc navigationBloc;
  CancelReasonBloc cancelReasonBloc;
  ShipmentBloc shipmentBloc;
  ListStatusBloc listStatusBloc;
  String selectedState ;
  final reasonController = TextEditingController();
  bool _autoValidateFrom = false;

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    shipmentBloc = BlocProvider.of<ShipmentBloc>(context);
    listStatusBloc = BlocProvider.of<ListStatusBloc>(context);
    cancelReasonBloc = BlocProvider.of<CancelReasonBloc>(context);
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Thông báo'),
      content: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BlocBuilder<ShipmentBloc, ShipmentState>(
              bloc: shipmentBloc,
              builder: (context, state) {
                return Container(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      text: 'Bạn có muốn gửi yêu cầu hủy vận đơn ',
                      children: <TextSpan>[
                        TextSpan(
                          text: '${item.code}',
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(text: '?'),
                      ],
                    ),
                  ),
                );
              }
            ),
            BlocBuilder<CancelReasonBloc, CancelReasonState>(
              bloc: cancelReasonBloc,
              builder: (context, state) {
                if (state is LoadedCancelReasonState) {
                  return DropdownButtonFormField(
                    hint: Text('Chọn lý do hủy'),
                    value: selectedState,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent))),
                    items: state.reason.map((value) => DropdownMenuItem(
                      child: Text(value.name),
                      value: value.code,
                    )).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _autoValidateFrom = false;
                        selectedState = value;
                      });
                    },
                  );
                }
                return Container();
              }
            ),
            (selectedState == 'OTHER') ?
            TextFormField(
              autovalidate: _autoValidateFrom,
              autocorrect: false,
              validator: (_) {
                if (_.isEmpty) {
                  return 'Vui lòng nhập lý do hủy';
                }
                return null;
              },
              controller: reasonController,
              textInputAction: TextInputAction.next,
              maxLines: 5,
              cursorColor: colorPrimary,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorPrimary)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorGray)),
                hintText: "Nhập lý do...",
                labelStyle: TextStyle(color: Colors.black),
              ),
            ) : Container(),
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
            if(selectedState == 'OTHER') {
              setState(() {
                _autoValidateFrom = true;
              });
            }
            shipmentBloc.dispatch(SendRequestCancelShipmentEvent(
              codeShipment: item.code,
              codeReason: selectedState,
              reasonTxt: reasonController.text
            ));
            shipmentBloc.dispatch(RefreshShipmentEvent());
            navigationBloc.dispatch(ChangeIndexPageEvent(index: 1));
            listStatusBloc.dispatch(DisplayIconListStatusEvent(isShowIcon: false, status: ''));
          },
        )
      ],
    );
  }
}
