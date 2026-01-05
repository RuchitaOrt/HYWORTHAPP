import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';

import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/login_screen.dart';
import 'package:hyworth_land_survey/Utils/UtilityFile.dart';
import 'package:hyworth_land_survey/Utils/backgroundService.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/routes/routers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied ||
      await Permission.notification.isRestricted) {
    final status = await Permission.notification.request();
    debugPrint("🔔 Notification permission: $status");
  }
}

Future<void> initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');

  const settings = InitializationSettings(android: android);

  await flutterLocalNotificationsPlugin.initialize(settings);
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> routeGlobalKey = GlobalKey();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//await DatabaseHelper.instance.deleteOldDatabase();

  await initNotifications(); // 🔥 REQUIRED
  await requestNotificationPermission();
  await Utility().loadAPIConfig();
// Initialize Workmanager
await Workmanager().initialize(
  callbackDispatcher,
  isInDebugMode: true,
);

// Register periodic task to cover network off scenario
await Workmanager().registerPeriodicTask(
  "syncTaskPeriodic",
  syncTask,
  frequency: const Duration(minutes: 60),
  constraints: Constraints(
    networkType: NetworkType.connected,
  ),
);

// Optional: listen to connectivity for instant trigger
Connectivity().onConnectivityChanged.listen((status) {
  if (status != ConnectivityResult.none) {
    Workmanager().registerOneOffTask(
      "syncTaskImmediate",
      syncTask,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
});

//  //Initialize Workmanager
  // await Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true, // prints logs for debugging
  // );
 
// await Workmanager().registerOneOffTask(
//   "syncTask",
//   syncTask,
//   constraints: Constraints(
//     networkType: NetworkType.connected, // 🔥 CRITICAL
//   ),
//   backoffPolicy: BackoffPolicy.linear,
//   backoffPolicyDelay: const Duration(minutes: 2),
// );
 // await Workmanager().registerOneOffTask(
  //   "testTask",
  //   syncTask,
  //   initialDelay: Duration(seconds: 5), // triggers 5s after app start
  // );
  // await Workmanager().registerPeriodicTask(
  //   "backgroundSync",
  //   "syncSurveyData",
  //   frequency: Duration(hours: 1),
  //   initialDelay: Duration(seconds: 10),
  //   constraints: Constraints(
  //     networkType: NetworkType.connected,
  //   ),
  // );

  // Optional: run every 15 minutes in background
  // Workmanager().registerPeriodicTask(
  //   "syncTaskPeriodic",
  //   syncTask,
  //   frequency: Duration(minutes: 15),
  // );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
