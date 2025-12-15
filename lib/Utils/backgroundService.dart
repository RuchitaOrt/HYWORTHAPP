import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyworth_land_survey/Utils/APIManager.dart';
import 'package:hyworth_land_survey/Utils/SyncService.dart';
import 'package:workmanager/workmanager.dart';
const String syncTask = "syncSurveyData";

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("Background task running: $task");

//     try {
//       // Re-initialize any needed services
//       WidgetsFlutterBinding.ensureInitialized();
      
//       await SyncService.syncAll();
//       print("Background sync completed!");
//       return Future.value(true);
//     } catch (e, stack) {
//       print("Background sync failed: $e");
//       print(stack);
//       return Future.value(false);
//     }
//   });
// }
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load config in background isolate (required!)
    final jsonStr = await rootBundle.loadString("assets/API-Configuration.json");
    APIManager().loadConfiguration(jsonStr);

    print("Background API config loaded");

    await SyncService.syncAll();

    return Future.value(true);
  });
}


