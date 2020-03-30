import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:app_customer/screens/create_shipment/create_shipment_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateShipmentPage extends StatelessWidget {
  final Shipment shipment;
  final String type;
  final bool redirectDetail;

  CreateShipmentPage({
    Key key,
    this.shipment,
    this.type,
    this.redirectDetail,
  }) :
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [],
      child: CreateShipmentFormPage(shipment: shipment, type: type, redirectDetail: redirectDetail),
    );
  }
}
