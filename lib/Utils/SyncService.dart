import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Utils/APIManager.dart';
import 'package:hyworth_land_survey/Utils/RetryHelper.dart';
import 'package:hyworth_land_survey/Utils/SyncNotification.dart';
import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
import 'package:hyworth_land_survey/model/LandStateModel.dart';
import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
import 'package:hyworth_land_survey/model/LandVillagesModel.dart';

class SyncService {
  static const int limit = 5000;

  static const int stateNotifyId = 2001;
  static const int districtNotifyId = 2002;
  static const int talukaNotifyId = 2003;
  static const int villageNotifyId = 2004;

  // ================= STATES =================
  static Future<void> fetchStates() async {
    int page = await DatabaseHelper.instance.getSyncState("states_page") ?? 1;
    int totalPages = 1;

    while (true) {
      await retry(() async {
        await APIManager().apiRequestWithoutContext(
          API.states,
          (resp) async {
            final result = resp as LandStateModel;
            totalPages = result.pagination?.totalPages ?? 1;

            await DatabaseHelper.instance.insertStates(result.data ?? []);
            await DatabaseHelper.instance.setSyncState("states_page", page);

            final percent = ((page / totalPages) * 100).toInt();
            await SyncNotification.update(
              id: stateNotifyId,
              title: "Syncing States",
              body: "Page $page / $totalPages",
              progress: percent,
            );
          },
          (err) => throw Exception(),
          jsonval: {"page": page, "limit": limit},
        );
      });

      if (page >= totalPages) break;
      page++;
    }

    await DatabaseHelper.instance.clearSyncState("states_page");

    await SyncNotification.update(
      id: stateNotifyId,
      title: "States Sync",
      body: "States sync",
      completed: true,
    );
  }

  // ================= DISTRICTS =================
  static Future<void> fetchDistricts() async {
    int page =
        await DatabaseHelper.instance.getSyncState("district_page") ?? 1;
    int totalPages = 1;

    while (true) {
      await retry(() async {
        await APIManager().apiRequestWithoutContext(
          API.districts,
          (resp) async {
            final result = resp as LandDistrictModel;
            totalPages = result.pagination?.totalPages ?? 1;

            await DatabaseHelper.instance.insertDistrict(result.data ?? []);
            await DatabaseHelper.instance.setSyncState("district_page", page);

            final percent = ((page / totalPages) * 100).toInt();
            await SyncNotification.update(
              id: districtNotifyId,
              title: "Syncing Districts",
              body: "Page $page / $totalPages",
              progress: percent,
            );
          },
          (err) => throw Exception(),
          jsonval: {"page": page, "limit": limit},
        );
      });

      if (page >= totalPages) break;
      page++;
    }

    await DatabaseHelper.instance.clearSyncState("district_page");

    await SyncNotification.update(
      id: districtNotifyId,
      title: "Districts Sync",
      body: "District sync",
      completed: true,
    );
  }

  // ================= TALUKA =================
  static Future<void> fetchTaluka() async {
    int page =
        await DatabaseHelper.instance.getSyncState("taluka_page") ?? 1;
    int totalPages = 1;

    while (true) {
      await retry(() async {
        await APIManager().apiRequestWithoutContext(
          API.talukas,
          (resp) async {
            final result = resp as LandTalukaModel;
            totalPages = result.pagination?.totalPages ?? 1;

            await DatabaseHelper.instance.insertTaluka(result.data ?? []);
            await DatabaseHelper.instance.setSyncState("taluka_page", page);

            final percent = ((page / totalPages) * 100).toInt();
            await SyncNotification.update(
              id: talukaNotifyId,
              title: "Syncing Talukas",
              body: "Page $page / $totalPages",
              progress: percent,
            );
          },
          (err) => throw Exception(),
          jsonval: {"page": page, "limit": limit},
        );
      });

      if (page >= totalPages) break;
      page++;
    }

    await DatabaseHelper.instance.clearSyncState("taluka_page");

    await SyncNotification.update(
      id: talukaNotifyId,
      title: "Taluka Sync",
      body: "Taluka sync",
      completed: true,
    );
  }

