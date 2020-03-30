import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/city/bloc.dart';
import 'package:app_customer/bloc/city/city_bloc.dart';
import 'package:app_customer/bloc/city/city_event.dart';
import 'package:app_customer/bloc/create_shipment/bloc.dart';
import 'package:app_customer/bloc/district/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/ward/bloc.dart';
import 'package:app_customer/bloc/contact_place/bloc.dart';
import 'package:app_customer/repositories/city/city_repository.dart';
import 'package:app_customer/repositories/district/district_repository.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:app_customer/repositories/ward/ward_repository.dart';
import 'package:app_customer/screens/components/circular_color.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateReceiverFormPage extends StatelessWidget {
  final CityRepository cityRepository;
  final DistrictRepository districtRepository;
  final WardRepository wardRepository;
  final Shipment shipment;

  CreateReceiverFormPage({Key key,
    this.cityRepository,
    this.districtRepository,
    this.wardRepository,
    this.shipment,
  }) :
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
        ],
        child: MainCreateReceiverForm(shipment: shipment),
      )
    );
  }
}

class MainCreateReceiverForm extends StatefulWidget {
  final Shipment shipment;

  MainCreateReceiverForm({
    Key key,
    this.shipment,
  });

  @override
  _MainCreateReceiverFormState createState() => _MainCreateReceiverFormState(shipment: shipment);
}

class _MainCreateReceiverFormState extends State<MainCreateReceiverForm> {
  final Shipment shipment;

  _MainCreateReceiverFormState({
    Key key,
    this.shipment,
  });

  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;
  CityBloc cityBloc;
  DistrictBloc districtBloc;
  WardBloc wardBloc;
  ContactPlaceBloc contactPlaceBloc;
  CreateShipmentBloc createShipmentBloc;

  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  final _toAddressController = TextEditingController();
  final _citySearchController = TextEditingController();
  final _districtSearchController = TextEditingController();
  final _wardSearchController = TextEditingController();

  final FocusNode _receiverNameFocus = FocusNode();
  final FocusNode _receiverPhoneFocus = FocusNode();
  final FocusNode _toAddressFocus = FocusNode();

  final _infoReceiverCreateShipmentForm = GlobalKey<FormState>();

  bool _autoValidateFrom = false;

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    createShipmentBloc = BlocProvider.of<CreateShipmentBloc>(context);
    cityBloc = BlocProvider.of<CityBloc>(context);
    districtBloc = BlocProvider.of<DistrictBloc>(context);
    wardBloc = BlocProvider.of<WardBloc>(context);

