
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Utils/APIManager.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/Utils/internetConnection.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:hyworth_land_survey/model/DeleteLandSurveyModel.dart';
import 'package:hyworth_land_survey/model/LandSurveyByIDModel.dart';
import 'package:hyworth_land_survey/model/LandSuveryListModel.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {}

  List<SurveyModel> _pendingSurveys = [];

  List<SurveyModel> get pendingsurveys => _pendingSurveys;
  List<SurveyModel> _consentSurveys = [];

  List<SurveyModel> get consentSurveys => _consentSurveys;
  List<SurveyModel> _Surveys = [];

  List<SurveyModel> get surveys => _Surveys;

  List<SurveyModel> _completeSurveys = [];

  List<SurveyModel> get completeSurveys => _completeSurveys;

  Future<void> loadSPendingurveys() async {
    //  _surveys = staticSurveys;
    _pendingSurveys = await DatabaseHelper.instance.getPendingSurveys();
    await DatabaseHelper.instance.getAllSurveysWithCounts();
    notifyListeners();
  }

  Future<void> loadConsentSurveys() async {
    //  _surveys = staticSurveys;
    _consentSurveys = await DatabaseHelper.instance.getConsentSurveys();

    notifyListeners();
  }

  Future<void> loadCompletedSurveys() async {
    //  _surveys = staticSurveys;
    _completeSurveys = await DatabaseHelper.instance.getCompletedSurveys();

    notifyListeners();
  }

  Future<void> loadSurveys() async {
    //  _surveys = staticSurveys;
    _Surveys = await DatabaseHelper.instance.getAllSurveys();
    await DatabaseHelper.instance.getAllSurveysWithCounts();
    notifyListeners();
  }

  Future<void> addSurvey(SurveyModel survey) async {
    await DatabaseHelper.instance.insertSurvey(survey);
    await loadSPendingurveys(); // reload after insert
  }

  Future<void> refreshDashboard() async {
    // fetch dashboard counts or reset state

    notifyListeners();
  }

  String _currentLanguage = 'en'; // default

  String get currentLanguage => _currentLanguage;

  void changeLanguage(String lang) {
    _currentLanguage = lang;
    notifyListeners();
  }

  // Update an existing survey
  void updateSurvey(SurveyModel updatedSurvey) {
    final index = surveys.indexWhere((s) => s.id == updatedSurvey.id);
    if (index != -1) {
      surveys[index] = updatedSurvey;
      notifyListeners(); // triggers UI refresh
    }
  }

//   fetchLandList() async {
//   Map<String, dynamic> requestBody = {
//     "page": 1,
//     "limit": 10,
//     "search": "Rampura",
//     "state_id": 8,
//     "include_media": true
//   };

//   APIManager().apiRequestDio(
//     routeGlobalKey.currentContext!,
//     API.landsurveylist,
//     jsonBody: requestBody,
//     onSuccess: (resp) {
//       print("SUCCESS → $resp");
//     },
//     onFailure: (err) {
//       print("ERROR → $err");
//       showToast("Server Not Responding");
//     },
//   );
// }
// Future<void> fetchLandList() async {
//   String? token = await SPManager().getAuthToken();

//   if (token == null) {
//     print("Token not found");
//     return;
//   }

//   final Dio dio = Dio();

//   try {
//     final response = await dio.post(
//       "https://hyworth.onerooftechnologiesllp.com/land-survey/list",
//       data: {
//         "page": 1,
//         "limit": 10,
//         "search": "Rampura",
//         "state_id": 8,
//         "include_media": true,
//       },
//       options: Options(
//         followRedirects: false, // IMPORTANT
//         validateStatus: (status) => status! < 500,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//       ),
//     );