  // ================= VILLAGES =================
  static Future<void> fetchVillage() async {
    int page =
        await DatabaseHelper.instance.getSyncState("village_page") ?? 1;
    int totalPages = 1;

    while (true) {
      await retry(() async {
        await APIManager().apiRequestWithoutContext(
          API.villages,
          (resp) async {
            final result = resp as LandVillagesModel;
            totalPages = result.pagination?.totalPages ?? 1;

            await DatabaseHelper.instance.insertVillage(result.data ?? []);
            await DatabaseHelper.instance.setSyncState("village_page", page);

            final percent = ((page / totalPages) * 100).toInt();
            await SyncNotification.update(
              id: villageNotifyId,
              title: "Syncing Villages",
              body: "Page $page / $totalPages",
              progress: percent,
            );
          },
          (err) => throw Exception(),
          jsonval: {"page": page, "limit": limit},
        );
      });

      if (page >= totalPages) break;
      page++;
    }

    await DatabaseHelper.instance.clearSyncState("village_page");

    await SyncNotification.update(
      id: villageNotifyId,
      title: "Village Sync",
      body: "Village sync",
      completed: true,
    );
  }

  // ================= MASTER =================
  static Future<void> syncAll() async {
    await fetchStates();
    await fetchDistricts();
    await fetchTaluka();
    await fetchVillage();
  }
}

// import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
// import 'package:hyworth_land_survey/Utils/APIManager.dart';
// import 'package:hyworth_land_survey/Utils/RetryHelper.dart';
// import 'package:hyworth_land_survey/Utils/SyncNotification.dart';
// import 'package:hyworth_land_survey/model/LandStateModel.dart';
// import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
// import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
// import 'package:hyworth_land_survey/model/LandVillagesModel.dart';

// class SyncService {
//   static const int limit = 5000;

//   // ================= STATES =================
//   static Future<void> fetchStates() async {
//     int page =
//         await DatabaseHelper.instance.getSyncState("states_page") ?? 1;
//     int totalPages = 1;

//     while (true) {
//       await retry(() async {
//         SyncNotification.update(
//           title: "Syncing States",
//           body: "Fetching page $page",
//           progress: 0,
//         );

//         await APIManager().apiRequestWithoutContext(
//           API.states,
//           (resp) async {
//             LandStateModel result = resp;
//             totalPages = result.pagination?.totalPages ?? 1;

//             await DatabaseHelper.instance.insertStates(result.data ?? []);
//             await DatabaseHelper.instance.setSyncState("states_page", page);

//             final percent = ((page / totalPages) * 100).toInt();
//             SyncNotification.update(
//               title: "Syncing States",
//               body: "Page $page / $totalPages",
//               progress: percent,
//             );
//           },
//           (err) => throw Exception(),
//           jsonval: {"page": page, "limit": limit},
//         );
//       });

//       if (page >= totalPages) break;
//       page++;
//     }

//     await DatabaseHelper.instance.clearSyncState("states_page");
//   }

//   // ================= DISTRICTS =================
//   static Future<void> fetchDistricts() async {
//     int page =
//         await DatabaseHelper.instance.getSyncState("district_page") ?? 1;
//     int totalPages = 1;

//     while (true) {
//       await retry(() async {
//         SyncNotification.update(
//           title: "Syncing Districts",
//           body: "Fetching page $page",
//         );

//         await APIManager().apiRequestWithoutContext(
//           API.districts,
//           (resp) async {
//             LandDistrictModel result = resp;
//             totalPages = result.pagination?.totalPages ?? 1;

//             await DatabaseHelper.instance.insertDistrict(result.data ?? []);
//             await DatabaseHelper.instance.setSyncState("district_page", page);

//             SyncNotification.update(
//               title: "Syncing Districts",
//               body: "Page $page / $totalPages",
//               progress: ((page / totalPages) * 100).toInt(),
//             );
//           },
//           (err) => throw Exception(),
//           jsonval: {"page": page, "limit": limit},
//         );
//       });

//       if (page >= totalPages) break;
//       page++;
//     }

//     await DatabaseHelper.instance.clearSyncState("district_page");
//   }

//   // ================= TALUKA =================
//   static Future<void> fetchTaluka() async {
//     int page =
//         await DatabaseHelper.instance.getSyncState("taluka_page") ?? 1;
//     int totalPages = 1;

//     while (true) {
//       await retry(() async {
//         SyncNotification.update(
//           title: "Syncing Talukas",
//           body: "Fetching page $page",
//         );

//         await APIManager().apiRequestWithoutContext(
//           API.talukas,
//           (resp) async {
//             LandTalukaModel result = resp;
//             totalPages = result.pagination?.totalPages ?? 1;

//             await DatabaseHelper.instance.insertTaluka(result.data ?? []);
//             await DatabaseHelper.instance.setSyncState("taluka_page", page);

