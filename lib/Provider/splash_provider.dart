
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
 
  SplashProvider(BuildContext context) {
 WidgetsBinding.instance.addPostFrameCallback((_) {
      callNextScreen();
    });
  }

  Future<void> callNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    // Navigator.of(
    //             routeGlobalKey.currentContext!,
    //           ).pushNamedAndRemoveUntil(
    //             WalkthroughScreen.route,
    //             (route) => false,
    //           );
  }

}
