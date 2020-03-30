import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/city/bloc.dart';
import 'package:app_customer/bloc/city/city_bloc.dart';
import 'package:app_customer/bloc/city/city_event.dart';
import 'package:app_customer/bloc/district/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/ward/bloc.dart';
import 'package:app_customer/bloc/contact_place/bloc.dart';
import 'package:app_customer/repositories/contact_place/contact_place.dart';
import 'package:app_customer/screens/components/circular_color.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainContactPlaceForm extends StatefulWidget {
  final ValueChanged<ContactPlace> createSuccess;
  final ContactPlace contactPlace;
  final String type;
  MainContactPlaceForm({Key key,
    this.createSuccess,
    this.contactPlace,
    this.type,
  });

  @override
  _MainContactPlaceFormState createState() => _MainContactPlaceFormState(
    createSuccess: createSuccess,
    contactPlace: contactPlace,
    type: type,
  );
}

class _MainContactPlaceFormState extends State<MainContactPlaceForm> {
  final ValueChanged<ContactPlace> createSuccess;
  final ContactPlace contactPlace;
  final String type;

  _MainContactPlaceFormState({Key key,
    this.createSuccess,
    this.contactPlace,
    this.type
  });

  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;

  CityBloc cityBloc;
  DistrictBloc districtBloc;
  WardBloc wardBloc;
  ContactPlaceBloc contactPlaceBloc;

  final _contactPlaceForm = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _citySearchController = TextEditingController();
  final _districtSearchController = TextEditingController();
  final _wardSearchController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  bool _autoValidateFrom = false;
  bool showErrLocation = false;

