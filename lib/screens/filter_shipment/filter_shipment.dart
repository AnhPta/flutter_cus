import 'package:app_customer/bloc/city/bloc.dart';
import 'package:app_customer/bloc/list_status/bloc.dart';
import 'package:app_customer/bloc/shipment/bloc.dart';
import 'package:app_customer/repositories/list_status/list_status_repository.dart';
import 'package:app_customer/screens/components/bottom_sheet_animation.dart';
import 'package:app_customer/screens/components/circular_color.dart';
import 'package:app_customer/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class FilterDialog extends StatefulWidget {
  final ShipmentBloc shipmentBloc;
  final ListStatusBloc listStatusBloc;
  final CityBloc cityBloc;
  final LoadedShipmentState state;
  final ListStatusRepository listStatusRepository;

  FilterDialog({
    Key key,
    @required this.shipmentBloc,
    this.listStatusBloc,
    this.listStatusRepository,
    this.cityBloc,
    @required this.state,
  }) : assert(shipmentBloc != null), assert(state != null), super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState(shipmentBloc: shipmentBloc, state: state);
}

class _FilterDialogState extends State<FilterDialog> {
  ShipmentBloc shipmentBloc;
  ListStatusBloc listStatusBloc;
  CityBloc cityBloc;
  LoadedShipmentState state;
  ListStatusRepository listStatusRepository;

  _FilterDialogState({
    Key key,
    @required this.shipmentBloc,
    this.listStatusBloc,
    this.listStatusRepository,
    this.cityBloc,
    @required this.state,
  }) : assert(shipmentBloc != null), assert(state != null);

  @override
  void initState() {
    super.initState();
    listStatusBloc = BlocProvider.of<ListStatusBloc>(context);
    cityBloc = BlocProvider.of<CityBloc>(context);
  }

  String confirmDate = '';
  String confirmDateRanger = '';
  String confirmDateRangerValue = '';

  static const statuses = [
    {'value': '', 'text': 'Tất cả các ngày'},
    {'value': '1', 'text': '1 ngày'},
    {'value': '3', 'text': '3 ngày'},
    {'value': '7', 'text': '7 ngày'},
    {'value': '30', 'text': '1 tháng'},
    {'value': '60', 'text': '2 tháng'},
    {'value': '90', 'text': '3 tháng'},
    {'value': '180', 'text': '6 tháng'},
  ];

