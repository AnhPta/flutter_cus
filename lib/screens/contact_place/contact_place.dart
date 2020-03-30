import 'package:app_customer/repositories/contact_place/contact_place.dart';
import 'package:app_customer/screens/contact_place/contact_place_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPlaceFormPage extends StatelessWidget {
  final ContactPlace contactPlace;
  final String type;

  final ValueChanged<ContactPlace> createSuccess;

  ContactPlaceFormPage({Key key,
    ValueChanged<ContactPlace> createSuccess,
    this.contactPlace,
    this.type,
  }) :
      createSuccess = createSuccess,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
//          BlocProvider<DistrictBloc>(
//            builder: (BuildContext context) => DistrictBloc(
//              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
//              districtRepository: districtRepository
//            ),
//          ),
//          BlocProvider<WardBloc>(
//            builder: (BuildContext context) => WardBloc(
//              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
//              wardRepository: wardRepository
//            ),
//          ),
        ],
        child: MainContactPlaceForm(createSuccess: createSuccess, contactPlace: contactPlace, type: type),
      )
    );
  }
}