//             SyncNotification.update(
//               title: "Syncing Talukas",
//               body: "Page $page / $totalPages",
//               progress: ((page / totalPages) * 100).toInt(),
//             );
//           },
//           (err) => throw Exception(),
//           jsonval: {"page": page, "limit": limit},
//         );
//       });

//       if (page >= totalPages) break;
//       page++;
//     }

//     await DatabaseHelper.instance.clearSyncState("taluka_page");
//   }

//   // ================= VILLAGES =================
//   static Future<void> fetchVillage() async {
//     int page =
//         await DatabaseHelper.instance.getSyncState("village_page") ?? 1;
//     int totalPages = 1;

//     while (true) {
//       await retry(() async {
//         SyncNotification.update(
//           title: "Syncing Villages",
//           body: "Fetching page $page",
//         );

//         await APIManager().apiRequestWithoutContext(
//           API.villages,
//           (resp) async {
//             LandVillagesModel result = resp;
//             totalPages = result.pagination?.totalPages ?? 1;

//             await DatabaseHelper.instance.insertVillage(result.data ?? []);
//             await DatabaseHelper.instance.setSyncState("village_page", page);

//             SyncNotification.update(
//               title: "Syncing Villages",
//               body: "Page $page / $totalPages",
//               progress: ((page / totalPages) * 100).toInt(),
//             );
//           },
//           (err) => throw Exception(),
//           jsonval: {"page": page, "limit": limit},
//         );
//       });

//       if (page >= totalPages) break;
//       page++;
//     }

//     await DatabaseHelper.instance.clearSyncState("village_page");
//   }

//   // ================= MASTER =================
//   static Future<void> syncAll() async {
//     SyncNotification.update(
//       title: "Data Sync",
//       body: "Starting sync...",
//       progress: 0,
//     );

//     await fetchStates();
//     await fetchDistricts();
//     await fetchTaluka();
//     await fetchVillage();

//     SyncNotification.update(
//       title: "Sync Complete",
//       body: "All data downloaded successfully",
//       completed: true,
//     );
//   }
// }

// // // // sync_service.dart
// // // import 'dart:convert';
// // // import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
// // // import 'package:hyworth_land_survey/Utils/APIManager.dart';
// // // import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
// // // import 'package:hyworth_land_survey/model/LandStateModel.dart';
// // // import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
// // // import 'package:hyworth_land_survey/model/LandVillagesModel.dart';

// // // class SyncService {
// // //   // Fetch States
// // //   static Future<void> fetchStates() async {
// // //      List<StateData> allStates = [];

// // //     int page = 1;
// // //     int limit = 5000; // based on your API response
// // //     int totalPages = 1;

// // //     while (true) {
// // //       print("Fetching page state $page");

// // //       // API BODY
// // //       final requestBody = {
// // //         "page": page,
// // //         "limit": limit,
// // //       };
// // // print("Fetching page $requestBody");
// // //   print("Fetching page state ${API.states}");

// // //       var response = await APIManager().apiRequestWithoutContext(
        
// // //         API.states,
// // //         (resp) {
// // //             print("Fetching page state ${resp}");
// // //           LandStateModel result = resp;
// // //            print("Fetching page ${API.states}");
// // //           print("Fetching page state $result");
// // //           final pageData = result.data ?? [];
// // //           allStates.addAll(pageData);

// // //           // UPDATE TOTAL PAGES (from pagination object)
// // //           totalPages = result.pagination?.totalPages ?? 1;
// // //           print("Fetched ${pageData.length} items from page $page");
// // //         },
// // //         (err) {
// // //             print("Fetching page state err ${err}");
// // //         },
// // //         jsonval: requestBody,
// // //       );

// // //       // ADD DATA

// // //       // STOP WHEN LAST PAGE REACHED
// // //       if (page >= totalPages) break;

// // //       page++;
// // //     }

// // //     print("Total items fetched = ${allStates.length}");

// // //     // SAVE TO DATABASE
// // //     await DatabaseHelper.instance.clearStates();
// // //     await DatabaseHelper.instance.insertStates(allStates);

    
// // //   }

// // //   // Fetch Districts
// // //   static Future<void> fetchDistricts() async {
// // //      List<DistrictData> allDistricts = [];

// // //     int page = 1;
// // //     int limit = 5000; // based on your API response
// // //     int totalPages = 1;

// // //     while (true) {
// // //       print("Fetching page $page");