  // FIlter Status
  Widget _buildAppBarFilterStatus() {
    return AppBar(
      brightness: Brightness.light,
      centerTitle: true,
      elevation: 0.5,
      backgroundColor: Colors.white,
      leading: IconButton( color: Colors.white,
        icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Trạng thái vận đơn', style: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
  Widget _buildBodyFilterStatus() {
    return new SingleChildScrollView(
      child: BlocBuilder<ListStatusBloc, ListStatusState>(
        bloc: listStatusBloc,
        builder: (content, state) {
          if (state is LoadingListStatusState) {
            return Container(
              height: 300,
              child: Center(
                child: LoaderTwo(),
              ),
            );
          }
          if (state is FailureListStatusState) {
            return Container(
              height: 300,
              child: Center(
                child: Text('Tải danh sách trạng thái vận đơn thất bại'),
              ),
            );
          }
          if (state is LoadedListStatusState) {
            return Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  trailing: (state.status == '' && state.showIcon)
                    ? Icon(Icons.check, color: Colors.black)
                    : null,
                  onTap: () {
                    shipmentBloc.dispatch(UpdateFilterStatusEvent(
                      status: '',
                      selectStatus: true,
                      statusTxt: 'Tất cả'
                    ));
                    listStatusBloc.dispatch(DisplayIconListStatusEvent(
                      isShowIcon: true,
                      status: ''
                    ));
                    Navigator.pop(context);
                  },
                  title: Text('Tất cả'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: state.listStatus.map((item) {
                    return ListTile(
                      onTap: () {
                        shipmentBloc.dispatch(UpdateFilterStatusEvent(
                          status: item.id,
                          selectStatus: true,
                          statusTxt: item.value
                        ));
                        listStatusBloc.dispatch(DisplayIconListStatusEvent(
                          isShowIcon: true,
                          status: item.id
                        ));
                        Navigator.pop(context);
                      },
                      dense: true,
                      title: Text(item.value),
                      trailing: (state.showIcon) && (item.id == state.status)
                        ? Icon(Icons.check, color: Colors.black)
                        : null,
                    );
                  }).toList()),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
  void _showFilterStatus() {
    showModalBottomSheetCustom(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return new Container(
          height: 380,
          child: Scaffold(
            appBar: _buildAppBarFilterStatus(),
            body: _buildBodyFilterStatus()
          ),
        );
      });
  }

  // Filter Tỉnh gửi
  Widget _buildAppBarFilterCityPop() {
    return new AppBar(
      brightness: Brightness.light,
      centerTitle: true,
      elevation: 0.5,
      backgroundColor: Colors.white,
      leading: IconButton(
        color: Colors.white,
        icon: Icon(Icons.chevron_left, color: Colors.black, size: 20),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Tỉnh gửi', style: TextStyle(
        fontSize: 16,
        color: Colors.black
      )),
    );
  }
  Widget _buildBodyFilterCityPop() {
    return new SingleChildScrollView(
      child: BlocBuilder<CityBloc, CityState>(
        bloc: cityBloc,
        builder: (content, state) {
          if (state is LoadingCityState) {
            return Container(
              height: 300,
              child: Center(
                child: LoaderTwo(),
              ),
            );
          }
          if (state is FailureCityState) {
            return Container(
              height: 300,
              child: Center(
                child: Text('Tải danh sách tỉnh gửi thất bại'),
              ),
            );
          }
          if (state is LoadedCityState) {
            return new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.cities.map((item) {
                return new ListTile(
                  onTap: () {
                    shipmentBloc.dispatch(UpdateFilterCityPopEvent(
                      cityPopCode: item.code,
                      cityPopName: item.name,
                      selectCityPop: true
                    ));
                    Navigator.pop(context);
                  },
                  dense: true,
                  title: Text('${item.name}'),
                );
              }).toList());
          }
          return Container();
        },
      ),
    );
  }
  void _showFilterCityPop() {
    showModalBottomSheetCustom(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return new Container(
          height: 380,
          child: Scaffold(
            appBar: _buildAppBarFilterCityPop(),
            body: _buildBodyFilterCityPop()
          ),
        );
      });
  }

  // Filter Tỉnh nhận
  Widget _buildAppBarFilterCityPick() {
    return new AppBar(
      brightness: Brightness.light,
      centerTitle: true,
      elevation: 0.5,
      backgroundColor: Colors.white,
      leading: IconButton(
        color: Colors.white,
        icon: Icon(Icons.chevron_left, color: Colors.black, size: 20),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Tỉnh nhận', style: TextStyle(
        fontSize: 16,
        color: Colors.black
      )),
    );
  }
  Widget _buildBodyFilterCityPick() {
    return new SingleChildScrollView(
      child: BlocBuilder<CityBloc, CityState>(
        bloc: cityBloc,
        builder: (content, state) {
          if (state is LoadingCityState) {
            return Container(
              height: 300,
              child: Center(
                child: LoaderTwo(),
              ),
            );
          }
          if (state is FailureCityState) {
            return Container(
              height: 300,
              child: Center(
                child: Text('Tải danh sách tỉnh nhận thất bại'),
              ),
            );
          }
          if (state is LoadedCityState) {
            return new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.cities.map((item) {
                return new ListTile(
                  onTap: () {
                    shipmentBloc.dispatch(UpdateFilterCityPickEvent(
                      cityPickCode: item.code,
                      cityPickName: item.name,
                      selectCityPick: true
                    ));
                    Navigator.pop(context);
                  },
                  dense: true,
                  title: Text('${item.name}'),
                );
              }).toList());
          }
          return Container();
        },
      ),
    );
  }
  void _showFilterCityPick() {
    showModalBottomSheetCustom(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return new Container(
          height: 380,
          child: Scaffold(
            appBar: _buildAppBarFilterCityPick(),
            body: _buildBodyFilterCityPick()
          ),
        );
      });
  }

  void _showFilterSelectDate()  {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2018, 3, 5),
      maxTime: DateTime.now(),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        setState(() {
          confirmDate = DateFormat("yyyy-MM-dd").format(date);
          shipmentBloc.dispatch(UpdateFilterCreateDateEvent(createDate: confirmDate));
        });
      },
      locale: LocaleType.vi
    );
  }

  // Filter Theo thời gian
  Widget _buildAppBarFilterDateRanger() {
    return new AppBar(
      brightness: Brightness.light,
      centerTitle: true,
      elevation: 0.5,
      backgroundColor: Colors.white,
      leading: IconButton( color: Colors.white,
        icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Chọn ngày', style: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
  Widget _buildBodyFilterDateRanger() {
    return new SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: statuses.map((item) {
          return ListTile(
            onTap: () {
              setState(() {
                confirmDateRanger = item['text'];
                confirmDateRangerValue = item['value'];
              });
              shipmentBloc.dispatch(UpdateFilterDateRangerEvent(
                dateRangerTxt: confirmDateRanger,
                dateRanger: confirmDateRangerValue)
              );
              Navigator.pop(context);
            },
            dense: true,
            title: Text(item['text']),
          );
        }).toList()
      ),
    );
  }
  void _showFilterDateRanger() {
    showModalBottomSheetCustom(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return new Container(
          height: 380,
          child: Scaffold(
            appBar: _buildAppBarFilterDateRanger(),
            body: _buildBodyFilterDateRanger()
          ),
        );
      });
  }

  Widget _buildFilterStatus() {
    return ListTile(
      onTap: () {
        listStatusBloc.dispatch(FetchListStatusEvent());
        _showFilterStatus();
      },
      dense: true,
      leading: Text("Trạng thái"),
      title: Container(
        alignment: Alignment.centerRight,
        child: BlocBuilder<ShipmentBloc, ShipmentState>(
          bloc: shipmentBloc,
          builder: (context, state) {
            if (state is LoadedShipmentState) {
              return Text(
                state.selectStatus ? state.filterShipment.statusTxt : '',
                style: TextStyle(fontWeight: FontWeight.bold));
            }
            return Container();
          }
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.black),
    );
  }

  Widget _buildFilterCityPop() {
    return ListTile(
      onTap: () {
        cityBloc.dispatch(FetchCityEvent());
        _showFilterCityPop();
      },
      dense: true,
      leading: Text("Tỉnh gửi"),
      title: Container(
        alignment: Alignment.centerRight,
        child: BlocBuilder<ShipmentBloc, ShipmentState>(
          bloc: shipmentBloc,
          builder: (context, state) {
            if (state is LoadedShipmentState) {
              return Text( state.selectCityPop
                ? state.filterShipment.cityPopName
                : '',
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }
            return Container();
          }
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.black),
    );
  }
  Widget _buildFilterCityPick() {
    return ListTile(
      onTap: () {
        cityBloc.dispatch(FetchCityEvent());
        _showFilterCityPick();
      },
      dense: true,
      leading: Text("Tỉnh nhận"),
      title: Container(
        alignment: Alignment.centerRight,
        child: BlocBuilder<ShipmentBloc, ShipmentState>(
          bloc: shipmentBloc,
          builder: (context, state) {
            if (state is LoadedShipmentState) {
              return Text( state.selectCityPick
                ? state.filterShipment.cityPickName
                : '',
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }
            return Container();
          }
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.black),
    );
  }

  Widget _buildFilterCreateDate() {
    return new ListTile(
      onTap: () {
        _showFilterSelectDate();
      },
      dense: true,
      leading: Text("Ngày tạo", ),
      title: Container(
        alignment: Alignment.centerRight,
        child: BlocBuilder<ShipmentBloc, ShipmentState>(
          bloc: shipmentBloc,
          builder: (context, state) {
            if (state is LoadedShipmentState) {
              if (state.filterShipment != null) {
                return Text(state.filterShipment.createDate,
                  style: TextStyle(fontWeight: FontWeight.bold));
              }
            }
            return Container();
          }
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.black),
    );
  }
  Widget _buildFilterDateRanger() {
    return ListTile(
      onTap: () {
        _showFilterDateRanger();
      },
      dense: true,
      leading: Text("Theo thời gian"),
      title: Container(
        alignment: Alignment.centerRight,
        child: BlocBuilder<ShipmentBloc, ShipmentState>(
          bloc: shipmentBloc,
          builder: (context, state) {
            if (state is LoadedShipmentState) {
              if (state.filterShipment != null) {
                return Text(state.filterShipment.dateRangerTxt,
                  style: TextStyle(fontWeight: FontWeight.bold));
              }
            }
            return Container();
          }
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.black),
    );
  }

  Widget _buildAppBarFilter() {
    return AppBar(
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
      title: Text('Bộ lọc',
        style: TextStyle(fontSize: 16, color: Colors.black)),
      actions: <Widget>[
        FlatButton(
          color: Colors.white,
          onPressed: () {
            shipmentBloc.dispatch(ClearFilterShipmentEvent());
            shipmentBloc.dispatch(RefreshShipmentEvent());
            listStatusBloc.dispatch(DisplayIconListStatusEvent(isShowIcon: false));
            Navigator.of(context).pop();
          },
          child: Text('Xóa lọc',
            style: TextStyle(fontSize: 14, color: colorPrimary)),
        )
      ],
    );
  }
  Widget _buildBodyFilter() {
    return new SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  _buildFilterStatus(),
                  Divider(height: 0),
                  _buildFilterCityPop(),
                  Divider(height: 0),
                  _buildFilterCityPick(),
                  Divider(height: 0),
                  _buildFilterCreateDate(),
                  Divider(height: 0),
                  _buildFilterDateRanger(),
                  Divider(height: 0),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
  Widget _buildBottomNavBarFilter() {
    return new Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 60,
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 42,
        child: BlocBuilder<ShipmentBloc, ShipmentState>(
          bloc: shipmentBloc,
          builder: (context, state) {
            if (state is LoadedShipmentState) {
              return FlatButton(
                color: Color(0xFFef5222),
                textColor: Colors.white,
                splashColor: Colors.white,
                onPressed: () {
                  shipmentBloc.dispatch(ApplyFilterShipmentEvent(countFilter: state.filterShipment.filterShipmentLenght()));
                  Navigator.of(context).pop();
                },
                shape: new RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.circular(30.0)),
                child: Text('Áp dụng'));
            }
            return Container();
          }
        ),
      ),
    );
  }

  Widget _showModalListStatus() {
    return Container(
      height: 380,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBarFilter(),
        body: _buildBodyFilter(),
        bottomNavigationBar: _buildBottomNavBarFilter(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return _showModalListStatus();
  }
}
