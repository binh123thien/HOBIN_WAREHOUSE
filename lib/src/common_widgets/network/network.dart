import 'package:connectivity_plus/connectivity_plus.dart';

class NetWork {
  static Future<String> checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return "Mobile Network";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return "Wifi Network";
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return "Ethernet Network";
    } else if (connectivityResult == ConnectivityResult.vpn) {
      return "VPN Network";
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return "Bluetooth Network";
    } else if (connectivityResult == ConnectivityResult.other) {
      return "Other Network";
    } else if (connectivityResult == ConnectivityResult.none) {
      return "Not Connected";
    } else {
      return "Not Connected";
    }
  }
}
