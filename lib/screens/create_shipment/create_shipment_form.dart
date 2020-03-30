import 'dart:async';
import 'package:app_customer/bloc/city/bloc.dart';
import 'package:app_customer/bloc/config/bloc.dart';
import 'package:app_customer/bloc/contact_place/bloc.dart';
import 'package:app_customer/bloc/create_shipment/bloc.dart';
import 'package:app_customer/bloc/district/bloc.dart';
import 'package:app_customer/bloc/list_status/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/shipment/bloc.dart';
import 'package:app_customer/bloc/ward/bloc.dart';
import 'package:app_customer/repositories/city/city_repository.dart';
import 'package:app_customer/repositories/district/district_repository.dart';
import 'package:app_customer/repositories/shipment/package.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:app_customer/repositories/ward/ward_repository.dart';
import 'package:app_customer/screens/components/animation_route.dart';
import 'package:app_customer/screens/components/circular_color.dart';
import 'package:app_customer/screens/components/circular_progress_indicator.dart';
import 'package:app_customer/screens/contact_place/contact_place.dart';
import 'package:app_customer/screens/create_shipment/contact_place_list_select.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'create_receiver_form.dart';

class CreateShipmentFormPage extends StatefulWidget {
  final Shipment shipment;
  final String type;
  final bool redirectDetail;

  CreateShipmentFormPage({
    Key key,
    this.shipment,
    this.type,
    this.redirectDetail,
  }) :
      super(key: key);

  @override
  _CreateShipmentFormPageState createState() => _CreateShipmentFormPageState(
    shipment: shipment,
    type: type,
    redirectDetail: redirectDetail
  );
}

class _CreateShipmentFormPageState extends State<CreateShipmentFormPage> {
  final CityRepository cityRepository = CityRepository();
  final DistrictRepository districtRepository = DistrictRepository();
  final WardRepository wardRepository = WardRepository();
  final Shipment shipment;
  final String type;
  final bool redirectDetail;

  _CreateShipmentFormPageState({
    Key key,
    this.shipment,
    this.type,
    this.redirectDetail,
  });

  NavigationBloc navigationBloc;
  CreateShipmentBloc createShipmentBloc;
  ShipmentBloc shipmentBloc;
  ListStatusBloc listStatusBloc;
  ContactPlaceBloc contactPlaceBloc;
  NotifyBloc notifyBloc;
  CityBloc cityBloc;
  DistrictBloc districtBloc;
  WardBloc wardBloc;
  ConfigBloc configBloc;

  TextEditingController noteController = TextEditingController();

  double heightLineMax = 60;
  bool _autoValidateFrom = false;
  double config = 6000;
  String packageName = 'Chọn';
  Timer _deBounce;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  final _infoPackageCreateShipmentForm = GlobalKey<FormState>();
  final _infoCodAndServiceCreateShipmentForm = GlobalKey<FormState>();

  // Thông tin hàng hóa
  final _nameController = TextEditingController(text: '');
  final _weightController = TextEditingController(text: "0.5");
  final _lengthController = TextEditingController(text: "10");
  final _widthController = TextEditingController(text: "10");
  final _heightController = TextEditingController(text: "10");
  final _weightConvertController = TextEditingController();
  final _codController = TextEditingController();
  final _amountController = TextEditingController();
//  final _codController = MoneyMaskedTextController(precision: 0, decimalSeparator: ',', thousandSeparator: '.');
//  final _amountController = MoneyMaskedTextController(precision: 0, decimalSeparator: ',', thousandSeparator: '.');
  final _quantityController = TextEditingController(text: "1");
  final _noteController = TextEditingController();

  final _promotionController = TextEditingController();

  final List<String> _dropdownValues = [
    "Cho xem hàng không cho thử",
    "Không cho xem hàng",
    "Cho xem hàng"
  ];
  String selectedDropdownList = 'Không cho xem hàng';

  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    createShipmentBloc = BlocProvider.of<CreateShipmentBloc>(context);
    shipmentBloc = BlocProvider.of<ShipmentBloc>(context);
    listStatusBloc = BlocProvider.of<ListStatusBloc>(context);
    cityBloc = BlocProvider.of<CityBloc>(context);
    districtBloc = BlocProvider.of<DistrictBloc>(context);
    wardBloc = BlocProvider.of<WardBloc>(context);
    configBloc = BlocProvider.of<ConfigBloc>(context);
    contactPlaceBloc = BlocProvider.of<ContactPlaceBloc>(context);

