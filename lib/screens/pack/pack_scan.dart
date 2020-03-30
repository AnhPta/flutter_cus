import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_customer/bloc/pack_scan/bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:screen/screen.dart';

class PackScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            builder: (context) {
              return PackScanBloc();
            },
            child: MainSection()));
  }
}

class MainSection extends StatefulWidget {
  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  PackScanBloc packScanBloc;

  @override
  void initState() {
    super.initState();
    packScanBloc = BlocProvider.of<PackScanBloc>(context);
    packScanBloc.dispatch(LoadPackScan());
    Screen.keepOn(true);
  }

  @override
  void dispose() {
    Screen.keepOn(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('start 111111111111');
    return MultiBlocListener(
      listeners: [
        BlocListener<PackScanBloc, PackScanState>(listener: (context, state) {
          if (state is NotifyPackScanState) {
            // BlocProvider.of<NotifyBloc>(context).dispatch(ShowNotifyEvent(type: state.type, message: state.message));
          }
        }),
      ],
      child: Container(
          child: Column(
        children: <Widget>[
          UpperSection(packScanBloc: packScanBloc),
          MiddleSection(packScanBloc: packScanBloc),
          BottomSection(),
        ],
      )),
    );
  }
}

class UpperSection extends StatelessWidget {
  final PackScanBloc packScanBloc;

  UpperSection({Key key, @required this.packScanBloc})
      : assert(packScanBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    print('start 222222222222222222');
    return Expanded(
        flex: 4,
        child: Center(
          child: SizedBox(
            child: QrCamera(
              onError: (context, error) => Text(
                error.toString(),
                style: TextStyle(color: Colors.red),
              ),
              qrCodeCallback: (code) {
                _addPackScan(code);
              },
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.lightbulb_outline),
                      color: Colors.white,
                      onPressed: () {
                        QrMobileVision.toggleFlash();
                      },
                    ),
                  ],
                ),
              )),
              notStartedBuilder: (BuildContext context) {
                return Center(child: Text('Đang tải...'));
              },
            ),
          ),
        ));
  }

  _addPackScan(_code) {
    packScanBloc.dispatch(AddPackScan(code: _code));
  }
}

class MiddleSection extends StatelessWidget {
  final PackScanBloc packScanBloc;

  MiddleSection({Key key, @required this.packScanBloc})
      : assert(packScanBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 7,
        child: Container(
            color: Colors.white,
            child: BlocBuilder<PackScanBloc, PackScanState>(
              builder: (context, state) {
                if (state is LoadedPackScanState) {
                  if (state.packScans.isEmpty) {
                    return Center(
                      child: Text('Không có dữ liệu'),
                    );
                  }
                  return ListView.separated(
                      separatorBuilder: (context, index) => Divider(height: 0),
                      padding: const EdgeInsets.all(0.0),
                      itemCount: state.packScans.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildSlidable(state, index);
                      });
                }
                return Center(
                  child: Text('Không có dữ liệu'),
                );
              },
            )));
  }

  Slidable _buildSlidable(LoadedPackScanState state, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(state.packScans[index].code),
          subtitle: Text('Cầu Giấy', style: TextStyle(color: Colors.black)),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _getStatus(state.packScans[index].status),
              Icon(Icons.brightness_1, color: Colors.green),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Thất lạc',
          color: Colors.deepPurple,
          icon: Icons.not_listed_location,
          onTap: () {
            _lostPackScan(state.packScans[index]);
          },
        ),
        IconSlideAction(
          foregroundColor: Colors.white,
          caption: 'Suy suyển',
          color: Colors.orange,
          icon: Icons.priority_high,
          onTap: () {
            _failPackScan(state.packScans[index]);
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Xóa',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _deletePackScan(state.packScans[index]);
          },
        ),
      ],
    );
  }

  _getStatus(status) {
    String statusText;
    var statusColor;
    switch (status) {
      case 'in_stock':
        statusText = 'Đang trong kho';
        statusColor = Colors.blue;
        break;
      case 'fail':
        statusText = 'Suy suyển';
        statusColor = Colors.orange;
        break;
      case 'lost':
        statusText = 'Thất lạc';
        statusColor = Colors.deepPurple;
        break;
    }
    return Text(statusText, style: TextStyle(color: statusColor));
  }

  _lostPackScan(packScan) {
    packScanBloc.dispatch(UpdatePackScan(packScan.copyWith(status: 'lost')));
  }

  _failPackScan(packScan) {
    packScanBloc.dispatch(UpdatePackScan(packScan.copyWith(status: 'fail')));
  }

  _deletePackScan(packScan) {
    packScanBloc.dispatch(DeletePackScan(packScan));
  }
}

class BottomSection extends StatelessWidget {
  const BottomSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: BlocBuilder<PackScanBloc, PackScanState>(
          builder: (context, state) {
            if (state is LoadedPackScanState) {
              int count = state.packScans.length;

              return Container(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Nhóm F2'),
                              Text('$count kiện')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.blue,
                        child: FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {},
                          child: Text(
                            "Xác nhận",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(
              child: Text('Không có dữ liệu'),
            );
          },
        ));
  }
}
