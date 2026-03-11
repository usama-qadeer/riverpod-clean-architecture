import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  static Future<bool> hasConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result.first != ConnectivityResult.none;
  }
}