    if (type != 'create') {
      packageName = '${shipment.package.name}';
      _nameController.text = '${shipment.package.name}';
      _weightController.text = '${shipment.package.weight}';
      _lengthController.text = '${formatNumber.format(double.parse('${shipment.package.length}'))}';
      _widthController.text = '${formatNumber.format(double.parse('${shipment.package.width}'))}';
      _heightController.text = '${formatNumber.format(double.parse('${shipment.package.height}'))}';
      _codController.text = '${shipment.package.cod}';
      _noteController.text = '${shipment.package.note}';
      _amountController.text = '${formatNumber.format(double.parse('${shipment.package.amount}'))}';
//      _amountController.text = '${formatMoney.format(double.parse('${shipment.package.amount}'))}';
      _codController.text = '${formatNumber.format(double.parse('${shipment.package.cod}'))}';
      selectedDropdownList = '${shipment.note != '' ? shipment.note.split(",")[0] : selectedDropdownList}';

      createShipmentBloc.dispatch(FetchRateCreateShipmentEvent());
      _onFetchSurcharge();
    }

    _scrollController.addListener(_onScroll);

    _codController.addListener(_onFetchSurcharge);
    _amountController.addListener(_onFetchSurcharge);
    _promotionController.addListener(_onFetchApplyPromotion);

    calcWeightConvert();
    _lengthController.addListener(calcWeightConvert);
    _widthController.addListener(calcWeightConvert);
    _heightController.addListener(calcWeightConvert);

    _nameController.addListener(_displayNamePackage);