// // //       // API BODY
// // //       final requestBody = {
// // //         "page": page,
// // //         "limit": limit,
// // //       };
// // //          print("Fetching page  dis ${API.districts}}");
// // //       var response = await APIManager().apiRequestWithoutContext(
      
// // //         API.districts,
// // //         (resp) {
// // //           LandDistrictModel result = resp;
  
   
// // //           final pageData = result.data ?? [];
// // //           allDistricts.addAll(pageData);

// // //           // UPDATE TOTAL PAGES (from pagination object)
// // //           totalPages = result.pagination?.totalPages ?? 1;
// // //           print(
// // //               "Fetched allDistricts ${pageData.length} items from page $page");
// // //         },
// // //         (err) {},
// // //         jsonval: requestBody,
// // //       );

// // //       // ADD DATA

// // //       // STOP WHEN LAST PAGE REACHED
// // //       if (page >= totalPages) break;

// // //       page++;
// // //     }

// // //     print("Total allDistricts items fetched = ${allDistricts.length}");

// // //     // SAVE TO DATABASE
// // //     await DatabaseHelper.instance.clearDistrict();
// // //     await DatabaseHelper.instance.insertDistrict(allDistricts);
// // //   }

// // //   // Fetch Talukas
// // //   static List<TalukaData>? _talukaList;
// // //   static Future<void> fetchTaluka() async {
// // //     List<TalukaData> allTaluka = [];

// // //     int page = 1;
// // //     int limit =5000; // based on your API response
// // //     int totalPages = 1;

// // //     while (true) {
// // //       print("Fetching page $page");

// // //       // API BODY
// // //       final requestBody = {
// // //         "page": page,
// // //         "limit": limit,
// // //       };
// // //   print("Fetching page  taluka ${API.talukas}}");
// // //       var response = await APIManager().apiRequestWithoutContext(
       
// // //         API.talukas,
// // //         (resp) {
// // //            print("API.talukas");
// // //           print(API.talukas);
// // //           LandTalukaModel result = resp;
         
// // //           final pageData = result.data ?? [];
// // //           allTaluka.addAll(pageData);

// // //           // UPDATE TOTAL PAGES (from pagination object)
// // //           totalPages = result.pagination?.totalPages ?? 1;
// // //           print(
// // //               "Fetched allTaluka ${pageData.length} items from page $page");
// // //         },
// // //         (err) {
// // //           print("ERROR in taluka");
// // //           print(err.toString());
// // //         },
// // //         jsonval: requestBody,
// // //       );

// // //       // ADD DATA

// // //       // STOP WHEN LAST PAGE REACHED
// // //       if (page >= totalPages) break;

// // //       page++;
// // //     }

// // //     print("Total items fetched = ${allTaluka.length}");

// // //     // SAVE TO DATABASE
// // //     await DatabaseHelper.instance.clearTaluka();
// // //     await DatabaseHelper.instance.insertTaluka(allTaluka);

// // //     _talukaList = allTaluka;

// // //   }

// // //   // Fetch Villages
// // //   static Future<void> fetchVillage() async {
   
// // //    int page = 1;
// // //   int limit = 5000; // smaller limit = safer
// // //   int totalPages = 1;

// // //   await DatabaseHelper.instance.clearVillage();

// // //   while (true) {
// // //     print("Fetching page $page...");

// // //     final requestBody = {
// // //       "page": page,
// // //       "limit": limit,
// // //     };

// // //     await APIManager().apiRequestWithoutContext(
     
// // //       API.villages,
// // //       (resp) async {
// // //         LandVillagesModel result = resp;

// // //         final pageData = result.data ?? [];
// // //         totalPages = result.pagination?.totalPages ?? 1;

// // //         print("Page $page received ${pageData.length}");

// // //         // INSERT DIRECTLY - DO NOT ACCUMULATE IN MEMORY
         
// // //         await DatabaseHelper.instance.insertVillage(pageData);
// // //       },
// // //       (err) {},
// // //       jsonval: requestBody,
// // //     );

// // //     if (page >= totalPages) break;
// // //     page++;
// // //   }

// // //   print("Village download completed!");
// // //   }

// // //   // Sync all data together
// // //   static Future<void> syncAll() async {
// // //     print("Starting full sync...");
// // //    await fetchStates();
// // //     await fetchDistricts();
// // //      await fetchTaluka();
// // //     await fetchVillage();
// // //     print("Full sync completed!");
// // //   }
// // // }