//     print("STATUS: ${response.statusCode}");
//     print("RESPONSE: ${response.data}");
//   } catch (e) {
//     print("DIO EXCEPTION: $e");
//   }
// }
  Map<String, dynamic> createRequestBody() {
    return {
      "page": 1,
      "limit": 10,
      // "search": "Rampura",
      // "state_id": 8,
      "include_media": true
    };
  }

  fetchLandList() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      dynamic jsonbody = createRequestBody();
      print("-----SURVEY LAND RESPONSE____");
      print(jsonbody);

      APIManager().apiRequest(
          routeGlobalKey.currentContext!, API.landsurveylist, (response) async {
        print("-----SURVEY LAND RESPONSE____");
        SurveyResponse resp = response;

        print("-----SURVEY LAND____");
        if (resp.data == null || resp.data!.isEmpty) return;
        print("-----SURVEY LAND1____");
        final db = DatabaseHelper.instance;

        /// clear old data
        // await db.clearTableSurvey();

        for (var detail in resp.data!) {
          print("-----SURVEY LAND3____");
          // Collect survey_land_images URLs
          // List<String> landImages = (detail.surveyLandImages ?? [])
          //     .map((e) => e.mediaUrl ?? "")
          //     .toList();

          // // Collect survey_other_details_images URLs
          // List<String> otherImages = (detail.surveyOtherDetailsImages ?? [])
          //     .map((e) => e.mediaUrl ?? "")
          //     .toList();
          // List<String> consentImages =
          //     (detail.consents ?? []).map((e) => e.mediaUrl ?? "").toList();
          // Land pictures
// LAND IMAGES
          List<SurveyMediaModel> landImages = (detail.surveyLandImages ?? [])
              .map((media) => SurveyMediaModel(
                    surveyLocalId: int.parse(detail.surveyId),
                    mediaType: 'land',
                    localPath: media.mediaUrl,
                    isSynced: 1,
                  ))
              .toList();

// SURVEY FORMS
          List<SurveyMediaModel> otherImages =
              (detail.surveyOtherDetailsImages ?? [])
                  .map((media) => SurveyMediaModel(
                        surveyLocalId: int.parse(detail.surveyId),
                        mediaType: 'survey',
                        localPath: media.mediaUrl,
                        isSynced: 1,
                      ))
                  .toList();

// CONSENT FORMS
          List<SurveyMediaModel> consentImages = (detail.consents ?? [])
              .map((media) => SurveyMediaModel(
                    surveyLocalId: int.parse(detail.surveyId),
                    mediaType: 'consent',
                    localPath: media.mediaUrl,
                    isSynced: 1,
                  ))
              .toList();

          print("-----SURVEY LAND4____");

          final survey = SurveyModel(
              id: detail.id ?? 0,
              surveyId: detail.surveyId ?? "",
              userId: detail.createdBy?.toString() ?? "",
              landState: detail.landStateName ?? "",
              solarParkACCapacity: "",
              solarParkDCCapacity: "",
              gridConnectivity: "",
              // Land Info
              landLocation: detail.landLocation ?? "",
              landStateID: detail.landStateId?.toString() ?? "",
              landDistrictID: detail.landDistrictId.toString() ?? "",
              landDHQ: detail.landStateName ?? "",
              landTalukaID: detail.landTalukaId.toString() ?? "",
              landVillageID: detail.landVillageId.toString() ?? "",
              landDistrict: detail.landDistrictName ?? "",
              landTaluka: detail.landTalukaName ?? "",
              landVillage: detail.landVillageName ?? "",
              landLatitude:
                  double.tryParse(detail.landLatitude ?? "0.0") ?? 0.0,
              landLongitude:
                  double.tryParse(detail.landLongitude ?? "0.0") ?? 0.0,
              landAreaInAcres: detail.landAreaInAcres ?? "",
              landType: detail.landType?.toString() ?? "",
              landRateCommercialEscalation:
                  detail.landRateCommercialEscalation ?? "",

              // Land Pictures
              // landPictures: jsonEncode(landImages),
              landPictures: landImages,
              surveyForms: otherImages,
              consentForms: consentImages,
              // Substation Info
              subStationName: detail.subStationName ?? "",
              subStationDistrict: detail.subStationDistrictName ?? "",
              subStationTaluka: detail.subStationTalukaName ?? "",
              subStationVillage: detail.subStationVillageName ?? "",
              subStationLatitude:
                  double.tryParse(detail.subStationLatitude ?? "0.0") ?? 0.0,
              subStationLongitude:
                  double.tryParse(detail.subStationLongitude ?? "0.0") ?? 0.0,
              inchargeName: detail.subStationInchargeName ?? "",
              subStationInchargeContact: detail.subStationInchargeContact ?? "",
              operatorName: detail.operatorName ?? "",
              operatorContact: detail.operatorContact ?? "",
              subStationVoltageLevel: detail.subStationVoltageLevel ?? "",
              subStationCapacity: detail.subStationCapacity ?? "",
              distanceSubStationToLand: detail.distanceSubStationToLand ?? "",
              plotDistanceFromMainRoad: detail.plotDistanceFromMainRoad ?? "",

              // Evacuation & Soil Details
              evacuationLevel: detail.evacuationLevel ?? "",
              windZone: detail.windZone ?? "",
              groundWaterRainFall: detail.groundWaterRainfall ?? "",
              soilType: detail.soilType ?? "",
              nearestHighway: detail.nearestHighway ?? "",

              // Flags
              isSurveyapproved: detail.isSurveyApproved ?? 0,
              consentAvailable: detail.consentAvailable ?? 0,
              isSync: 1, // because coming from API

              // Language
              selectedLanguage: detail.selectedLanguage ?? "en",

              // Dates
              surveyDate: detail.createdAt != null
                  ? DateTime.parse(detail.createdAt!).millisecondsSinceEpoch
                  : DateTime.now().millisecondsSinceEpoch,
              updatedsurveyDate: detail.updatedAt != null
                  ? DateTime.parse(detail.updatedAt!).millisecondsSinceEpoch
                  : DateTime.now().millisecondsSinceEpoch,

              // Status
              surveyStatus: detail.surveyStatus.toString() ?? "",
              substationDistrictID:
                  detail.subStationDistrictId.toString() ?? '',
              substationVillageID: detail.subStationVillageId.toString() ?? '',
              substationTalukaID: detail.subStationTalukaId.toString() ?? ''

              // is:
              //     detail.approvalStatus?.approvalStatusName ?? "Pending",
              );

          final exists = await db.surveyExists(survey.surveyId!);

          if (exists) {
            await db.updateSurvey(survey, int.parse(survey.surveyId!));
            debugPrint("🔁 Survey updated: ${survey.surveyId}");
          } else {
            await db.insertSurvey(survey);
            debugPrint("➕ Survey inserted: ${survey.surveyId}");
          }

          await db.getAllSurveys();
        }

        print("Land Surveys saved to DB successfully!");
        notifyListeners();
      }, (error) {
        print('ERR msg is $error');

        showToast("Server Not Responding");
      }, jsonval: jsonbody);
    } else {
      /// Navigator.of(_keyLoader.currentContext).pop();
      showToast("Please check internet connection");
    }
  }

  Map<String, dynamic> createRequestfetchLandBYID(String surveyID) {
    return {"land_survey_id":surveyID };
  }
 deleteLandList(String surveyID) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      dynamic jsonbody = createRequestfetchLandBYID(surveyID);
      print("-----SURVEY DELETE RESPONSE____");
      print(jsonbody);

      APIManager().apiRequest(
          routeGlobalKey.currentContext!, API.landsurveydelete, (response) async {
        print("-----SURVEY DELETE RESPONSE____");
        DeleteLandSurveyModel resp = response;

        print("-----SURVEY LAND____");
        if (resp == null ) return;
        print("-----SURVEY LAND1____");
        final db = DatabaseHelper.instance;
showToast(resp.message);
    await db.deleteSurvey(int.parse(resp.deletedSurveyId.toString()));
          await db.getAllSurveys();

        print("Land Surveys DELETED to DB successfully!");
        notifyListeners();
      }, (error) {
        print('ERR msg is $error');

        showToast("Server Not Responding");
      }, jsonval: jsonbody);
    } else {
      /// Navigator.of(_keyLoader.currentContext).pop();
      showToast("Please check internet connection");
    }
  }

  fetchLandBYID(String surveyID) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      dynamic jsonbody = createRequestfetchLandBYID(surveyID);
      print(jsonbody);

      APIManager().apiRequest(routeGlobalKey.currentContext!, API.getById,
          (response) async {
        LandSurveyByIdModel resp = response;
        print("-----TOKEN FROM API____");
      }, (error) {
        print('ERR msg is $error');

        showToast("Server Not Responding");
      }, jsonval: jsonbody);
    } else {
      /// Navigator.of(_keyLoader.currentContext).pop();
      showToast("Please check internet connection");
    }
  }

