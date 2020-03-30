import 'package:shared_preferences/shared_preferences.dart';

class DeviceStorage {
  Future<void> setTypeDevice(String typeDevice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('type_device', typeDevice);
  }

  Future<String> getTypeDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String typeDevice = (prefs.getString('type_device') ?? '');
    return typeDevice;
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('type_device');
  }
}
