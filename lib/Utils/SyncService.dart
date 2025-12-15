// sync_service.dart
import 'dart:convert';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Utils/APIManager.dart';
import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
import 'package:hyworth_land_survey/model/LandStateModel.dart';
import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
import 'package:hyworth_land_survey/model/LandVillagesModel.dart';

class SyncService {
  // Fetch States
  static Future<void> fetchStates() async {
     List<StateData> allStates = [];

    int page = 1;
    int limit = 5000; // based on your API response
    int totalPages = 1;

    while (true) {
      print("Fetching page $page");

      // API BODY
      final requestBody = {
        "page": page,
        "limit": limit,
      };

      var response = await APIManager().apiRequestWithoutContext(
        
        API.states,
        (resp) {
          LandStateModel result = resp;
          final pageData = result.data ?? [];
          allStates.addAll(pageData);

          // UPDATE TOTAL PAGES (from pagination object)
          totalPages = result.pagination?.totalPages ?? 1;
          print("Fetched ${pageData.length} items from page $page");
        },
        (err) {},
        jsonval: requestBody,
      );

      // ADD DATA

      // STOP WHEN LAST PAGE REACHED
      if (page >= totalPages) break;

      page++;
    }

    print("Total items fetched = ${allStates.length}");

    // SAVE TO DATABASE
    await DatabaseHelper.instance.clearStates();
    await DatabaseHelper.instance.insertStates(allStates);

    
  }

  // Fetch Districts
  static Future<void> fetchDistricts() async {
     List<DistrictData> allDistricts = [];

    int page = 1;
    int limit = 5000; // based on your API response
    int totalPages = 1;

    while (true) {
      print("Fetching page $page");

      // API BODY
      final requestBody = {
        "page": page,
        "limit": limit,
      };

      var response = await APIManager().apiRequestWithoutContext(
      
        API.districts,
        (resp) {
          LandDistrictModel result = resp;
          final pageData = result.data ?? [];
          allDistricts.addAll(pageData);

          // UPDATE TOTAL PAGES (from pagination object)
          totalPages = result.pagination?.totalPages ?? 1;
          print(
              "Fetched allDistricts ${pageData.length} items from page $page");
        },
        (err) {},
        jsonval: requestBody,
      );

      // ADD DATA

      // STOP WHEN LAST PAGE REACHED
      if (page >= totalPages) break;

      page++;
    }

    print("Total allDistricts items fetched = ${allDistricts.length}");

    // SAVE TO DATABASE
    await DatabaseHelper.instance.clearDistrict();
    await DatabaseHelper.instance.insertDistrict(allDistricts);
  }

  // Fetch Talukas
  static List<TalukaData>? _talukaList;
  static Future<void> fetchTaluka() async {
    List<TalukaData> allTaluka = [];

    int page = 1;
    int limit =5000; // based on your API response
    int totalPages = 1;

    while (true) {
      print("Fetching page $page");

      // API BODY
      final requestBody = {
        "page": page,
        "limit": limit,
      };

      var response = await APIManager().apiRequestWithoutContext(
       
        API.talukas,
        (resp) {
           print("API.talukas");
          print(API.talukas);
          LandTalukaModel result = resp;
          final pageData = result.data ?? [];
          allTaluka.addAll(pageData);

          // UPDATE TOTAL PAGES (from pagination object)
          totalPages = result.pagination?.totalPages ?? 1;
          print(
              "Fetched allTaluka ${pageData.length} items from page $page");
        },
        (err) {
          print("ERROR");
          print(err.toString());
        },
        jsonval: requestBody,
      );

      // ADD DATA

      // STOP WHEN LAST PAGE REACHED
      if (page >= totalPages) break;

      page++;
    }

    print("Total items fetched = ${allTaluka.length}");

    // SAVE TO DATABASE
    await DatabaseHelper.instance.clearTaluka();
    await DatabaseHelper.instance.insertTaluka(allTaluka);

    _talukaList = allTaluka;

  }

  // Fetch Villages
  static Future<void> fetchVillage() async {
   
   int page = 1;
  int limit = 5000; // smaller limit = safer
  int totalPages = 1;

  await DatabaseHelper.instance.clearVillage();

  while (true) {
    print("Fetching page $page...");

    final requestBody = {
      "page": page,
      "limit": limit,
    };

    await APIManager().apiRequestWithoutContext(
     
      API.villages,
      (resp) async {
        LandVillagesModel result = resp;

        final pageData = result.data ?? [];
        totalPages = result.pagination?.totalPages ?? 1;

        print("Page $page received ${pageData.length}");

        // INSERT DIRECTLY - DO NOT ACCUMULATE IN MEMORY
         
        await DatabaseHelper.instance.insertVillage(pageData);
      },
      (err) {},
      jsonval: requestBody,
    );

    if (page >= totalPages) break;
    page++;
  }

  print("Village download completed!");
  }

  // Sync all data together
  static Future<void> syncAll() async {
    print("Starting full sync...");
   await fetchStates();
    await fetchDistricts();
     await fetchTaluka();
     await fetchVillage();
    print("Full sync completed!");
  }
}