//   List<StateData>? _stateList;

//   List<StateData>? get stateList => _stateList;

//   List<DistrictData>? _districtList;

//   List<DistrictData>? get districtList => _districtList;

//   Future<void> fetchAndStoreAllDistrict() async {
//     List<DistrictData> allDistricts = [];

//     int page = 1;
//     int limit = 1000; // based on your API response
//     int totalPages = 1;

//     while (true) {
//       print("Fetching page $page");

//       // API BODY
//       final requestBody = {
//         "page": page,
//         "limit": limit,
//       };

//       var response = await APIManager().apiRequest(
//         routeGlobalKey.currentContext!,
//         API.districts,
//         (resp) {
//           LandDistrictModel result = resp;
//           final pageData = result.data ?? [];
//           allDistricts.addAll(pageData);

//           // UPDATE TOTAL PAGES (from pagination object)
//           totalPages = result.pagination?.totalPages ?? 1;
//           print(
//               "Fetched allDistricts ${pageData.length} items from page $page");
//         },
//         (err) {},
//         jsonval: requestBody,
//       );

//       // ADD DATA

//       // STOP WHEN LAST PAGE REACHED
//       if (page >= totalPages) break;

//       page++;
//     }

//     print("Total allDistricts items fetched = ${allDistricts.length}");