  bool _isMain = false;

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);

    cityBloc = BlocProvider.of<CityBloc>(context);
    districtBloc = BlocProvider.of<DistrictBloc>(context);
    wardBloc = BlocProvider.of<WardBloc>(context);
    contactPlaceBloc = BlocProvider.of<ContactPlaceBloc>(context);

    if (type == 'update') {
      _nameController.text = '${contactPlace.name}';
      _phoneController.text = '${contactPlace.phone}';
      _addressController.text = '${contactPlace.address}';

      districtBloc.dispatch(FetchDistrictEvent(selectedCityCode: contactPlace.cityCode));
      wardBloc.dispatch(FetchWardEvent(selectedDistrictCode: contactPlace.districtCode));

      setState(() {
        if(contactPlace.isMain) {
          _isMain = true;
        }
      });
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
//    contactPlaceBloc.dispatch(SetLoadedContactPlaceEvent());
    super.dispose();
  }

  void _fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _checkContactPlaceIsMain(bool value) => setState(() => _isMain = value);
  void checkIsMain () {
    setState(() => _isMain = !_isMain);
  }

  _onCreateButtonPressed() {
    print(type);
    setState(() {
      showErrLocation = true;
    });
    if (_contactPlaceForm.currentState.validate()) {
      if (type == 'update') {
        contactPlaceBloc.dispatch(UpdateContactPlaceEvent(
          id: contactPlace.id,
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          isMain: _isMain,
          isActive: contactPlace.status
        ));
      } else {
        contactPlaceBloc.dispatch(CreateContactPlaceEvent(
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          isMain: _isMain
        ));
      }
      Navigator.of(context).pop();
      contactPlaceBloc.dispatch(RefreshContactPlaceEvent());
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
          body: new BlocBuilder<CityBloc, CityState>(
            bloc: cityBloc,
            builder: (builder, state) {
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
                          contactPlaceBloc.dispatch(UpdateCityContactPlaceEvent(
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
            },
          ),
        );
      });
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
                          contactPlaceBloc.dispatch(UpdateDistrictContactPlaceEvent(
                            selectedDistrictCode: item.code,
                            selectedDistrictName: item.name,
                            enableSelectWard: true
                          ));
                          Navigator.pop(context);
                          _showModalWard();
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
      });
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
                          contactPlaceBloc.dispatch(UpdateWardContactPlaceEvent(
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
      });
  }
  Widget _buildSelectCity() {
    return BlocBuilder<ContactPlaceBloc, ContactPlaceState>(
      bloc: contactPlaceBloc,
      builder: (context, state) {
        if (state is LoadedContactPlaceState) {
          return ListTile(
            title: Text('Tỉnh/Thành phố'),
            subtitle: Text((state.contactPlace != null && state.contactPlace.cityName != '') ? '${state.contactPlace.cityName}' : ''),
            dense: true,
            trailing: Icon(Icons.keyboard_arrow_down),
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
    return BlocBuilder<ContactPlaceBloc, ContactPlaceState>(
      bloc: contactPlaceBloc,
      builder: (context, state) {
        if (state is LoadedContactPlaceState) {
          return ListTile(
            title: Text('Quận/Huyện'),
            subtitle: Text(state.enableSelectDistrict ? state.contactPlace.districtName : ''),
            dense: true,
            trailing: Icon(Icons.keyboard_arrow_down),
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
    return BlocBuilder<ContactPlaceBloc, ContactPlaceState>(
      bloc: contactPlaceBloc,
      builder: (context, state) {
        if (state is LoadedContactPlaceState) {
          return ListTile(
            title: Text('Phường/Xã'),
            subtitle: Text(state.enableSelectWard ? state.contactPlace.wardName : ''),
            dense: true,
            trailing: Icon(Icons.keyboard_arrow_down),
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
      title: Text(type == 'update' ? "Sửa ${contactPlace.name}" : 'Tạo điểm lấy/trả hàng',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16
        )),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
          contactPlaceBloc.dispatch(ClearStateCreateContactPlaceEvent());
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
    );
  }

  Widget _buildBottomAppbar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
        child: BlocBuilder<ContactPlaceBloc, ContactPlaceState>(
          bloc: contactPlaceBloc,
          builder: (context, state) {
            return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(30.0),
              ),
              color: colorAccent,
              child: Text(
                'Lưu lại',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                  _onCreateButtonPressed();
              },
            );
          }
        ),
      ),
    );
  }


  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        child: new Form(
          key: _contactPlaceForm,
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
                            minLines: 1,
                            maxLines: 2,
                            cursorColor: colorPrimary,
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
//                                suffixIcon: IconButton(
//                                  onPressed: () => _nameController.clear(),
//                                  icon: Icon(Icons.clear, color: Colors.black, size: 16),
//                                ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              isDense: true,
                              labelText: 'Tên liên hệ',
                              labelStyle: TextStyle(color: Colors.black)),
                            focusNode: _nameFocus,
                            autovalidate: _autoValidateFrom,
                            autocorrect: false,
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Vui lòng nhập Tên liên hệ';
                              }
                              return null;
                            },
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                context, _nameFocus, _phoneFocus);
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
                              controller: _phoneController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
//                                suffix: Icon(Icons.close, color: colorDarkGray, size: 16),
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
                              focusNode: _phoneFocus,
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
                                  context, _phoneFocus, FocusNode());
                              }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
//                        decoration: BoxDecoration(
//                            border: Border(
//                              right: BorderSide(
//                                color: colorGray,
//                                width: 1.0,
//                              ),
//                            )
//                        ),
                        child: Theme(
                          data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 2,
                            cursorColor: colorPrimary,
                            controller: _addressController,
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
                              labelText: 'Nhập địa chỉ (Đường/ngõ/số nhà)',
                              labelStyle: TextStyle(color: Colors.black)),
                            focusNode: _addressFocus,
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
                                context, _addressFocus, FocusNode());
                            }
                          ),
                        ),
                      ),
                    ),
