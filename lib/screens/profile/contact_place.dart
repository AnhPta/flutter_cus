import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/repositories/contact_place/contact_place_repository.dart';
import 'package:app_customer/screens/contact_place/contact_place_list.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPlaceBoxPage extends StatefulWidget {
  ContactPlaceBoxPage({Key key, this.title = 'ContactPlaceBox'}) : super(key: key);
  final String title;

  @override
  _ContactPlaceBoxPageState createState() => _ContactPlaceBoxPageState();
}

class _ContactPlaceBoxPageState extends State<ContactPlaceBoxPage> {
  NavigationBloc navigationBloc;
  final ContactPlaceRepository contactPlaceRepository = ContactPlaceRepository();
  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
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
    ], child: _buildContactPlace(context));
  }

  Widget _buildContactPlace(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (ctx) => GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: ContactPlaceListPage(
                contactPlaceRepository: contactPlaceRepository
              ),
            ),
          ),
        );
      },
      child: Padding(
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
                        Icons.location_on,
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
                  new Padding(
                    padding: EdgeInsets.fromLTRB(13, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Điểm lấy/trả hàng',
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Thêm, cập nhật điểm lấy/trả hàng của bạn',
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