//     // SAVE TO DATABASE
//     await DatabaseHelper.instance.clearDistrict();
//     await DatabaseHelper.instance.insertDistrict(allDistricts);

//     _districtList = allDistricts;
//     notifyListeners();
//   }

//   List<TalukaData>? _talukaList;

//   List<TalukaData>? get talukaList => _talukaList;

//   Future<void> fetchAndStoreAllTaluka() async {
//     List<TalukaData> allTaluka = [];

//     int page = 1;
//     int limit = 1000; // based on your API response
//     int totalPages = 1;

//     while (true) {
//       print("Fetching page $page");

//       // API BODY
//       final requestBody = {
//         "page": page,
//         "limit": limit,
//       };

//       var response = await APIManager().apiRequest(
//         routeGlobalKey.currentContext!,
//         API.talukas,
//         (resp) {
//           LandTalukaModel result = resp;
//           final pageData = result.data ?? [];
//           allTaluka.addAll(pageData);

//           // UPDATE TOTAL PAGES (from pagination object)
//           totalPages = result.pagination?.totalPages ?? 1;
//           print(
//               "Fetched allTaluka ${pageData.length} items from page $page");
//         },
//         (err) {},
//         jsonval: requestBody,
//       );

//       // ADD DATA

//       // STOP WHEN LAST PAGE REACHED
//       if (page >= totalPages) break;

//       page++;
//     }

//     print("Total items fetched = ${allTaluka.length}");

//     // SAVE TO DATABASE
//     await DatabaseHelper.instance.clearTaluka();
//     await DatabaseHelper.instance.insertTaluka(allTaluka);

//     _talukaList = allTaluka;
//     notifyListeners();
//   }

//    List<VillageData>? _villageList;

//   List<VillageData>? get villageList => _villageList;
// Future<void> fetchAndStoreAllVillage() async {
//   int page = 1;
//   int limit = 5000; // smaller limit = safer
//   int totalPages = 1;

//   await DatabaseHelper.instance.clearVillage();

//   while (true) {
//     print("Fetching page $page...");

//     final requestBody = {
//       "page": page,
//       "limit": limit,
//     };

//     await APIManager().apiRequest(
//       routeGlobalKey.currentContext!,
//       API.villages,
//       (resp) async {
//         LandVillagesModel result = resp;

//         final pageData = result.data ?? [];
//         totalPages = result.pagination?.totalPages ?? 1;

//         print("Page $page received ${pageData.length}");

//         // INSERT DIRECTLY - DO NOT ACCUMULATE IN MEMORY

//         await DatabaseHelper.instance.insertVillage(pageData);
//       },
//       (err) {},
//       jsonval: requestBody,
//     );

//     if (page >= totalPages) break;
//     page++;
//   }

//   print("Village download completed!");
// }

//   // Future<void> fetchAndStoreAllVillage() async {
//   //   List<VillageData> allvillages = [];

//   //   int page = 1;
//   //   int limit = 100000; // based on your API response
//   //   int totalPages = 1;

//   //   while (true) {
//   //     print("Fetching page $page");

//   //     // API BODY
//   //     final requestBody = {
//   //       "page": page,
//   //       "limit": limit,
//   //     };

//   //     var response = await APIManager().apiRequest(
//   //       routeGlobalKey.currentContext!,
//   //       API.villages,
//   //       (resp) {
//   //         LandVillagesModel result = resp;
//   //         final pageData = result.data ?? [];
//   //         allvillages.addAll(pageData);

//   //         // UPDATE TOTAL PAGES (from pagination object)
//   //         totalPages = result.pagination?.totalPages ?? 1;
//   //         print(
//   //             "Fetched allvillages ${pageData.length} items from page $page");
//   //       },
//   //       (err) {},
//   //       jsonval: requestBody,
//   //     );

//   //     // ADD DATA

//   //     // STOP WHEN LAST PAGE REACHED
//   //     if (page >= totalPages) break;

//   //     page++;
//   //   }

//   //   print("Total items fetched = ${allvillages.length}");

//   //   // SAVE TO DATABASE
//   //   await DatabaseHelper.instance.clearVillage();
//   //   await DatabaseHelper.instance.insertVillage(allvillages);

//   //   _villageList = allvillages;
//   //   notifyListeners();
//   // }
}