//                    new Expanded(
//                      child: IconButton(
//                        onPressed: () {
//                        },
//                        icon: Icon(
//                          Icons.location_on,
//                          color: colorPrimary,
//                          size: 30
//                        ),
//                      ),
//                    ),
                  ],
                ),
              ),
              _buildSelectCity(),
              new BlocBuilder<ContactPlaceBloc, ContactPlaceState>(
                bloc: contactPlaceBloc,
                builder: (context, state) {
                  if (state is LoadedContactPlaceState) {
                    return (state.contactPlace != null && state.contactPlace.cityName == '' && showErrLocation)
                      ? new Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: <Widget>[
                            new SizedBox(
                              height: 1.2,
                              child: new Center(
                                child: new Container(
                                  margin: new EdgeInsetsDirectional.only(end: 15),
                                  color: colorError,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: <Widget>[
                                  Text('Vui lòng chọn Tỉnh/Thành phố', style: TextStyle(color: colorError, fontSize: 12))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      : Divider(height: 0,);
                  }
                  return Container();
                }
              ),
              _buildSelectDistrict(),
              new BlocBuilder<ContactPlaceBloc, ContactPlaceState>(
                bloc: contactPlaceBloc,
                builder: (context, state) {
                  if (state is LoadedContactPlaceState) {
                    return (state.contactPlace != null && state.contactPlace.districtName == '' && showErrLocation)
                      ? new Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 1.2,
                            child: new Center(
                              child: new Container(
                                margin: new EdgeInsetsDirectional.only(end: 15),
                                color: colorError,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: <Widget>[
                                Text('Vui lòng chọn Quận/Huyện', style: TextStyle(color: colorError, fontSize: 12))
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                      : Divider(height: 0,);
                  }
                  return Container();
                }
              ),
              _buildSelectWard(),
              new BlocBuilder<ContactPlaceBloc, ContactPlaceState>(
                bloc: contactPlaceBloc,
                builder: (context, state) {
                  if (state is LoadedContactPlaceState) {
                    return (state.contactPlace != null && state.contactPlace.wardName == '' && showErrLocation)
                      ? new Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: <Widget>[
                          new SizedBox(
                            height: 1.2,
                            child: new Center(
                              child: new Container(
                                margin: new EdgeInsetsDirectional.only(end: 15),
                                color: colorError,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: <Widget>[
                                Text('Vui lòng chọn Phường/Xã', style: TextStyle(color: colorError, fontSize: 12))
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                      : Divider(height: 0,);
                  }
                  return Container();
                }
              ),
              new Container(
                padding: EdgeInsets.all(5),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _isMain,
                          onChanged: _checkContactPlaceIsMain,
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),
                        GestureDetector(
                          onTap: () {
                            checkIsMain();
                          },
                          child: Text(
                            'Đặt làm kho mặc định',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactPlaceBloc, ContactPlaceState>(
          bloc: contactPlaceBloc,
          listener: (context, state) {
            if (state is LoadedContactPlaceState) {
              if (state.isSuccess) {
                if  (state.contactPlace.id != null) {
                  createSuccess(state.contactPlace);
                }
                Navigator.of(context).pop();
              }
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is UnauthenticatedAuthentication) {
              navigationBloc.dispatch(LoginNavigationEvent());
            }
          }),
//        BlocListener<DistrictBloc, DistrictState>(
//          listener: (context, state) {
//            if (state is FailureDistrictState) {
//              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
//              notifyBloc.dispatch(ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
//            }
//            if (state is LoadingDistrictState) {
//              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: true));
//            }
//            if (state is LoadedDistrictState) {
//              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
//            }
//          }),
//        BlocListener<WardBloc, WardState>(
//          listener: (context, state) {
//            if (state is FailureWardState) {
//              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
//              notifyBloc.dispatch(ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
//            }
//            if (state is LoadingWardState) {
//              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: true));
//            }
//            if (state is LoadedWardState) {
//              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
//            }
//          })
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: _buildContent(),
          bottomNavigationBar: _buildBottomAppbar()
        ),
      ),
    );
  }
}
