import 'dart:async';

import 'package:ipsb_visitor_app/src/algorithm/ipsb_positioning/filters/kalman_filter_2d.dart';
import 'package:ipsb_visitor_app/src/algorithm/ipsb_positioning/models/location_2d.dart';
import 'package:ipsb_visitor_app/src/algorithm/ipsb_positioning/positioning/ble_positioning.dart';
import 'package:ipsb_visitor_app/src/algorithm/ipsb_positioning/positioning/pdr_positioning.dart';
import 'package:ipsb_visitor_app/src/algorithm/ipsb_positioning/positioning/positioning.dart';
import 'package:ipsb_visitor_app/src/algorithm/ipsb_positioning/utils/const.dart';

mixin IDataFusion {
  void init({
    required PositioningConfig bleConfig,
    required PositioningConfig pdrConfig,
  });
  void start();
  void stop();
}

class DataFusion implements IDataFusion {
  /// Delay duration
  final Duration longerInterval = const Duration(milliseconds: 2700);

  /// 2d kalman filter
  final KalmanFilter2d _filter = KalmanFilter2d(
    processNoise: 0.005,
    measurementNoise: 1.25,
  );

  /// Ble positioning method
  late final IBlePositioning _blePositioning;

  /// Pdr positioning method
  late final IPdrPositioning _pdrPositioning;

  /// Timer for periodic fusion workflow
  Timer? _timer;

  /// Current location;
  Location2d? _current;

  /// Current floor
  int? _currentFloor;

  /// On location updated
  final void Function(Location2d) onChange;

  DataFusion({required this.onChange});

  @override
  void init({required bleConfig, required pdrConfig}) {
    // Init config for Ble method
    _blePositioning = BlePositioning();
    _blePositioning.init(bleConfig);

    // Init config for Pdr method
    _pdrPositioning = PdrPositioning();
    _pdrPositioning.init(pdrConfig);
  }

  @override
  void start() async {
    runPeriodic();
    initBleMethod();
    await initPdrMethod();
  }

  void initBleMethod() {
    _blePositioning.start();
    _blePositioning.currentFloorEvents.listen((e) async {
      if (_currentFloor != null && e != _currentFloor) {
        _timer?.cancel();
        _pdrPositioning.pause();
        _current = await initLocation();
        _pdrPositioning.setInitial(_current);
        runPeriodic();
      }
      _currentFloor = e;
    });
  }

  Future<void> initPdrMethod() async {
    // Init the initial location with ble method
    _current = await initLocation();
    // Set the initial location for pdr method
    _pdrPositioning.start();
    _pdrPositioning.setInitial(_current);
    _pdrPositioning.locationEvents.listen((e) {
      _current = e;
      onChange(e);
    });
  }

  void runPeriodic() {
    _timer = Timer.periodic(longerInterval, (timer) async {
      _pdrPositioning.resume();
      await Future.delayed(Const.longInterval, () {
        _pdrPositioning.pause();
        _filter.predict(_current!);
        final measured = _blePositioning.resolve();
        _filter.correct(measured!);
        _current = _filter.state;
        onChange(_current!);
      });
    });
  }

  @override
  void stop() {
    _timer?.cancel();
    _blePositioning.stop();
    _pdrPositioning.stop();
  }

  Future<Location2d> initLocation() async {
    final location = await Future.delayed(Const.longInterval, () {
      return _blePositioning.resolve();
    });
    return location!;
  }
}
