import 'dart:async';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/create_shipment/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/bloc/contact_place/bloc.dart';
import 'package:app_customer/screens/components/circular_color.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPlaceListSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainContactPlaceListSelect()
    );
  }
}

class MainContactPlaceListSelect extends StatefulWidget {
  @override
  _MainContactPlaceListSelectState createState() => _MainContactPlaceListSelectState();
}

class _MainContactPlaceListSelectState extends State<MainContactPlaceListSelect> {
  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;
  CreateShipmentBloc createShipmentBloc;

  ContactPlaceBloc contactPlaceBloc;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final TextEditingController _controller = TextEditingController();

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  Timer _deBounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    contactPlaceBloc = BlocProvider.of<ContactPlaceBloc>(context);
    contactPlaceBloc.dispatch(FetchContactPlaceEvent());

    createShipmentBloc = BlocProvider.of<CreateShipmentBloc>(context);

    _controller.addListener(_onFilterContactPlace);
  }

  _onFilterContactPlace() {
    if (_deBounce?.isActive ?? false) _deBounce.cancel();
    _deBounce = Timer(const Duration(milliseconds: 800), () {
      contactPlaceBloc.dispatch(FilterContactPlaceEvent(q: _controller.text));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.removeListener(_onFilterContactPlace);
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      contactPlaceBloc.dispatch(LoadMoreContactPlaceEvent());
    }
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    contactPlaceBloc.dispatch(RefreshContactPlaceEvent());
    return null;
  }

  Widget _buildInputSearch() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        height: 50,
        color: colorBackground,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  cursorColor: colorPrimary,
                  controller: _controller,
                  autocorrect: false,
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
                          contactPlaceBloc.dispatch(FilterContactPlaceEvent(q: ''));
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
//                          _controller.clear();
//                          contactPlaceBloc.dispatch(FilterContactPlaceEvent(q: ''));
//                        }
//                      ),
                    contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    prefixIcon: Icon(Icons.search, color: colorDarkGray),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorPrimary)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorGray)),
                    hintText: "Nhập địa chỉ cần tìm",
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text("Danh sách điểm lấy hàng",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16
          )),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
          _controller.clear();
          contactPlaceBloc.dispatch(FilterContactPlaceEvent(q: ''));
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      bottom: _buildInputSearch(),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<ContactPlaceBloc, ContactPlaceState>(
      bloc: contactPlaceBloc,
      builder: (builder, state) {
        if (state is LoadingContactPlaceState) {
          return Center(
            child: LoaderTwo(),
          );
        }
        if (state is FailureContactPlaceState) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height - 120,
                alignment: Alignment.center,
                child: Text('Tải danh sách thất bại. Vuốt xuống để thử lại.'),
              ),
            ),
          );
        }
        if (state is LoadedContactPlaceState) {
          if (state.contactPlaces.isEmpty) {
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 120,
                  alignment: Alignment.center,
                  child: Text('Không có dữ liệu.'),
                ),
              ),
            );
          }

          List listItems = <Widget>[];
            for (int i = 0; i < state.contactPlaces.length; i++) {
              var item = state.contactPlaces[i];
              listItems.add(
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: BlocBuilder<CreateShipmentBloc, CreateShipmentState>(
                      bloc: createShipmentBloc,
                      builder: (context, state) {
                        if  (state is LoadedCreateShipmentState) {
                          if (state.shipment.pickerPhone == item.phone) {
                            return Text('${item.name} - ${item.phone}', style: TextStyle(color: colorPrimary),);
                          }
                        }
                        return Text('${item.name} - ${item.phone}');
                      }
                    ),
                    subtitle: Text('${item.fullAddress}'),
                    dense: true,
                    onTap: () {
                      Navigator.pop(context);
                      createShipmentBloc.dispatch(UpdatePickerEvent(
                        isSelectedPicker: true,
                        selectedPickerName: item.name,
                        selectedPickerPhone: item.phone,
                        selectedFromAddress: item.address,
                        selectedFromCityCode: item.cityCode,
                        selectedFromDistrictCode: item.districtCode,
                        selectedFromWardCode: item.wardCode,
                      ));
                      createShipmentBloc.dispatch(FetchRateCreateShipmentEvent());
                    },
                  ),
                ),
              );
//              listItems.add(
//                i < state.contactPlaces.length - 1 ? Divider() : Container()
//              );
            }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Container(
                  child: Column(
                    children: listItems
                  ),
                ),
              ),
            ),
          );
        }
        return Container(child: Text('Có lỗi xảy ra'));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactPlaceBloc, ContactPlaceState>(
          listener: (context, state) {
            if (state is FailureContactPlaceState) {
              notifyBloc.dispatch(ShowNotifyEvent(type: NotifyEvent.ERROR, message: state.error));
            }
          },
        ),
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
          backgroundColor: colorBackground,
          appBar: _buildAppBar(context),
          body: _buildContent(),
        ),
      ),
    );
  }
}
