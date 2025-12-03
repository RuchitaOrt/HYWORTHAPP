import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/login_screen.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/routes/routers.dart';
import 'package:provider/provider.dart';



final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> routeGlobalKey = GlobalKey();
Future<void> main() async {
 
WidgetsFlutterBinding.ensureInitialized();
//await DatabaseHelper.instance.deleteOldDatabase();
SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp() : super();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
   
        ChangeNotifierProvider<AppProvider>(
          create: (context) => AppProvider(),
        ),
         ChangeNotifierProvider<BasicFormProvider>(
          create: (context) => BasicFormProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        title: 'Hyworth Land Survey',
        debugShowCheckedModeBanner: false,
        navigatorKey: routeGlobalKey,
        theme: ThemeData(
          textTheme: GoogleFonts.mulishTextTheme(),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor:
                CommonColors.blue.withOpacity(0.3), // background highlight
            selectionHandleColor: CommonColors.blue, // draggable handle
            cursorColor: CommonColors.blue, // fallback cursor
          ),
        ),
        initialRoute: LoginScreen.route,
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }
}
