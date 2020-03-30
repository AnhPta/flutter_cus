import 'dart:async';

import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/repositories/city/city_repository.dart';
import 'package:app_customer/bloc/contact_place/bloc.dart';
import 'package:app_customer/repositories/contact_place/contact_place_repository.dart';
import 'package:app_customer/repositories/district/district_repository.dart';
import 'package:app_customer/repositories/ward/ward_repository.dart';
import 'package:app_customer/screens/components/animation_route.dart';
import 'package:app_customer/screens/components/circular_color.dart';
import 'package:app_customer/screens/contact_place/contact_place.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPlaceListPage extends StatelessWidget {
  final ContactPlaceRepository contactPlaceRepository;

  ContactPlaceListPage({
    Key key,
    @required this.contactPlaceRepository,
  })  : assert(contactPlaceRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:MainContactPlaceList(),
    );
  }
}

class MainContactPlaceList extends StatefulWidget {
  @override
  _MainContactPlaceListState createState() => _MainContactPlaceListState();
}

class _MainContactPlaceListState extends State<MainContactPlaceList> {
  final CityRepository cityRepository = CityRepository();
  final DistrictRepository districtRepository = DistrictRepository();
  final WardRepository wardRepository = WardRepository();

  NavigationBloc navigationBloc;
  NotifyBloc notifyBloc;

  ContactPlaceBloc contactPlaceBloc;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final TextEditingController _controller = TextEditingController();

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    notifyBloc = BlocProvider.of<NotifyBloc>(context);
    contactPlaceBloc = BlocProvider.of<ContactPlaceBloc>(context);
    contactPlaceBloc.dispatch(FetchContactPlaceEvent());
  }

  Future<Null> _filterContactPlace() async {
    await Future.delayed(Duration(milliseconds: 800));
    contactPlaceBloc.dispatch(FilterContactPlaceEvent(q: _controller.text));
    return null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      contactPlaceBloc.dispatch(LoadMoreContactPlaceEvent());
    }
  }

  _showModal(item) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return CupertinoAlertDialog(
          title: new Text("Xác nhận"),
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              text: item.status
                ? 'Bạn có muốn ngừng hoạt động địa chỉ '
                : 'Bạn có muốn khôi phục địa chỉ ',
              children: <TextSpan>[
                TextSpan(
                  text: '${item.name}',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                TextSpan(text: '?'),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Không', style: TextStyle(color: colorPrimary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Đồng ý', style: TextStyle(color: colorPrimary),),
              onPressed: () {
                Navigator.of(context).pop();
                contactPlaceBloc.dispatch(UpdateContactPlaceEvent(
                  id: item.id,
                  name: item.name,
                  phone: item.phone,
                  address: item.address,
                  cityCode: item.cityCode,
                  districtCode: item.districtCode,
                  wardCode: item.wardCode,
                  isMain: item.isMain,
                  isActive: item.status == true ? false : true
                ));
                contactPlaceBloc.dispatch(RefreshContactPlaceEvent());
              },
            ),

          ],
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      // ignore: missing_return
      pageBuilder: (context, animation1, animation2) {}
    );
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.clear();
    FocusScope.of(context).requestFocus(new FocusNode());
    contactPlaceBloc.dispatch(RefreshContactPlaceEvent());
    return null;
  }

  Widget _buildInputSearch() {
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
                  controller: _controller,
                  autocorrect: false,
                  onChanged: (searchText) {
                    _filterContactPlace();
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
                    contentPadding: EdgeInsets.only(top: 15.0),
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
      title: Text("Danh sách địa chỉ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16
          )),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      bottom: _buildInputSearch(),
      actions: <Widget>[
        Container(
          width: 60,
          child: FlatButton(
            child: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(context, FadeRoute(
                page: ContactPlaceFormPage(
                type: 'create'
              )));
            },
          ),
        )
      ],
    );
  }


  _fillDataFromContactPlace (item) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.push(context, FadeRoute(page: ContactPlaceFormPage(
      type: 'update',
      contactPlace: item,
    )));
    contactPlaceBloc.dispatch(UpdateFormContactPlaceEvent(
      isMain: item.isMain,
      wardCode: item.wardCode,
      wardName: item.wardName,
      districtCode: item.districtCode,
      districtName: item.districtName,
      cityName: item.cityName,
      cityCode: item.cityCode,
    ));
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
              new Container(
                margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text('${item.fullAddress}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                '${item.name} - ${item.phone}',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: new Row(
                            children: <Widget>[
                              Text(
                                '${item.statusTxt}',
                                style: TextStyle(
                                  fontSize: 15, color: item.status ? colorPrimary : Colors.orangeAccent),
                              ),
                              Text(
                                '${ item.isMain
                                  ? ' (Điểm mặc định)'
                                  : '' }',
                                style: TextStyle(
                                  fontSize: 15, color: colorAccent),
                              ),
                            ],
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                _fillDataFromContactPlace(item);
                              },
                              icon: Icon(
                                FontAwesomeIcons.edit,
                                size: 15,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showModal(item);
                              },
                              icon: item.status
                                ? Icon(
                                Icons.do_not_disturb_alt,
                                size: 17,
                                color: Colors.black
                              )
                                : Icon(
                                Icons.refresh,
                                size: 19,
                                color: Colors.black
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          listItems.add(
            state.pagination.currentPage < state.pagination.totalPages
              ? LoaderTwo() : Container()
          );

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              children: listItems,
            ),
          );

//          return RefreshIndicator(
//            key: _refreshIndicatorKey,
//            onRefresh: _refresh,
//            child: SingleChildScrollView(
//              controller: _scrollController,
//              physics: AlwaysScrollableScrollPhysics(),
//              child: SafeArea(
//                child: Container(
//                  child: Column(
//                    children: listItems
//                  ),
//                ),
//              ),
//            ),
//          );
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