    _weightController.addListener(_onFetchRate);
    _lengthController.addListener(_onFetchRate);
    _widthController.addListener(_onFetchRate);
    _heightController.addListener(_onFetchRate);
  }
  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    _weightConvertController.dispose();

    _scrollController.removeListener(_onScroll);
    _codController.removeListener(_onFetchSurcharge);
    _amountController.removeListener(_onFetchSurcharge);
    _promotionController.removeListener(_onFetchApplyPromotion);

    _weightController.removeListener(_onFetchRate);
    _lengthController.removeListener(_onFetchRate);
    _widthController.removeListener(_onFetchRate);
    _heightController.removeListener(_onFetchRate);

    _lengthController.removeListener(calcWeightConvert);
    _widthController.removeListener(calcWeightConvert);
    _heightController.removeListener(calcWeightConvert);

    createShipmentBloc.dispatch(SetLoadedCreateShipmentEvent());
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      contactPlaceBloc.dispatch(LoadMoreContactPlaceEvent());
    }
  }
  calcWeightConvert() {
    _weightConvertController.text = '${(
        double.tryParse(_lengthController.text.toString()) *
        double.tryParse(_heightController.text.toString()) *
        double.tryParse(_widthController.text.toString()) / config
      ).toStringAsFixed(2)
    }';
  }
  _displayNamePackage() {
    packageName = _nameController.text != '' ? _nameController.text : 'Chọn';
  }
  _onFetchSurcharge() {
    if (_deBounce?.isActive ?? false) _deBounce.cancel();
    _deBounce = Timer(const Duration(milliseconds: 800), () {
      if (_codController.text != '' || _amountController.text != '') {
        createShipmentBloc.dispatch(FetchSurchargeCreateShipmentEvent(
          cod: double.tryParse(_codController.text.toString()),
          amount: double.tryParse(_amountController.text.toString())
        ));
      }
    });
  }
  _onFetchApplyPromotion() {
    if (_deBounce?.isActive ?? false) _deBounce.cancel();
    _deBounce = Timer(const Duration(milliseconds: 800), () {
      _fetchApplyPromotionCreateShipmentFormPress(_promotionController.text);
    });
  }
  _onFetchRate() {
    if (_deBounce?.isActive ?? false) _deBounce.cancel();
    _deBounce = Timer(const Duration(milliseconds: 800), () {
      createShipmentBloc.dispatch(FetchRateCreateShipmentEvent(
        weight: _weightController.text,
        length: _lengthController.text,
        width: _widthController.text,
        height: _heightController.text,
      ));
    });
  }

  void _onUpdatePackageButtonPress() {
    if (_infoPackageCreateShipmentForm.currentState.validate()) {
      createShipmentBloc.dispatch(UpdatePackageCreateShipmentEvent(
        package: Package(
          name: _nameController.text,
          weight: double.parse(_weightController.text.toString()),
          length: double.parse(_lengthController.text.toString()),
          width: double.parse(_widthController.text.toString()),
          height: double.parse(_heightController.text.toString()),
          amount: _amountController.text != ''
            ? double.parse(_amountController.text.toString())
            : 0,
          quantity: int.parse(_quantityController.text.toString()),
          note: _noteController.text,
        )
      ));
      Navigator.of(context).pop();

      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: _showModalCodAndServices());
        }
      );
    } else {
      setState(() {
        _autoValidateFrom = true;
      });
      notifyBloc.dispatch(ShowNotifyEvent(
        type: NotifyEvent.WARNING,
        message: 'Vui lòng kiểm tra lại thông tin cần nhập'));
    }
  }
  void _onUpdateOrCreateShipmentDraft() {
    if (type == 'update') {
      createShipmentBloc.dispatch(ApplyUpdateShipmentEvent(
        isDraft: false,
        code: shipment.code,
        note: _noteController.text != '' ? '${selectedDropdownList + ", " + _noteController.text}' : selectedDropdownList,
        package: Package(
          name: _nameController.text,
          weight: double.parse(_weightController.text.toString()),
          length: double.parse(_lengthController.text.toString()),
          width: double.parse(_widthController.text.toString()),
          height: double.parse(_heightController.text.toString()),
          amount: _amountController.text != ''
            ? double.parse(_amountController.text.toString())
            : 0,
          cod: _codController.text != ''
            ? double.parse(_codController.text.toString())
            : 0,
          quantity: int.parse(_quantityController.text.toString()),
          note: _noteController.text,
        )
      ));
    } else {
      createShipmentBloc.dispatch(ApplyCreateShipmentEvent(
        isDraft: true,
        note: _noteController.text != '' ? '${selectedDropdownList + ", " + _noteController.text}' : selectedDropdownList,
        package: Package(
          name: _nameController.text,
          weight: double.parse(_weightController.text.toString()),
          length: double.parse(_lengthController.text.toString()),
          width: double.parse(_widthController.text.toString()),
          height: double.parse(_heightController.text.toString()),
          amount: _amountController.text != ''
            ? double.parse(_amountController.text.toString())
            : 0,
          cod: _codController.text != ''
            ? double.parse(_codController.text.toString())
            : 0,
          quantity: int.parse(_quantityController.text.toString()),
          note: _noteController.text,
        )
      ));
//      shipmentBloc.dispatch(UpdateFilterStatusEvent(
//        status: 'draft',
//        selectStatus: true,
//        statusTxt: 'Dự thảo'
//      ));
//      shipmentBloc.dispatch(ApplyFilterShipmentEvent());
    }
    shipmentBloc.dispatch(RefreshShipmentEvent());
    listStatusBloc.dispatch(DisplayIconListStatusEvent(isShowIcon: false, status: ''));
  }
  void _onUpdateOrCreateShipmentSendNow() {
    if (type == 'update') {
      createShipmentBloc.dispatch(ApplyUpdateShipmentEvent(
        isDraft: true,
        code: shipment.code,
        note: _noteController.text != '' ? '${selectedDropdownList + ", " + _noteController.text}' : selectedDropdownList,
        package: Package(
          name: _nameController.text,
          weight: double.parse(_weightController.text.toString()),
          length: double.parse(_lengthController.text.toString()),
          width: double.parse(_widthController.text.toString()),
          height: double.parse(_heightController.text.toString()),
          amount: _amountController.text != ''
            ? double.parse(_amountController.text.toString())
            : 0,
          cod: _codController.text != ''
            ? double.parse(_codController.text.toString())
            : 0,
          quantity: int.parse(_quantityController.text.toString()),
          note: _noteController.text,
        )
      ));
//      shipmentBloc.dispatch(UpdateFilterStatusEvent(
//        status: 'draft',
//        selectStatus: true,
//        statusTxt: 'Dự thảo'
//      ));
//      shipmentBloc.dispatch(ApplyFilterShipmentEvent());
    } else {
      createShipmentBloc.dispatch(ApplyCreateShipmentEvent(
        isDraft: false,
        note: _noteController.text != '' ? '${selectedDropdownList + ", " + _noteController.text}' : selectedDropdownList,
        package: Package(
          name: _nameController.text,
          weight: double.parse(_weightController.text.toString()),
          length: double.parse(_lengthController.text.toString()),
          width: double.parse(_widthController.text.toString()),
          height: double.parse(_heightController.text.toString()),
          amount: _amountController.text != ''
            ? double.parse(_amountController.text.toString())
            : 0,
          cod: _codController.text != ''
            ? double.parse(_codController.text.toString())
            : 0,
          quantity: int.parse(_quantityController.text.toString()),
          note: _noteController.text,
        )
      ));
    }
    shipmentBloc.dispatch(RefreshShipmentEvent());
    listStatusBloc.dispatch(DisplayIconListStatusEvent(isShowIcon: false, status: ''));
  }

  _openCreateContactPlaceForm(context) {
//    Navigator.push(context, EnterExitRoute(
//      exitPage: CreateShipmentPage(
//        shipment: shipment,
//        type: type,
//        redirectDetail: redirectDetail,
//      ),
//      enterPage: ContactPlaceFormPage(
//        createSuccess: (contactPlace) {
//          createShipmentBloc.dispatch(UpdatePickerEvent(
//            isSelectedPicker: true,
//            selectedPickerName: contactPlace.name,
//            selectedPickerPhone: contactPlace.phone
//          ));
//          createShipmentBloc.dispatch(FetchRateCreateShipmentEvent());
//        },
//      )));

    Navigator.push(context, SlideRoute(
      page: ContactPlaceFormPage(
        createSuccess: (contactPlace) {
          createShipmentBloc.dispatch(UpdatePickerEvent(
            isSelectedPicker: true,
            selectedPickerName: contactPlace.name,
            selectedPickerPhone: contactPlace.phone
          ));
          createShipmentBloc.dispatch(FetchRateCreateShipmentEvent());
        },
      )));
  }
  _openCreateReceiverForm(context) {
//    Navigator.push(context, EnterExitRoute(
//      exitPage: CreateShipmentPage(
//        shipment: shipment,
//        type: type,
//        redirectDetail: redirectDetail,
//      ),
//      enterPage: CreateReceiverFormPage(
//        cityRepository: cityRepository,
//        districtRepository: districtRepository,
//        wardRepository: wardRepository,
//        shipment: shipment
//      )));
    Navigator.push(context, SlideRoute(
      page: CreateReceiverFormPage(
      cityRepository: cityRepository,
      districtRepository: districtRepository,
      wardRepository: wardRepository,
      shipment: shipment
    )));
  }

  void _showModalSheet(String tab) {
    createShipmentBloc.dispatch(OpenTabCreateShipmentEvent(tab: tab));
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child:
          BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
            bloc: createShipmentBloc,
            builder: (context, state) {
              if (state is LoadedCreateShipmentState) {
                if (state.tab == 'package') {
                  return _showModalPackage();
                }
                if (state.tab == 'services') {
                  return _showModalCodAndServices();
                }
              }
              return Container();
            }
          )
        );
      }
    );
  }

  Widget _buildFormCreatePicker() {
    return BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
      bloc: createShipmentBloc,
      builder: (context, state) {
        if (state is LoadedCreateShipmentState) {
          return Expanded(
            child: ListTile(
              leading: new Container(
                alignment: Alignment.center,
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: colorPrimary,
                ),
                child: Text('Gửi', style: TextStyle(
                  color: Colors.white,
                  fontSize: 12
                )),
              ),
              title: Text(state.isSelectedPicker ? '${state.shipment.pickerName} - ${state.shipment.pickerPhone}' : 'Điểm lấy hàng của bạn?',
                style: TextStyle(color: Colors.black)
              ),
              dense: true,
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
              onTap: () {
                _openCreateContactPlaceForm(context);
              },
            ),
          );
        } else {
          return Container(
            child: Text('Có lỗi xảy ra'),
          );
        }
      }
    );
  }
  Widget _buildSelectPicker() {
    return  new GestureDetector(
      onTap: () {
        contactPlaceBloc.dispatch(FetchContactPlaceEvent());
        Navigator.push(context, FadeRoute(page: ContactPlaceListSelect()));
//        Navigator.push(context, EnterExitRoute(
//          exitPage: CreateShipmentPage(
//            shipment: shipment,
//            type: type,
//            redirectDetail: redirectDetail,
//          ),
//          enterPage: ContactPlaceListSelect()));
      },
      child: Container(
        height: heightLineMax,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colorGray,
              width: 1.5,
            ),
          )
        ),
        child: Icon(
          FontAwesomeIcons.addressBook,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildFormReceiver() {
    return new Expanded(
      child: ListTile(
        leading: new Container(
          alignment: Alignment.center,
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: colorAccent,
          ),
          child: Text('Nhận', style: TextStyle(
            color: Colors.white,
            fontSize: 12
          )),
        ),
        title: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
          bloc: createShipmentBloc,
          builder: (context, state) {
            if (state is LoadedCreateShipmentState) {
              return Text(state.isUpdateReceiver ? '${state.shipment.receiverName} - ${state.shipment.receiverPhone}' : 'Bạn muốn gửi đến?',
                style: TextStyle(color: Colors.black)
              );
            }
            return Container();
          }
        ),
        dense: true,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: () {
          _openCreateReceiverForm(context);
        },
      ),
    );
  }
  Widget _buildSelectReceiver() {
    return new GestureDetector(
      onTap: () {
//        navigationBloc.dispatch(ChangeIndexPageEvent(index: 1));
      },
      child: Container(
        height: heightLineMax,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colorGray,
              width: 1.5,
            ),
          )
        ),
        child: Icon(
          FontAwesomeIcons.addressBook,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildAppBarModalPackage() {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0.5,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text("Thông tin hàng hóa",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16
        )),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
      ),
    );
  }
  Widget _buildBodyModalPackage() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child:
          new Form(
            key: _infoPackageCreateShipmentForm,
            child: Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      autofocus: false,
                      cursorColor: colorPrimary,
                      controller: _nameController,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colorPrimary)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colorGray)),
                        isDense: true,
                        labelText: 'Tên hàng hóa',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                        )
                      ),
                      validator: (_) {
                        if (_.isEmpty) {
                          return 'Vui lòng nhập tên hàng hóa';
                        }
                        return null;
                      },
                      autovalidate: _autoValidateFrom
                    )
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              isDense: true,
                              labelText: 'Khối lượng',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                              )
                            ),
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Vui lòng nhập';
                              }
                              return null;
                            },
                            autovalidate: _autoValidateFrom
                          )
                        ),
                      ),
                      new Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              isDense: true,
                              labelText: 'Số lượng',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                              )
                            ),
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Vui lòng nhập';
                              }
                              return null;
                            },
                            autovalidate: _autoValidateFrom
                          )
                        ),
                      ),
                      new Expanded(
                        child: Container(
                          padding:
                          EdgeInsets.only(left: 5, right: 10),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              isDense: true,
                              labelText: 'Giá trị hàng',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16)),
                            autovalidate: _autoValidateFrom
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 25),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _lengthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              suffix: Text('cm'),
                              isDense: true,
                              labelText: 'Dài',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16)),
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Vui lòng nhập';
                              }
                              return null;
                            },
                            autovalidate: _autoValidateFrom)),
                      ),
                      new Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 0, right: 25),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _widthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              suffix: Text('cm'),
                              isDense: true,
                              labelText: 'Rộng',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16)),
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Vui lòng nhập';
                              }
                              return null;
                            },
                            autovalidate: _autoValidateFrom)),
                      ),
                      new Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 0, right: 25),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              suffix: Text('cm'),
                              isDense: true,
                              labelText: 'Cao',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16)),
                            validator: (_) {
                              if (_.isEmpty) {
                                return 'Vui lòng nhập';
                              }
                              return null;
                            },
                            autovalidate: _autoValidateFrom)),
                      ),
                      new Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 0, right: 10),
                          child: TextFormField(
                            readOnly: true,
                            controller: _weightConvertController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              suffix: Text('kg'),
                              isDense: true,
                              labelText: 'Quy đổi',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16)),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: DropdownButtonFormField(
                    value: selectedDropdownList,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorGray))),
                    items: _dropdownValues.map((value) => DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    )).toList(),
                    onChanged: (String value) {
                      setState(() => selectedDropdownList = value);
                    },
                  )
                ),
                new Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    cursorColor: colorPrimary,
                    controller: _noteController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorPrimary)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorGray)),
                      isDense: true,
                      labelText: 'Ghi chú',
                      labelStyle: TextStyle(
                        color: Colors.black, fontSize: 16)),
                  )),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildBottomNavBarModalPackage() {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: 60,
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 42,
        child: FlatButton(
          color: colorAccent,
          textColor: Colors.white,
          splashColor: Colors.white,
          onPressed: () {
            _onUpdatePackageButtonPress();
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
          child: Text('Tiếp tục')
        )
      ),
    );
  }
  Container _showModalPackage() {
    return Container(
      height: 500,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBarModalPackage(),
        body: _buildBodyModalPackage(),
        bottomNavigationBar: _buildBottomNavBarModalPackage()
      ),
    );
  }

  Widget _buildAppBarModalCodAndServices() {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0.5,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text("Tiền thu hộ & dịch vụ",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16
        )),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
      ),
    );
  }
  Widget _buildBodyModalCodAndServices() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child:
          new Form(
            key: _infoCodAndServiceCreateShipmentForm,
            child: Column(
              children: <Widget>[
                new Container(
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: TextFormField(
                            cursorColor: colorPrimary,
                            controller: _codController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorPrimary)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorGray)),
                              isDense: true,
                              labelText: 'Tiền thu hộ (đ)',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16)),
                          ),
                        ),
                      ),
                      new Expanded(
                        child: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                          bloc: createShipmentBloc,
                          builder: (context, state) {
                            if (state is LoadedCreateShipmentState) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  cursorColor: colorPrimary,
                                  controller: _promotionController,
                                  onFieldSubmitted: (value) {
                                    _fetchApplyPromotionCreateShipmentFormPress(value);
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: colorPrimary)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: colorGray)),
                                    suffix: null,
                                    isDense: true,
                                    labelText: 'Khuyến mại',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16)),
                                ),
                              );
                            }
                            return Container();
                          }
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Người trả phí',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            new Row(
                              children: <Widget>[
                                BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                                  bloc: createShipmentBloc,
                                  builder: (context, state) {
                                    if (state is LoadedCreateShipmentState) {
                                      return Row(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(right: 8),
                                            alignment: Alignment.center,
                                            height: 32,
                                            width: 65,
                                            child: FlatButton(
                                              onPressed: () {
                                                createShipmentBloc.dispatch(ChangePayerCreateShipmentEvent(payer: 'picker'));
                                              },
                                              color: state.shipment.payer == 'picker' ? colorPrimary : colorLightGray,
                                              textColor: state.shipment.payer == 'picker' ? Colors.white : Colors.black,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(30.0)
                                              ),
                                              child: Text('Gửi', style: TextStyle(fontSize: 13),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 32,
                                            width: 75,
                                            child: FlatButton(
                                              onPressed: () {
                                                createShipmentBloc.dispatch(ChangePayerCreateShipmentEvent(payer: 'receiver'));
                                              },
                                              color: state.shipment.payer == 'receiver' ? colorPrimary : colorLightGray,
                                              textColor: state.shipment.payer == 'receiver' ? Colors.white : Colors.black,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(30.0)
                                              ),
                                              child: Text('Nhận', style: TextStyle(fontSize: 13),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                    return Container();
                                  }
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Lấy/giao',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                              bloc: createShipmentBloc,
                              builder: (context, state) {
                                if (state is LoadedCreateShipmentState) {
                                  return Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        alignment: Alignment.center,
                                        height: 32,
                                        width: 79,
                                        child: FlatButton(
                                          onPressed: () {
                                            createShipmentBloc.dispatch(ChangePickOnHubCreateShipmentEvent(pickOnHub: false));
                                          },
                                          color: !state.shipment.pickOnHub ? colorPrimary : colorLightGray,
                                          textColor: !state.shipment.pickOnHub ? Colors.white : Colors.black,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(30.0)
                                          ),
                                          child: Text('Tại nhà', style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 32,
                                        width: 80,
                                        child: FlatButton(
                                          onPressed: () {
                                            createShipmentBloc.dispatch(ChangePickOnHubCreateShipmentEvent(pickOnHub: true));
                                          },
                                          color: state.shipment.pickOnHub ? colorPrimary : colorLightGray,
                                          textColor: state.shipment.pickOnHub ? Colors.white :  Colors.black,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(30.0)
                                          ),
                                          child: Text('Bưu cục', style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                                return Container();
                              }
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Row(
                    children: <Widget>[
                      Text('Chọn dịch vụ', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                      ),
                    ],
                  ),
                ),
                new Column(
                  children: <Widget>[
                    BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                      bloc: createShipmentBloc,
                      builder: (context, state) {
                        if (state is LoadedCreateShipmentState) {
                          if (state.loadingRate == true) {
                            return LoaderTwo();
                          }

                          if (state.loadingRate == false && state.rates.length > 0 ){
                            return Container(
                              height: 150,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(8),
                                itemCount: state.rates.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Material(
                                    child: InkWell(
                                      onTap: () {
                                        createShipmentBloc.dispatch(ChangeRateIDCreateShipmentEvent(
                                          rateID: state.rates[index].id,
                                          rateName: state.rates[index].serviceName
                                        ));
                                        createShipmentBloc.dispatch(UpdateTotalFeeCreateShipmentEvent(
                                          feeRate: state.rates[index].fee
                                        ));
                                      },
                                      child: Container(
                                        height: 55,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 5,right: 10),
                                                    child: Icon(
                                                      state.rates[index].id == state.shipment.rateId
                                                        ? Icons.radio_button_checked
                                                        : Icons.radio_button_unchecked,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        state.rates[index].serviceName.toString(),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 5),
                                                        child: Text(
                                                          'Dự kiến giao: ' + state.rates[index].pickupAt,
                                                          style: TextStyle(
                                                            color: colorDarkGray,
                                                            fontSize: 12
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text('Phí ship: ', style: TextStyle(
                                                    fontWeight: FontWeight.w500
                                                  )
                                                  ),
                                                  Text(
                                                    '${formatMoney.format(double.parse('${state.rates[index].fee}'))}' + ' đ ',
                                                    style: TextStyle(
                                                      color: colorAccent
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                              )
                            );
                          }
                          if (state.loadingRate == false && state.rates.length == 0 ) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Không lấy được bảng giá'),
                            );
                          }
                        }
                        return Container();
                      }
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildBottomNavBarModalCodAndServices() {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: 60,
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 42,
        child: FlatButton(
          color: colorAccent,
          textColor: Colors.white,
          splashColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
          child: Text('Tiếp tục'))
      ),
    );
  }
  Container _showModalCodAndServices() {
    return Container(
      height: 450,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBarModalCodAndServices(),
        body: _buildBodyModalCodAndServices(),
        bottomNavigationBar: _buildBottomNavBarModalCodAndServices()
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0.5,
      backgroundColor: Colors.white,
      title: Text('${type == 'update' ? 'Sửa vận đơn ${shipment.code}': 'Tạo vận đơn'}',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16
        )),
      centerTitle: true,
      leading: IconButton(
        onPressed: redirectDetail == false ? () {
          type == 'create'
            ? navigationBloc.dispatch(ChangeIndexPageEvent(index: 0))
            : navigationBloc.dispatch(ChangeIndexPageEvent(index: 1));
        } : () {
          navigationBloc.dispatch(DetailShipmentNavigationEvent(eventBack: ChangeIndexPageEvent(index: 1)));
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
    );
  }
  Widget _buildBody() {
    return SingleChildScrollView(
      child: new Container(
        child: Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: heightLineMax,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    _buildFormCreatePicker(),
                    _buildSelectPicker()
                  ],
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: heightLineMax,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    _buildFormReceiver(),
                    _buildSelectReceiver()
                  ],
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                height: 45,
                decoration: BoxDecoration(color: Colors.white),
                child: FlatButton(
                  onPressed: () {
                    _showModalSheet('package');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Thông tin hàng hóa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // light
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                              bloc: createShipmentBloc,
                              builder: (context, state) {
                                if (state is LoadedCreateShipmentState) {
                                  return (packageName != 'Chọn')
                                    ? Text(state.shipment.package.name == '' ? packageName : state.shipment.package.name)
                                    : Text(packageName, style: TextStyle(fontWeight: FontWeight.normal));
//                                return (state.shipment.package.name != '')
//                                ? Text('${state.shipment.package.name}')
//                                : Text('Chọn', style: TextStyle(fontWeight: FontWeight.normal),);
                                }
                                return Text('Có lỗi xảy ra');
                              }
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                height: 45,
                decoration: BoxDecoration(color: Colors.white),
                child: FlatButton(
                  onPressed: () {
                    _showModalSheet('services');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tiền thu hộ & dịch vụ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // light
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                              bloc: createShipmentBloc,
                              builder: (context, state) {
                                if (state is LoadedCreateShipmentState) {
                                  return (state.shipment.selectedRateName != '')
                                    ? Text('${state.shipment.selectedRateName}')
                                    : Text('Chọn', style: TextStyle(fontWeight: FontWeight.normal),);
                                }

                                return Text('Chọn', style: TextStyle(fontWeight: FontWeight.normal),);
                              }
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            new Container(
              child: BlocBuilder<ConfigBloc, ConfigState>(
                bloc: configBloc,
                builder: (context, state) {
                  if (state is LoadedConfigState) {
                    if (config != state.config) {
                      config = state.config;
                    }
                    calcWeightConvert();
                    return Container(width: 0, height: 0);
                  }
                  return Container(width: 0, height: 0);
                }
              )
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildBottomNavigationBar() {
    return new BottomAppBar(
      color: Colors.white,
      elevation: 0,
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              height: 50,
              padding: EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0, top: 5),
                    child: Text(
                      'Tổng phí',
                      style: TextStyle(color: colorDarkGray),
                    ),
                  ),
                  BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                    bloc: createShipmentBloc,
                    builder: (context, state) {
                      if (state is LoadedCreateShipmentState) {
                        return Text(
                          '${formatMoney.format(double.parse('${
                            state.feeRate + state.surcharges.feeCod + state.surcharges.feeInsurrance
                          }'))}' + ' đ '
                        );
                      }
                      return Text((1+2).toString());
                    }
                  )
                ],
              ),
            ),
            new Row(
              children: <Widget>[
                new ButtonTheme(
                  minWidth: 90.0,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: _onUpdateOrCreateShipmentDraft,
                    child: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                      bloc: createShipmentBloc,
                      builder: (context, state) {
                        if (state is LoadedCreateShipmentState) {
                          if (state.loadingSubmitDraft) {
                            return CircularLoader(color: Colors.black);
                          } else {
                            return Text(type == 'update' ? 'Gửi ngay' : 'Lưu nháp');
                          }
                        }
                        return Text('Error');
                      }
                    ),
                    color: colorLightGray,
                    textColor: Colors.black,
                    elevation: 1,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ButtonTheme(
                    minWidth: 90.0,
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: _onUpdateOrCreateShipmentSendNow,
                      child: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                        bloc: createShipmentBloc,
                        builder: (context, state) {
                          if (state is LoadedCreateShipmentState) {
                            if (state.loadingSubmitSend) {
                              return CircularLoader(color: Colors.white);
                            } else {
                              return Text(type == 'update' ? 'Cập nhật' : 'Gửi ngay');
                            }
                          }
                          return Text('Error');
                        }
                      ),
                      color: colorAccent,
                      textColor: Colors.white,
                      elevation: 1,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactPlaceBloc, ContactPlaceState>(
          listener: (context, state) {
            if (state is FailureContactPlaceState) {
              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
              notifyBloc.dispatch(ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
            }
            if (state is LoadingContactPlaceState) {
              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: true));
            }
            if (state is LoadedContactPlaceState) {
              notifyBloc.dispatch(LoadingNotifyEvent(isLoading: false));
            }
          })
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigationBar()
        ),
      ),
    );
  }

  void _fetchApplyPromotionCreateShipmentFormPress (String code) {
    createShipmentBloc.dispatch(FetchApplyPromotionCreateShipmentEvent(code: code));
  }
}
