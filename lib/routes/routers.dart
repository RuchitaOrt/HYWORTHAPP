
import 'package:flutter/material.dart';

import 'package:hyworth_land_survey/Screens/DashboardScreen.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Screens/login_screen.dart';
import 'package:hyworth_land_survey/Screens/splash_screen.dart';


class Routers {
  // Create a static method to configure the router
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.route:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
 case LoginScreen.route:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
         case DashboardScreen.route:
        return MaterialPageRoute(
          builder: (_) => DashboardScreen(),
        );
           case Maintabscreen.route:
        return MaterialPageRoute(
          builder: (_) => Maintabscreen(),
        );
 
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }

}