    if (shipment != null) {
      districtBloc.dispatch(FetchDistrictEvent(selectedCityCode: shipment.toCityCode));
      wardBloc.dispatch(FetchWardEvent(selectedDistrictCode: shipment.toDistrictCode));
    }
  }

  @override
  void dispose() {
    _receiverNameFocus.dispose();
    _receiverPhoneFocus.dispose();
    _toAddressFocus.dispose();
    _citySearchController.dispose();
    _districtSearchController.dispose();
    _wardSearchController.dispose();
    super.dispose();
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _onUpdateReceiverButtonPress(state) {
    if (_infoReceiverCreateShipmentForm.currentState.validate()) {
      createShipmentBloc.dispatch(UpdateInfoReceiverCreateShipmentEvent(
        isUpdateReceiver: true,
        receiverName: _receiverNameController.text,
        receiverPhone: _receiverPhoneController.text,
        toAddress: _toAddressController.text
      ));

      if (state.shipment.toCityCode == '') {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.WARNING,
          message: 'Vui lòng chọn Tỉnh/thành phố'));
        return;
      }
      if (state.shipment.toDistrictCode == '') {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.WARNING,
          message: 'Vui lòng chọn Quận/Huyện'));
        return;
      }
      if (state.shipment.toWardCode == '') {
        notifyBloc.dispatch(ShowNotifyEvent(
          type: NotifyEvent.WARNING,
          message: 'Vui lòng chọn Phường/Xã'));
        return;
      }
      Navigator.of(context).pop();
    } else {
      setState(() {
        _autoValidateFrom = true;
      });
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.WARNING,
        message: 'Vui lòng kiểm tra lại thông tin cần nhập'));
    }
  }

  Widget _buildInputSearchCity() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48.0),
      child: Container(
        height: 50,
        color: colorBackground,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  cursorColor: colorPrimary,
                  controller: _citySearchController,
                  autocorrect: false,
                  onChanged: (searchText) {
                    cityBloc.dispatch(SearchCityEvent(q: searchText));
//                    _filterContactPlace();
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffix: Container(
                      width: 40,
                      child: FlatButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          _citySearchController.clear();
                          cityBloc.dispatch(SearchCityEvent(q: ''));
                        },
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
//                      suffix: IconButton(
//                        icon: Icon(Icons.close, size: 16),
//                        onPressed: () {
//                          _citySearchController.clear();
//                          contactPlaceBloc.dispatch(FilterContactPlaceEvent(q: ''));
//                        }
//                      ),
                    contentPadding: EdgeInsets.only(top: 15.0),
                    prefixIcon: Icon(Icons.search, color: colorDarkGray),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorPrimary)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorGray)),
                    hintText: "Nhập Tỉnh/Thành phố cần tìm",
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  Widget _buildInputSearchDistrict() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48.0),
      child: Container(
        height: 50,
        color: colorBackground,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  cursorColor: colorPrimary,
                  controller: _districtSearchController,
                  autocorrect: false,
                  onChanged: (searchText) {
                    districtBloc.dispatch(SearchDistrictEvent(q: searchText));
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffix: Container(
                      width: 40,
                      child: FlatButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          _districtSearchController.clear();
                          districtBloc.dispatch(SearchDistrictEvent(q: ''));
                        },
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 15.0),
                    prefixIcon: Icon(Icons.search, color: colorDarkGray),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorPrimary)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorGray)),
                    hintText: "Nhập Quận/Huyện cần tìm",
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  Widget _buildInputSearchWard() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48.0),
      child: Container(
        height: 50,
        color: colorBackground,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  cursorColor: colorPrimary,
                  controller: _wardSearchController,
                  autocorrect: false,
                  onChanged: (searchText) {
                    wardBloc.dispatch(SearchWardEvent(q: searchText));
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffix: Container(
                      width: 40,
                      child: FlatButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          _wardSearchController.clear();
                          wardBloc.dispatch(SearchWardEvent(q: ''));
                        },
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 15.0),
                    prefixIcon: Icon(Icons.search, color: colorDarkGray),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorPrimary)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorGray)),
                    hintText: "Nhập Phường/Xã cần tìm",
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _showModalCity() {
    showModalBottomSheet<Null>(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: new AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            backgroundColor: Colors.white,
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.close, color: Colors.black, size: 20),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: _buildInputSearchCity(),
            title: Text('Tỉnh/Thành phố', style: TextStyle(
              fontSize: 16,
              color: Colors.black
            )),
          ),
          body: BlocBuilder<CityBloc, CityState>(
            bloc: null,
            builder: (context, state) {
              if (state is LoadingCityState) {
                return Container(
                  height: 300,
                  child: Center(
                    child: LoaderTwo(),
                  ),
                );
              }
              if (state is FailureCityState) {
                return Center(child: Text("Có lỗi xảy ra, vui lòng thử lại"));
              }
              if (state is LoadedCityState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: state.cities.map((item) {
                      return new ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          createShipmentBloc.dispatch(UpdateCityCreateShipmentEvent(
                            selectedCityCode: item.code,
                            selectedCityName: item.name,
                            enableSelectDistrict: true
                          ));
                          districtBloc.dispatch(FetchDistrictEvent(selectedCityCode: item.code));
                          _showModalDistrict();
                          _citySearchController.clear();
                          cityBloc.dispatch(SearchCityEvent(q: ''));
                        },
                        dense: true,
                        title: Text(item.name),
                      );
                    }).toList()),
                );
              }
              return Container();
            }
          ),
        );
      }
    );
  }
  void _showModalDistrict() {
    showModalBottomSheet<Null>(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: new AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            backgroundColor: Colors.white,
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.navigate_before, color: Colors.black, size: 20),
              onPressed: () {
                Navigator.pop(context);
                _showModalCity();
              },
            ),
            bottom: _buildInputSearchDistrict(),
            title: Text('Quận/Huyện', style: TextStyle(
              fontSize: 16,
              color: Colors.black
            )),
          ),
          body: new BlocBuilder<DistrictBloc, DistrictState>(
            bloc: districtBloc,
            builder: (content, state) {
              if (state is LoadingDistrictState) {
                return Container(
                  height: 300,
                  child: Center(
                    child: LoaderTwo(),
                  ),
                );
              }
              if (state is FailureDistrictState) {
                return Center(child: Text("Có lỗi xảy ra, vui lòng thử lại"));
              }
              if (state is LoadedDistrictState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: state.districts.map((item) {
                      return ListTile(
                        onTap: () {
                          wardBloc.dispatch(FetchWardEvent(selectedDistrictCode: item.code));
                          createShipmentBloc.dispatch(UpdateDistrictCreateShipmentEvent(
                            selectedDistrictCode: item.code,
                            selectedDistrictName: item.name,
                            enableSelectWard: true
                          ));
                          Navigator.pop(context);
                          _showModalWard();
                          createShipmentBloc.dispatch(FetchRateCreateShipmentEvent());
                          _districtSearchController.clear();
                          districtBloc.dispatch(SearchDistrictEvent(q: ''));
                        },
                        dense: true,
                        title: Text(item.name),
                      );
                    }).toList()),
                );
              }
              return Container();
            },
          ),
        );
      }
    );
  }

  void _showModalWard() {
    showModalBottomSheet<Null>(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: new AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            backgroundColor: Colors.white,
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.navigate_before, color: Colors.black, size: 20),
              onPressed: () {
                Navigator.pop(context);
                _showModalDistrict();
              },
            ),
            bottom: _buildInputSearchWard(),
            title: Text('Phường/Xã', style: TextStyle(
              fontSize: 16,
              color: Colors.black
            )),
          ),
          body: new BlocBuilder<WardBloc, WardState>(
            bloc: wardBloc,
            builder: (content, state) {
              if (state is LoadingWardState) {
                return Container(
                  height: 300,
                  child: Center(
                    child: LoaderTwo(),
                  ),
                );
              }
              if (state is FailureWardState) {
                return Center(child: Text("Có lỗi xảy ra, vui lòng thử lại"));
              }
              if (state is LoadedWardState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: state.wards.map((item) {
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          createShipmentBloc.dispatch(UpdateWardCreateShipmentEvent(
                            selectedWardCode: item.code,
                            selectedWardName: item.name
                          ));
                          _wardSearchController.clear();
                          wardBloc.dispatch(SearchWardEvent(q: ''));
                        },
                        dense: true,
                        title: Text(item.name),
                      );
                    }).toList()),
                );
              }
              return Container();
            },
          ),
        );
      }
    );
  }
  Widget _buildSelectCity() {
    return BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
      bloc: createShipmentBloc,
      builder: (context, state) {
        if (state is LoadedCreateShipmentState) {
          return ListTile(
            title: Text('Tỉnh/Thành phố',
              style: TextStyle(
                color: Colors.black)),
            subtitle: Text(state.shipment.toCityName != null ? '${state.shipment.toCityName}' : ''),
            dense: true,
            trailing: Icon(Icons.keyboard_arrow_down,
              color: Colors.black),
            onTap: () {
              cityBloc.dispatch(FetchCityEvent());
              FocusScope.of(context).requestFocus(new FocusNode());
              _showModalCity();
            },
          );
        } else {
          return Container(
            child: Text('Có lỗi xảy ra'),
          );
        }
      }
    );
  }
  Widget _buildSelectDistrict() {
    return BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
      bloc: createShipmentBloc,
      builder: (context, state) {
        if (state is LoadedCreateShipmentState) {
          return ListTile(
            title: Text('Quận/Huyện',
              style: TextStyle(
                color: Colors.black)),
            subtitle: Text(state.shipment.toDistrictName != null ? '${state.shipment.toDistrictName}' : ''),
            dense: true,
            trailing: Icon(Icons.keyboard_arrow_down,
              color: Colors.black),
            onTap: state.enableSelectDistrict ? () {
              _showModalDistrict();
            } : () {
              notifyBloc.dispatch(ShowNotifyEvent(
                type: NotifyEvent.WARNING,
                message: 'Vui lòng chọn Thành phố'));
            },
          );
        } else {
          return Container();
        }
      }
    );
  }
  Widget _buildSelectWard() {
    return BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
      bloc: createShipmentBloc,
      builder: (context, state) {
        if (state is LoadedCreateShipmentState) {
          return ListTile(
            title: Text('Phường/Xã',
              style: TextStyle(
                color: Colors.black)),
            subtitle: Text(state.shipment.toWardName != null ? '${state.shipment.toWardName}' : ''),
            dense: true,
            trailing: Icon(Icons.keyboard_arrow_down,
              color: Colors.black),
            onTap: state.enableSelectWard ? () {
              _showModalWard();
            } : () {
              notifyBloc.dispatch(ShowNotifyEvent(
                type: NotifyEvent.WARNING,
                message: 'Vui lòng chọn Quận/Huyện'));
            },
          );
        } else {
          return Container();
        }
      }
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0.5,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text("Thông tin người nhận",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16
        )),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
          createShipmentBloc.dispatch(ClearStateCreateShipmentEvent());
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
    );
  }
  Widget _buildContent() {
    return SingleChildScrollView(
      child: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
        bloc: createShipmentBloc,
        builder: (context, state) {
          if (state is LoadedCreateShipmentState) {
            if (state.shipment.receiverName != "" && _receiverNameController.text == '') {
              _receiverNameController.text = '${state.shipment.receiverName}';
            }
            if (state.shipment.receiverPhone != "" && _receiverPhoneController.text == '') {
              _receiverPhoneController.text = '${state.shipment.receiverPhone}';
            }
            if (state.shipment.toAddress != "" && _toAddressController.text == '') {
              _toAddressController.text = '${state.shipment.toAddress}';
            }
            return new Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: Form(
                  key: _infoReceiverCreateShipmentForm,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                child: Theme(
                                  data: Theme.of(context)
                                    .copyWith(splashColor: Colors.transparent),
                                  child: TextFormField(
                                    autofocus: false,
                                    cursorColor: colorPrimary,
                                    controller: _receiverNameController,
                                    textCapitalization: TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: colorPrimary)),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: colorGray)),
                                      isDense: true,
                                      labelText: 'Tên người nhận',
                                      labelStyle: TextStyle(color: Colors.black)),
                                    focusNode: _receiverNameFocus,
                                    autovalidate: _autoValidateFrom,
                                    autocorrect: false,
                                    validator: (_) {
                                      if (_.isEmpty) {
                                        return 'Vui lòng nhập Tên người nhận';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                        context, _receiverNameFocus, _receiverPhoneFocus);
                                    }),
                                ),
                              ),
                              new Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Theme(
                                    data: Theme.of(context)
                                      .copyWith(splashColor: Colors.transparent),
                                    child: TextFormField(
                                      cursorColor: colorPrimary,
                                      controller: _receiverPhoneController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: colorPrimary)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: colorGray)),
                                        isDense: true,
                                        labelText: 'Số điện thoại',
                                        labelStyle:
                                        TextStyle(color: Colors.black)),
                                      maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      focusNode: _receiverPhoneFocus,
                                      autovalidate: _autoValidateFrom,
                                      autocorrect: false,
                                      validator: (_) {
                                        if (_.isEmpty) {
                                          return 'Vui lòng nhập SĐT';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (term) {
                                        _fieldFocusChange(
                                          context, _receiverPhoneFocus, _toAddressFocus);
                                      }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: new Theme(
                          data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 2,
                            cursorColor: colorPrimary,
                            controller: _toAddressController,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              isDense: true,
                              labelText: 'Địa chỉ',
                              labelStyle: TextStyle(color: Colors.black)),
                            focusNode: _toAddressFocus,
                            autovalidate: _autoValidateFrom,
                            autocorrect: false,
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Vui lòng nhập Địa chỉ';
                              }
                              return null;
                            },
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                context, _toAddressFocus, FocusNode());
                            }
                          ),
                        ),
                      ),
                      _buildSelectCity(),
                      Divider(height: 0),
                      _buildSelectDistrict(),
                      Divider(height: 0),
                      _buildSelectWard(),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        }
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
      child: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
        bloc: createShipmentBloc,
        builder: (context, state) {
          if (state is LoadedCreateShipmentState) {
            return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: colorAccent,
              child: Text(
                'Tiếp tục',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _onUpdateReceiverButtonPress(state);
              },
            );
          }
          return Container();
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        new BlocListener<ContactPlaceBloc, ContactPlaceState>(
          bloc: contactPlaceBloc,
          listener: (context, state) {
            if (state is LoadedContactPlaceState) {
              if (state.isSuccess) {
                if  (state.contactPlace.id != null) {
                }
                Navigator.of(context).pop();
              }
            }
          },
        ),
        new BlocListener<AuthenticationBloc, AuthenticationState>(
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
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: _buildContent(),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }
}
