import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionDetector {
//  static Future<bool> checkInternetConnection() async {
//   final connectivity = await Connectivity().checkConnectivity();
//   return connectivity != ConnectivityResult.none;
// }

  static Future<bool> checkInternetConnection() async {
    bool isInternetAvailable = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isInternetAvailable = true;
      }
    } catch (e) {
      print(e.toString());
    }
    return isInternetAvailable;
  }
}
