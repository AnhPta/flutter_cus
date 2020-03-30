import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:app_customer/repositories/pack_scan/pack_scan.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/utils/audio.dart';
import 'dart:math' show Random;

class PackScanBloc extends Bloc<PackScanEvent, PackScanState> {
  @override
  PackScanState get initialState => InitialPackScanState();

  @override
  Stream<PackScanState> mapEventToState(
    PackScanEvent event,
  ) async* {
    if (event is LoadPackScan) {
      yield* _mapLoadPackScanToState();
    } else if (event is AddPackScan) {
      yield* _mapAddPackScanToState(event);
    } else if (event is UpdatePackScan) {
      yield* _mapUpdatePackScanToState(event);
    } else if (event is DeletePackScan) {
      yield* _mapDeletePackScanToState(event);
    }
  }

  Stream<PackScanState> _mapLoadPackScanToState() async* {
    List<PackScan> packScans = [];
    var randomizer = new Random();
    for (var i = 0; i < 3; i++) {
      packScans.add(PackScan(
          code: 'FG000' + randomizer.nextInt(100).toString(),
          shipmentCode: 'FG0001',
          status: 'in_stock',
          scan: 1));
    }
    yield LoadedPackScanState(packScans);
  }

  Stream<PackScanState> _mapAddPackScanToState(AddPackScan event) async* {
    if (currentState is LoadedPackScanState) {
      String currentCode = (currentState as LoadedPackScanState).currentCode;
      if (currentCode != event.code) {
        List<PackScan> packScans =
            (currentState as LoadedPackScanState).packScans;
        yield LoadedPackScanState(packScans, event.code);
        var checkExist = packScans.firstWhere(
            (packScan) => packScan.code.startsWith(event.code),
            orElse: () => null);
        Audio.success();
        if (checkExist == null) {
          final List<PackScan> updatedPackScan = List.from(packScans
            ..insert(
                0,
                PackScan(
                    code: event.code,
                    shipmentCode: event.code,
                    status: 'in_stock',
                    scan: 1)));
          yield NotifyPackScanState(
              type: NotifyEvent.SUCCESS, message: 'Thành công' + event.code);
          yield LoadedPackScanState(updatedPackScan, event.code);
        }
      }
    }
  }

  Stream<PackScanState> _mapUpdatePackScanToState(UpdatePackScan event) async* {
    if (currentState is LoadedPackScanState) {
      PackScan packScan = event.packScan;
      List<PackScan> packScans =
          (currentState as LoadedPackScanState).packScans;
      final List<PackScan> updatedPackScan = packScans.map((item) {
        return item.code == packScan.code ? packScan : item;
      }).toList();
      yield LoadedPackScanState(updatedPackScan);
    }
  }

  Stream<PackScanState> _mapDeletePackScanToState(DeletePackScan event) async* {
    if (currentState is LoadedPackScanState) {
      PackScan packScan = event.packScan;
      List<PackScan> packScans =
          (currentState as LoadedPackScanState).packScans;
      final List<PackScan> updatedPackScan = packScans
          .where((item) => item.shipmentCode != packScan.shipmentCode)
          .toList();
      yield LoadedPackScanState(updatedPackScan);
    }
  }
}
