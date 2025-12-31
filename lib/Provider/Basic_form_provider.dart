import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Utils/APIManager.dart';
import 'package:hyworth_land_survey/Utils/SPManager.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/main.dart';

import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
import 'package:hyworth_land_survey/model/LandStateModel.dart';
import 'package:hyworth_land_survey/model/LandSurveyCreatedModel.dart';
import 'package:hyworth_land_survey/model/LandSurveyUpdatedModel.dart';
import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
import 'package:hyworth_land_survey/model/LandVillagesModel.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:http_parser/http_parser.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';

import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class BasicFormProvider extends ChangeNotifier {
  TextEditingController solarCapacityController = TextEditingController();
  TextEditingController gridConnectivityController = TextEditingController();
  // TextEditingController landStateController = TextEditingController();
  // TextEditingController landDistrictController = TextEditingController();
  String? surverID;
  Map<String, String>? selectedLandState = {
    'id': '',
    'name': 'Select State',
    "statecode":''
  };
  Map<String, String>? selectedLandDistrict = {
    'id': '',
    'district_name': 'Select District',
      "districtcode":''
  };
  Map<String, String>? selectedLandTaluka = {
    'id': '',
    'taluka_name': 'Select Taluka',
     "districtcode":''
  };
  Map<String, String>? selectedLandVillage = {
    'id': '',
    'village_name': 'Select Village',
  };
  Map<String, String>? selectedsubstationState = {
    'id': '',
    'name': 'Select State',
    "statecode":''
  };
  Map<String, String>? selectedsubstationDistrict = {
    'id': '',
    'district_name': 'Select Substation District',
     "statecode":''
  };
  Map<String, String>? selectedsubstationTaluka = {
    'id': '',
    'taluka_name': 'Select Substation Taluka',
     "statecode":''
  };
  Map<String, String>? selectedsubstationVillage = {
    'id': '',
    'village_name': 'Select Substation Village',
  };
  // TextEditingController landTalukaController = TextEditingController();
  // TextEditingController landVillageController = TextEditingController();
  TextEditingController landLatitudeController = TextEditingController();
  TextEditingController landLonitudeController = TextEditingController();
  TextEditingController landAreaController = TextEditingController();

  TextEditingController landRateontroller = TextEditingController();
  bool get isBasicFormValid {
    return true;
    // solarCapacityController.text.isNotEmpty &&
    //     gridConnectivityController.text.isNotEmpty &&
    // landStateController.text.isNotEmpty &&
    // landDistrictController.text.isNotEmpty &&
    // landTalukaController.text.isNotEmpty &&
    // landVillageController.text.isNotEmpty &&
    // landLatitudeController.text.isNotEmpty &&
    // landLonitudeController.text.isNotEmpty &&
    // landAreaController.text.isNotEmpty &&
    // landRateontroller.text.isNotEmpty;
  }

  //sub-station

  TextEditingController subStationNameController = TextEditingController();
  // TextEditingController subStationDistrictController = TextEditingController();
  // TextEditingController subStationTalukaController = TextEditingController();
  // TextEditingController subStationVillageController = TextEditingController();
  TextEditingController subStationLatitudeController = TextEditingController();
  TextEditingController subStationLongitudeController = TextEditingController();
  TextEditingController subStationInchargeContactController =
      TextEditingController();
  TextEditingController subStationInchargeNameController =
      TextEditingController();
  TextEditingController subStationOperatorNameController =
      TextEditingController();
  TextEditingController subStationOperatorContactController =
      TextEditingController();
  TextEditingController subStationVoltageLevelController =
      TextEditingController();
  TextEditingController subStationCapacityController = TextEditingController();
  TextEditingController subStationDistancebtwLandController =
      TextEditingController();
  TextEditingController subStationDistancebtwPlotController =
      TextEditingController();
  bool get isSubstaionFormValid {
    return true;
    // return subStationNameController.text.isNotEmpty &&
    //     subStationDistrictController.text.isNotEmpty &&
    //     subStationTalukaController.text.isNotEmpty &&
    //     subStationVillageController.text.isNotEmpty &&
    //     subStationLatitudeController.text.isNotEmpty &&
    //     subStationLongitudeController.text.isNotEmpty &&
    //     subStationInchargeContactController.text.isNotEmpty &&
    //     subStationInchargeNameController.text.isNotEmpty &&
    //     subStationOperatorNameController.text.isNotEmpty &&
    //     subStationOperatorContactController.text.isNotEmpty &&
    //     subStationVoltageLevelController.text.isNotEmpty &&
    //     subStationCapacityController.text.isNotEmpty &&
    //     subStationDistancebtwLandController.text.isNotEmpty &&
    //     subStationDistancebtwPlotController.text.isNotEmpty;
  }

  TextEditingController otherEvacuationController = TextEditingController();
  TextEditingController typeofSoilController = TextEditingController();
  TextEditingController windZoneController = TextEditingController();
  TextEditingController groundWaterController = TextEditingController();
  TextEditingController nearestHighwayController = TextEditingController();

  bool get isOtherFormValid {
    return true;
    // return otherEvacuationController.text.isNotEmpty &&
    //     typeofSoilController.text.isNotEmpty &&
    //     windZoneController.text.isNotEmpty &&
    //     groundWaterController.text.isNotEmpty &&
    //     nearestHighwayController.text.isNotEmpty && mediaFile!=null ;
  }

  String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'State cannot be empty';
    }
    return null;
  }

  bool get ismediaFilesCalimComplete {
    return OtherLandmediaFiles.every((file) => file != null);
  }

  // final List<File?> OtherLandmediaFiles =
  //     List.generate(7, (index) => null); // 8 fields

  final List<SurveyMediaModel?> OtherLandmediaFiles =
      List.generate(7, (index) => null);


    final List<SurveyMediaModel?> consentFiles =
    [];

  bool get isMediaValid {
    return OtherLandmediaFiles.every((file) => file != null);
  }

  // void setMediaFile(int index, File file) {
  //   OtherLandmediaFiles[index] = file;
  //   notifyListeners();
  // }
  // void setMediaFile(int index, File file) {
  //   if (index >= OtherLandmediaFiles.length) {
  //     // extend the list if needed (optional, here not needed since always 7)
  //     OtherLandmediaFiles.length = index + 1;
  //   }
  //   OtherLandmediaFiles[index] = file.path!;
  //   notifyListeners();
  // }
  void setMediaFile(int index, File file, String surveyLocalId) {
    if (index >= OtherLandmediaFiles.length) {
      OtherLandmediaFiles.length = index + 1;
    }

    OtherLandmediaFiles[index] = SurveyMediaModel(
      surveyLocalId: surveyLocalId,
      mediaType: MediaTypeValue.landPicture,
      localPath: file.path,
      serverMediaId: "", // NEW media
      isSynced: 0,
      isdeleted: 0,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    notifyListeners();
  }
  void setConsentMediaFile(int index, File file, String surveyLocalId) {
    if (index >= consentFiles.length) {
      consentFiles.length = index + 1;
    }

    consentFiles[index] = SurveyMediaModel(
      surveyLocalId: surveyLocalId,
      mediaType: MediaTypeValue.consentForm,
      localPath: file.path,
      serverMediaId: "", // NEW media
      isSynced: 0,
      isdeleted: 0,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    notifyListeners();
  }
  void removeMediaFile(int index) {
    OtherLandmediaFiles[index] = null;
    notifyListeners();
  }

  File? surveyFormsmediaFile; // single file instead of list
  int? surveyFormsmediaId;
  // void setImage(File file) {
  //   surveyFormsmediaFile = file;
  //   notifyListeners();
  // }
  void setImage(File file, int? id) {
    surveyFormsmediaFile = file;
    surveyFormsmediaId = id;
    notifyListeners();
  }

  void removeImageLandImages(int index, BasicFormProvider basicFormprovider,
      String surveyLocalId, String serverMediaId, File localPath) {
    basicFormprovider.OtherLandmediaFiles[index] = null;
    deleteMediaFromLocal(surveyLocalId, localPath);
    notifyListeners();
  }

  Future<void> removeImage(
    String surveyLocalId,
    File localFile,
  ) async {
    print("🧨 REMOVED CLICKED");
    print("Before delete");

    await DatabaseHelper.instance.getSurveyMediaBySurveyLocalId(surveyLocalId);

    // ✅ WAIT FOR DELETE
    await deleteMediaFromLocal(surveyLocalId, localFile);

    print("After delete");

    await DatabaseHelper.instance.getSurveyMediaBySurveyLocalId(surveyLocalId);

    surveyFormsmediaFile = null;
    notifyListeners();
  }

  Future<void> deleteMediaFromLocal(
    String surveyLocalId,
    File localFile,
  ) async {
    final db = await DatabaseHelper.instance;
     print("Before delete FROM LOCAL");
    await DatabaseHelper.instance.getSurveyMediaBySurveyLocalId(surveyLocalId);

    await db.deleteSurveyMedia(
      surveyLocalId: surveyLocalId,
      localPath: localFile.path,
    );
    print("After delete from LOCAL");

    await DatabaseHelper.instance.getSurveyMediaBySurveyLocalId(surveyLocalId);

  }

  Future<List<StateData>> fetchStates() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query("states");

    return result
        .map((e) => StateData(
              id: e['id'] as int?,
              stateCode: e['state_code'] as String?,
              name: e['name'] as String?,
            ))
        .toList();
  }
Future<List<DistrictData>> fetchDistrict({String? stateCode}) async {
  print("fetchDistrict ${stateCode} ");
  final db = await DatabaseHelper.instance.database;

  List<Map<String, Object?>> result;

  if (stateCode == null || stateCode.trim().isEmpty) {
    // 🔹 Return all districts
     print("DISTRICT EMPTY");
    result = await db.query("district");
  } else {
    print("DISTRICT FILTER");
    // 🔹 Filter by stateCode
    result = await db.query(
      "district",
      where: "state_code = ?",
      whereArgs: [stateCode],
    );


     print("DISTRICT FILTER ${result.length}");
  }

  return result
      .map((e) => DistrictData(
            id: e['id'] as int?,
            stateCode: e['state_code'] as String?,
            stateName: e['state_name'] as String?,
            districtName: e['district_name'] as String?,
            districtCode: e['district_code'] as String?,
          ))
      .toList();
}

  // Future<List<DistrictData>> fetchDistrict() async {
  //   final db = await DatabaseHelper.instance.database;
  //   final result = await db.query("district");

  //   return result
  //       .map((e) => DistrictData(
  //             id: e['id'] as int?,
  //             stateCode: e['state_code'] as String?,
  //             stateName: e['state_name'] as String?,
  //             districtName: e['district_name'] as String?,
  //             districtCode: e['district_code'] as String?,
  //           ))
  //       .toList();
  // }
Future<List<TalukaData>> fetchTaluka({String? districtCode}) async {
  final db = await DatabaseHelper.instance.database;

  List<Map<String, Object?>> result;

  if (districtCode == null || districtCode.trim().isEmpty) {
    // 🔹 Return all talukas
    result = await db.query("taluka");
  } else {
    // 🔹 Return talukas for selected district
    result = await db.query(
      "taluka",
      where: "district_code = ?",
      whereArgs: [districtCode],
    );
  }

  return result
      .map((e) => TalukaData(
            id: e['id'] as int,
            stateCode: e['state_code'] as String,
            stateName: e['state_name'] as String,
            districtName: e['district_name'] as String,
            districtCode: e['district_code'] as String,
            talukaCode: e['taluka_code'] as String,
            talukaName: e['taluka_name'] as String,
          ))
      .toList();
}

  // Future<List<TalukaData>> fetchTaluka() async {
  //   final db = await DatabaseHelper.instance.database;
  //   final result = await db.query("taluka");

  //   return result
  //       .map((e) => TalukaData(
  //           id: e['id'] as int,
  //           stateCode: e['state_code'] as String,
  //           stateName: e['state_name'] as String,
  //           districtName: e['district_name'] as String,
  //           districtCode: e['district_code'] as String,
  //           talukaCode: e['taluka_code'] as String,
  //           talukaName: e['taluka_name'] as String))
  //       .toList();
  // }
// Future<List<Map<String, dynamic>>> fetchVillageByTaluka(String talukaCode) async {
//   final db =  await DatabaseHelper.instance.database;
//   return await db.query(
//     "village",
//     where: "taluka_code = ?",
//     whereArgs: [talukaCode],
//     limit: 500,   // return only relevant villages
//   );
// }
// Future<List<Map<String, dynamic>>> searchVillage(String filter) async {
//   final db = await DatabaseHelper.instance.database;

//   // If empty filter, return limited rows
//   if (filter.isEmpty) {
//     final result = await db.rawQuery(
//       "SELECT id, village_name FROM village LIMIT 100"
//     );
//     return result;
//   }

//   // Otherwise search
//   final result = await db.rawQuery(
//     """
//     SELECT id, village_name FROM village
//     WHERE village_name LIKE ?
//        OR id LIKE ?
//     LIMIT 100
//     """,
//     ['%$filter%', '%$filter%']
//   );

//   return result;
// }
  // Future<List<Map<String, dynamic>>> searchVillage(String filter) async {
  //   final db = await DatabaseHelper.instance.database;

  //   if (filter.isEmpty) {
  //     // Return a small set to avoid heavy UI load
  //     return await db.rawQuery(
  //         "SELECT id, village_name FROM village ORDER BY village_name LIMIT 100");
  //   }

  //   // First search by prefix (fast using index)
  //   var result = await db.rawQuery("""
  //   SELECT id, village_name FROM village
  //   WHERE village_name LIKE ?
  //   ORDER BY village_name
  //   LIMIT 100
  //   """, ['$filter%']);

  //   // If not enough results, fallback to contains search (slow)
  //   if (result.length < 20) {
  //     result = await db.rawQuery("""
  //     SELECT id, village_name FROM village
  //     WHERE village_name LIKE ?
  //     ORDER BY village_name
  //     LIMIT 100
  //     """, ['%$filter%']);
  //   }

  //   return result;
  // }
Future<List<Map<String, dynamic>>> searchVillage(
  String filter, {
  String? districtCode,
}) async {
  final db = await DatabaseHelper.instance.database;

  // 🔹 Base WHERE clause
  String districtWhere = '';
  List<dynamic> args = [];

  if (districtCode != null && districtCode.trim().isNotEmpty) {
    districtWhere = 'AND district_code = ?';
    args.add(districtCode);
  }

  // 🔹 No search text → return limited list
  if (filter.trim().isEmpty) {
    return await db.rawQuery(
      '''
      SELECT id, village_name
      FROM village
      WHERE 1=1
      $districtWhere
      ORDER BY village_name
      LIMIT 100
      ''',
      args,
    );
  }

  // 🔹 1️⃣ Prefix search (FAST – uses index)
  var result = await db.rawQuery(
    '''
    SELECT id, village_name
    FROM village
    WHERE village_name LIKE ?
    $districtWhere
    ORDER BY village_name
    LIMIT 100
    ''',
    ['$filter%', ...args],
  );

  // 🔹 2️⃣ Fallback to contains search if few results
  if (result.length < 20) {
    result = await db.rawQuery(
      '''
      SELECT id, village_name
      FROM village
      WHERE village_name LIKE ?
      $districtWhere
      ORDER BY village_name
      LIMIT 100
      ''',
      ['%$filter%', ...args],
    );
  }

  return result;
}


//   Future<List<VillageData>> fetchVillage() async {
//     final db = await DatabaseHelper.instance.database;
//     final result = await db.query("village");

//     return result
//         .map((e) => VillageData(
// id: e['id'] as int,
//             stateCode: e['state_code'] as String,
//             stateName: e['state_name'] as String,
//             districtName: e['district_name'] as String,
//             districtCode: e['district_code'] as String,
//             talukaCode: e['taluka_code'] as String,
//             talukaName: e['taluka_name'] as String,
//             villageCode: e['village_code'] as String,
//             villageName: e['village_name'] as String
//             ))
//         .toList();
//   }
  String? _rentLeaseOption; // Rent or Lease

  // Getter
  String? get rentLeaseOption => _rentLeaseOption;

  // Setter
  void setRentLeaseOption(String option) {
    print(option);
    _rentLeaseOption = option;
    notifyListeners(); // notify UI
  }

  Future<void> submitLandSurvey(SurveyModel surveyModel) async {
    var uri = Uri.parse(APIManager.createLAndSurvey);

    // Creating a multipart request
    var request = http.MultipartRequest('POST', uri);
    print("APIManager.createLAndSurvey");
    print(APIManager.createLAndSurvey);
    // Add the post text as form data
    request.fields['survey_id'] = surveyModel.surveyId.toString();
    request.fields['land_location'] = surveyModel.landLocation ?? "";

    request.fields['land_state_id'] = surveyModel.landStateID.toString();
    request.fields['land_state_name'] = surveyModel.landState ?? "";

    request.fields['land_district_id'] = surveyModel.landDistrictID ?? "";
    request.fields['land_district_name'] = surveyModel.landDistrict ?? "";

    request.fields['land_taluka_id'] = surveyModel.landTalukaID ?? "";
    request.fields['land_taluka_name'] = surveyModel.landTaluka ?? "";

    request.fields['land_village_id'] = surveyModel.landVillageID ?? "";
    request.fields['land_village_name'] = surveyModel.landVillage ?? "";

    request.fields['land_latitude'] = surveyModel.landLatitude.toString() ?? "";
    request.fields['land_longitude'] =
        surveyModel.landLongitude.toString() ?? "";

    request.fields['land_area_in_acres'] = surveyModel.landAreaInAcres ?? "";
    request.fields['land_type'] =
        surveyModel.landType  ??"";
        
        //"1" ? "Rent" : "Lease";
    request.fields['land_rate_commercial_escalation'] =
        surveyModel.landRateCommercialEscalation ?? "";

    request.fields['sub_station_name'] = surveyModel.subStationName ?? "";

    request.fields['sub_station_district_id'] =
        surveyModel.substationDistrictID ?? "";
    request.fields['sub_station_district_name'] =
        surveyModel.subStationDistrict ?? "";

    request.fields['sub_station_taluka_id'] =
        surveyModel.substationTalukaID ?? "";
    request.fields['sub_station_taluka_name'] =
        surveyModel.subStationTaluka ?? "";

    request.fields['sub_station_village_id'] =
        surveyModel.substationVillageID ?? "";
    request.fields['sub_station_village_name'] =
        surveyModel.subStationVillage ?? "";

    request.fields['sub_station_latitude'] =
        surveyModel.subStationLatitude.toString() ?? "";
    request.fields['sub_station_longitude'] =
        surveyModel.subStationLongitude.toString() ?? "";

    request.fields['sub_station_incharge_contact'] =
        surveyModel.subStationInchargeContact ?? "";
    request.fields['sub_station_incharge_name'] =
        surveyModel.inchargeName ?? "";

    request.fields['operator_name'] = surveyModel.operatorName ?? "";
    request.fields['operator_contact'] = surveyModel.operatorContact ?? "";

    request.fields['sub_station_voltage_level'] =
        surveyModel.subStationVoltageLevel ?? "";
    request.fields['sub_station_capacity'] =
        surveyModel.subStationCapacity ?? "";

    request.fields['distance_sub_station_to_land'] =
        surveyModel.distanceSubStationToLand ?? "";
    request.fields['plot_distance_from_main_road'] =
        surveyModel.plotDistanceFromMainRoad ?? "";

    request.fields['evacuation_level'] = surveyModel.evacuationLevel ?? "";
    request.fields['soil_type'] = surveyModel.soilType ?? "";
    request.fields['wind_zone'] = surveyModel.windZone ?? "";
    request.fields['ground_water_rainfall'] =
        surveyModel.groundWaterRainFall ?? "";

    request.fields['nearest_highway'] = surveyModel.nearestHighway ?? "";

    request.fields['consent_available'] =
        surveyModel.consentAvailable.toString() ?? "";
    request.fields['is_sync'] = surveyModel.isSync.toString() ?? "";
    request.fields['is_survey_approved'] =
        surveyModel.isSurveyapproved.toString() ?? "";

    request.fields['selected_language'] = surveyModel.selectedLanguage ?? "";
    request.fields['survey_status'] = (surveyModel.surveyStatus == "pending" ||
            surveyModel.surveyStatus == "Pending")
        ? "1"
        : surveyModel.surveyStatus == "Awaiting Approval"
            ? "2"
            : surveyModel.surveyStatus == "Approved"
                ? "3"
                : surveyModel.surveyStatus == "Rejected"
                    ? "4"
                    : "0";
    logLong(
      const JsonEncoder.withIndent('  ').convert(request.fields),
    );
    // debugPrint("CREATE ${request.fields}");
    String? token = await SPManager().getAuthToken();
    // Add the files to the request
    print("HYWORTH");
    print(surveyModel.surveyForms.length);
    for (var file in surveyModel.surveyForms!) {
      print("HYWORTH");
      print(file.localPath);
      print(file.serverMediaId);
      var mimeType = lookupMimeType(
          file.localPath); // Get mime type based on file extension
      var multipartFile = await http.MultipartFile.fromPath(
          'survey_images', file.localPath,
          contentType: mimeType != null
              ? MediaType.parse(mimeType)
              : MediaType('application', 'octet-stream'));
      request.files.add(multipartFile);
    }
    for (var file in surveyModel.landPictures!) {
      var mimeType = lookupMimeType(
          file.localPath!); // Get mime type based on file extension
      var multipartFile = await http.MultipartFile.fromPath(
          'other_images', file.localPath,
          contentType: mimeType != null
              ? MediaType.parse(mimeType)
              : MediaType('application', 'octet-stream'));
      request.files.add(multipartFile);
    }
    // for (var file in surveyModel.consentForms!) {
    //   var mimeType = lookupMimeType(
    //       file.localPath!); // Get mime type based on file extension
    //   var multipartFile = await http.MultipartFile.fromPath(
    //       'consents', file.localPath,
    //       contentType: mimeType != null
    //           ? MediaType.parse(mimeType)
    //           : MediaType('application', 'octet-stream'));
    //   request.files.add(multipartFile);
    // }
    // print(request.files);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${token}';
    request.headers['Cookie'] =
        "connect.sid=s%3A2tdDJk7GtxkDgwdGLz5i-8Q3zrIf8Jab.Km0GWJSzt2vY96oF19B8CTleU%2F7HZstVOdCsfSgcMLM";

    // Sending the request
    var response = await request.send();
    print('Post uploaded successfully');

    // Handle the response
    if (response.statusCode == 200) {
      // Success

      var responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      final jsonResponse = json.decode(responseData);
      if(jsonResponse['success']==true){
         final apiResponse = LandSurveyCreatedModel.fromJson(jsonResponse);
// Now access the message
      final message = jsonResponse['message']; // or whatever key your API uses
      print("RUCHITA CREATED LIST IN SERVER");
      if (apiResponse.success == true) {
        print(apiResponse.data!.surveyId!);
        var db = DatabaseHelper.instance;
       
        // final result = await Navigator.of(routeGlobalKey.currentContext!).push(
        //   createSlideFromBottomRoute(
        //     Maintabscreen(),
        //   ),
        // );
print("----HARD DELETED----");
     
        await DatabaseHelper.instance.hardDeleteSurveyMediaByServerId(
          surveyLocalId: apiResponse.data.surveyId.toString(),
        );
print("----AFETR DELETED----");
        final remaining = await DatabaseHelper.instance
            .getSurveyMediaCount(apiResponse.data.surveyId.toString());

        if (remaining == 0) {
          print("✅ All survey media deleted successfully");
        } else {
          print("⚠ Still $remaining images left in DB");
        }
print("----INSERTION AFTER DELETED----");
        List<SurveyMediaModel> landImages = [];
        for (var media in apiResponse.data!.surveyLandImages ?? []) {
          // Download the image and get the local file path
          print(media);
          final localPath = await urlToLocalPath(media.mediaUrl);

          // Create SurveyMediaModel with localPath
          landImages.add(SurveyMediaModel(
            surveyLocalId: apiResponse.data!.surveyId,
            // surveyLocalId.toString(), //int.parse(detail.surveyId),
            mediaType: 'land',
            serverMediaId: media.id.toString(),
            isdeleted: 0,
            createdAt: 0,
            localPath: localPath, // ✅ store downloaded local file path
            isSynced: 1,
          ));
          print("LAND IMAGES");
          print(landImages.length);
          // print(landImages[0].localPath);
          // print(landImages[0].id);
        }

        List<SurveyMediaModel> otherImages = [];
        for (var media in apiResponse.data.surveyOtherDetailsImages ?? []) {
          // Download the image and get the local file path
          final localPath = await urlToLocalPath(media.mediaUrl);

          // Create SurveyMediaModel with localPath
          otherImages.add(SurveyMediaModel(
            surveyLocalId: apiResponse.data!.surveyId,
            mediaType: 'survey',
            serverMediaId: media.id.toString(),
            isdeleted: 0,
            createdAt: 0,
            localPath: localPath, // ✅ store downloaded local file path
            isSynced: 1,
          ));
          print("otherImages IMAGES");
          print(otherImages.length);
        }

        int insertedCount = await DatabaseHelper.instance.insertSurveyMediaList(
          surveyLocalId: apiResponse.data.surveyId, // keep as String
          landPictures: otherImages,
          surveyForms: landImages,
          consentForms: [],
        );

        if (insertedCount > 0) {
          print(
              "✅ Successfully inserted $insertedCount media files for survey ${apiResponse.data!.surveyId}");
        } else {
          print(
              "⚠️ No media files were inserted for survey ${apiResponse.data!.surveyId}");
        }

        print(
            "---------------------------------------------------------------");

        final againAdded = await DatabaseHelper.instance
            .getSurveyMediaCount(apiResponse.data.surveyId.toString());

        if (againAdded == 0) {
          print("✅ All survey media deleted successfully");
        } else {
          print("⚠ Still $againAdded images left in DB");
        }
          print("✅ ----------------updateSurveySyncFlags---------------");
           SurveyModel survey = SurveyModel(
            surveyId:
                apiResponse.data.surveyId.toString(), // never null
            userId: "1",
            landState: apiResponse.data.landStateName.toString(),
            landDistrict:
               apiResponse.data.landDistrictName.toString(),
            landTaluka:
               apiResponse.data.landTalukaName.toString(),
            landVillage:
                apiResponse.data.landVillageName.toString(),
            landStateID: apiResponse.data.landStateId.toString() ?? "",
            landDistrictID:apiResponse.data.landDistrictId.toString(),
            landTalukaID: apiResponse.data.landTalukaId.toString() ?? "",
            landVillageID:apiResponse.data.landVillageId.toString()?? "",
            substationDistrictID:
               apiResponse.data.subStationDistrictId.toString()?? "",
            substationTalukaID:
                apiResponse.data.subStationTalukaId.toString() ?? "",
            substationVillageID:
                apiResponse.data.subStationVillageId.toString() ?? "",
            landLatitude:apiResponse.data.landLatitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.landLatitude.toString()),
            landLongitude:apiResponse.data.landLongitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.landLongitude.toString()),
            landAreaInAcres:apiResponse.data.landAreaInAcres,
            landType:apiResponse.data.landType?? "",
            landRateCommercialEscalation:
                apiResponse.data.landRateCommercialEscalation ?? "",
            subStationName:
                apiResponse.data.subStationName ?? "",
            subStationDistrict: apiResponse.data.subStationDistrictName ??
                "",
            subStationTaluka:
              apiResponse.data.subStationTalukaName ??
                    "",
            subStationVillage:
                apiResponse.data.subStationVillageName ??
                    "",
            subStationLatitude: apiResponse.data.subStationLatitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.subStationLatitude.toString()),
            subStationLongitude: apiResponse.data.subStationLongitude.isEmpty ? 0.0 : double.parse(apiResponse.data.subStationLongitude.toString()),
            inchargeName:apiResponse.data.subStationInchargeName ?? "",
            subStationInchargeContact:apiResponse.data.subStationInchargeContact ?? "",
            operatorName: apiResponse.data.operatorName ?? "",
            operatorContact:apiResponse.data.operatorContact ?? "",
            subStationVoltageLevel:apiResponse.data.subStationVoltageLevel ?? "",
            subStationCapacity: apiResponse.data.subStationCapacity ?? "",
            distanceSubStationToLand:apiResponse.data.distanceSubStationToLand ?? "",
            plotDistanceFromMainRoad: apiResponse.data.plotDistanceFromMainRoad ?? "",
            evacuationLevel:apiResponse.data.evacuationLevel ?? "",
            windZone:apiResponse.data.windZone ?? "",
            groundWaterRainFall:apiResponse.data.groundWaterRainfall ?? "",
            soilType:apiResponse.data.soilType ?? "",
            nearestHighway:apiResponse.data.nearestHighway ?? "",
            // surveyForms: basicFormProvider.surveyFormsmediaFile != null ? [basicFormProvider.surveyFormsmediaFile!.path!] : [],
            // landPictures: basicFormProvider.OtherLandmediaFiles.where((file) => file != null) // keep only non-null
            //     .map((file) => file!.path) // extract paths
            //     .toList(),
            landPictures: otherImages,
            surveyForms:landImages,
            consentForms: [],
            isSync:  int.parse(apiResponse.data.isSync.toString()),
            serverSynced: 1,
             needSynced:0,
            isSurveyapproved: apiResponse.data.isSurveyApproved,
            consentAvailable: apiResponse.data.consentAvailable,
            selectedLanguage: apiResponse.data.selectedLanguage,
            surveyDate:DateTime.parse(apiResponse.data.createdAt.toString()).millisecondsSinceEpoch,

            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
            surveyStatus:apiResponse.data.approvalStatus.approvalStatusName,);


              print(
            "---------------------------------------------------------------");

            print("------------UPDATED ID----------------");
 final updatedRows = await DatabaseHelper.instance
              .updateSurveyBySurveyId(survey,survey.surveyId!);
          print("Survey : ${survey.surveyId}");
              print("Survey : ${survey.surveyStatus}");
          print("Survey : ${survey.isSurveyapproved}");
          if (updatedRows > 0) {
            print("✅ Survey updated successfully");
          } else {
            print("⚠️ No survey found to update");
          }

        
      } else {
        final message = apiResponse.message;
        print(message);
        showToast(message);
      }
      }
      else
      {
        
        showToast(jsonResponse['message']);
      }
     Navigator.of(routeGlobalKey.currentContext!).pop();
    } else {
      var responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      print('Error: ${response.statusCode}');
      // Failure
      print('Error: ${response.statusCode}');
      showToast("Server Not Responding ${response.statusCode}");
       Navigator.of(routeGlobalKey.currentContext!).pop();
    }
  }
  Future<void> submitMultipleLandSurvey(SurveyModel surveyModel) async {
    var uri = Uri.parse(APIManager.createLAndSurvey);

    // Creating a multipart request
    var request = http.MultipartRequest('POST', uri);
    print("APIManager.createLAndSurvey");
    print(APIManager.createLAndSurvey);
    // Add the post text as form data
    request.fields['survey_id'] = surveyModel.surveyId.toString();
    request.fields['land_location'] = surveyModel.landLocation ?? "";

    request.fields['land_state_id'] = surveyModel.landStateID.toString();
    request.fields['land_state_name'] = surveyModel.landState ?? "";

    request.fields['land_district_id'] = surveyModel.landDistrictID ?? "";
    request.fields['land_district_name'] = surveyModel.landDistrict ?? "";

    request.fields['land_taluka_id'] = surveyModel.landTalukaID ?? "";
    request.fields['land_taluka_name'] = surveyModel.landTaluka ?? "";

    request.fields['land_village_id'] = surveyModel.landVillageID ?? "";
    request.fields['land_village_name'] = surveyModel.landVillage ?? "";

    request.fields['land_latitude'] = surveyModel.landLatitude.toString() ?? "";
    request.fields['land_longitude'] =
        surveyModel.landLongitude.toString() ?? "";

    request.fields['land_area_in_acres'] = surveyModel.landAreaInAcres ?? "";
    request.fields['land_type'] =
        surveyModel.landType  ?? "";

        //== "1" ? "Rent" : "Lease";
    request.fields['land_rate_commercial_escalation'] =
        surveyModel.landRateCommercialEscalation ?? "";

    request.fields['sub_station_name'] = surveyModel.subStationName ?? "";

    request.fields['sub_station_district_id'] =
        surveyModel.substationDistrictID ?? "";
    request.fields['sub_station_district_name'] =
        surveyModel.subStationDistrict ?? "";

    request.fields['sub_station_taluka_id'] =
        surveyModel.substationTalukaID ?? "";
    request.fields['sub_station_taluka_name'] =
        surveyModel.subStationTaluka ?? "";

    request.fields['sub_station_village_id'] =
        surveyModel.substationVillageID ?? "";
    request.fields['sub_station_village_name'] =
        surveyModel.subStationVillage ?? "";

    request.fields['sub_station_latitude'] =
        surveyModel.subStationLatitude.toString() ?? "";
    request.fields['sub_station_longitude'] =
        surveyModel.subStationLongitude.toString() ?? "";

    request.fields['sub_station_incharge_contact'] =
        surveyModel.subStationInchargeContact ?? "";
    request.fields['sub_station_incharge_name'] =
        surveyModel.inchargeName ?? "";

    request.fields['operator_name'] = surveyModel.operatorName ?? "";
    request.fields['operator_contact'] = surveyModel.operatorContact ?? "";

    request.fields['sub_station_voltage_level'] =
        surveyModel.subStationVoltageLevel ?? "";
    request.fields['sub_station_capacity'] =
        surveyModel.subStationCapacity ?? "";

    request.fields['distance_sub_station_to_land'] =
        surveyModel.distanceSubStationToLand ?? "";
    request.fields['plot_distance_from_main_road'] =
        surveyModel.plotDistanceFromMainRoad ?? "";

    request.fields['evacuation_level'] = surveyModel.evacuationLevel ?? "";
    request.fields['soil_type'] = surveyModel.soilType ?? "";
    request.fields['wind_zone'] = surveyModel.windZone ?? "";
    request.fields['ground_water_rainfall'] =
        surveyModel.groundWaterRainFall ?? "";

    request.fields['nearest_highway'] = surveyModel.nearestHighway ?? "";

    request.fields['consent_available'] =
        surveyModel.consentAvailable.toString() ?? "";
    request.fields['is_sync'] = surveyModel.isSync.toString() ?? "";
    request.fields['is_survey_approved'] =
        surveyModel.isSurveyapproved.toString() ?? "";

    request.fields['selected_language'] = surveyModel.selectedLanguage ?? "";
    request.fields['survey_status'] = (surveyModel.surveyStatus == "pending" ||
            surveyModel.surveyStatus == "Pending")
        ? "1"
        : surveyModel.surveyStatus == "Awaiting Approval"
            ? "2"
            : surveyModel.surveyStatus == "Approved"
                ? "3"
                : surveyModel.surveyStatus == "Rejected"
                    ? "4"
                    : "0";
    logLong(
      const JsonEncoder.withIndent('  ').convert(request.fields),
    );
    // debugPrint("CREATE ${request.fields}");
    String? token = await SPManager().getAuthToken();
    // Add the files to the request
    print("HYWORTH");
    print(surveyModel.surveyForms.length);
    for (var file in surveyModel.surveyForms!) {
      print("HYWORTH");
      print(file.localPath);
      print(file.serverMediaId);
      var mimeType = lookupMimeType(
          file.localPath); // Get mime type based on file extension
      var multipartFile = await http.MultipartFile.fromPath(
          'survey_images', file.localPath,
          contentType: mimeType != null
              ? MediaType.parse(mimeType)
              : MediaType('application', 'octet-stream'));
      request.files.add(multipartFile);
    }
    for (var file in surveyModel.landPictures!) {
      var mimeType = lookupMimeType(
          file.localPath!); // Get mime type based on file extension
      var multipartFile = await http.MultipartFile.fromPath(
          'other_images', file.localPath,
          contentType: mimeType != null
              ? MediaType.parse(mimeType)
              : MediaType('application', 'octet-stream'));
      request.files.add(multipartFile);
    }
    // for (var file in surveyModel.consentForms!) {
    //   var mimeType = lookupMimeType(
    //       file.localPath!); // Get mime type based on file extension
    //   var multipartFile = await http.MultipartFile.fromPath(
    //       'consents', file.localPath,
    //       contentType: mimeType != null
    //           ? MediaType.parse(mimeType)
    //           : MediaType('application', 'octet-stream'));
    //   request.files.add(multipartFile);
    // }
    // print(request.files);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${token}';
    request.headers['Cookie'] =
        "connect.sid=s%3A2tdDJk7GtxkDgwdGLz5i-8Q3zrIf8Jab.Km0GWJSzt2vY96oF19B8CTleU%2F7HZstVOdCsfSgcMLM";

    // Sending the request
    var response = await request.send();
    print('Post uploaded successfully');

    // Handle the response
    if (response.statusCode == 200) {
      // Success

      var responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      final jsonResponse = json.decode(responseData);
      if(jsonResponse['success']==true){
         final apiResponse = LandSurveyCreatedModel.fromJson(jsonResponse);
// Now access the message
      final message = jsonResponse['message']; // or whatever key your API uses
      print("RUCHITA CREATED LIST IN SERVER");
      if (apiResponse.success == true) {
        print(apiResponse.data!.surveyId!);
        var db = DatabaseHelper.instance;
       
        // final result = await Navigator.of(routeGlobalKey.currentContext!).push(
        //   createSlideFromBottomRoute(
        //     Maintabscreen(),
        //   ),
        // );
print("----HARD DELETED----");
     
        await DatabaseHelper.instance.hardDeleteSurveyMediaByServerId(
          surveyLocalId: apiResponse.data.surveyId.toString(),
        );
print("----AFETR DELETED----");
        final remaining = await DatabaseHelper.instance
            .getSurveyMediaCount(apiResponse.data.surveyId.toString());

        if (remaining == 0) {
          print("✅ All survey media deleted successfully");
        } else {
          print("⚠ Still $remaining images left in DB");
        }
print("----INSERTION AFTER DELETED----");
        List<SurveyMediaModel> landImages = [];
        for (var media in apiResponse.data!.surveyLandImages ?? []) {
          // Download the image and get the local file path
          print(media);
          final localPath = await urlToLocalPath(media.mediaUrl);

          // Create SurveyMediaModel with localPath
          landImages.add(SurveyMediaModel(
            surveyLocalId: apiResponse.data!.surveyId,
            // surveyLocalId.toString(), //int.parse(detail.surveyId),
            mediaType: 'land',
            serverMediaId: media.id.toString(),
            isdeleted: 0,
            createdAt: 0,
            localPath: localPath, // ✅ store downloaded local file path
            isSynced: 1,
          ));
          print("LAND IMAGES");
          print(landImages.length);
          // print(landImages[0].localPath);
          // print(landImages[0].id);
        }

        List<SurveyMediaModel> otherImages = [];
        for (var media in apiResponse.data.surveyOtherDetailsImages ?? []) {
          // Download the image and get the local file path
          final localPath = await urlToLocalPath(media.mediaUrl);

          // Create SurveyMediaModel with localPath
          otherImages.add(SurveyMediaModel(
            surveyLocalId: apiResponse.data!.surveyId,
            mediaType: 'survey',
            serverMediaId: media.id.toString(),
            isdeleted: 0,
            createdAt: 0,
            localPath: localPath, // ✅ store downloaded local file path
            isSynced: 1,
          ));
          print("otherImages IMAGES");
          print(otherImages.length);
        }

        int insertedCount = await DatabaseHelper.instance.insertSurveyMediaList(
          surveyLocalId: apiResponse.data.surveyId, // keep as String
          landPictures: otherImages,
          surveyForms: landImages,
          consentForms: [],
        );

        if (insertedCount > 0) {
          print(
              "✅ Successfully inserted $insertedCount media files for survey ${apiResponse.data!.surveyId}");
        } else {
          print(
              "⚠️ No media files were inserted for survey ${apiResponse.data!.surveyId}");
        }

        print(
            "---------------------------------------------------------------");

        final againAdded = await DatabaseHelper.instance
            .getSurveyMediaCount(apiResponse.data.surveyId.toString());

        if (againAdded == 0) {
          print("✅ All survey media deleted successfully");
        } else {
          print("⚠ Still $againAdded images left in DB");
        }
          print("✅ ----------------updateSurveySyncFlags---------------");
           SurveyModel survey = SurveyModel(
            surveyId:
                apiResponse.data.surveyId.toString(), // never null
            userId: "1",
            landState: apiResponse.data.landStateName.toString(),
            landDistrict:
               apiResponse.data.landDistrictName.toString(),
            landTaluka:
               apiResponse.data.landTalukaName.toString(),
            landVillage:
                apiResponse.data.landVillageName.toString(),
            landStateID: apiResponse.data.landStateId.toString() ?? "",
            landDistrictID:apiResponse.data.landDistrictId.toString(),
            landTalukaID: apiResponse.data.landTalukaId.toString() ?? "",
            landVillageID:apiResponse.data.landVillageId.toString()?? "",
            substationDistrictID:
               apiResponse.data.subStationDistrictId.toString()?? "",
            substationTalukaID:
                apiResponse.data.subStationTalukaId.toString() ?? "",
            substationVillageID:
                apiResponse.data.subStationVillageId.toString() ?? "",
            landLatitude:apiResponse.data.landLatitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.landLatitude.toString()),
            landLongitude:apiResponse.data.landLongitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.landLongitude.toString()),
            landAreaInAcres:apiResponse.data.landAreaInAcres,
            landType:apiResponse.data.landType?? "",
            landRateCommercialEscalation:
                apiResponse.data.landRateCommercialEscalation ?? "",
            subStationName:
                apiResponse.data.subStationName ?? "",
            subStationDistrict: apiResponse.data.subStationDistrictName ??
                "",
            subStationTaluka:
              apiResponse.data.subStationTalukaName ??
                    "",
            subStationVillage:
                apiResponse.data.subStationVillageName ??
                    "",
            subStationLatitude: apiResponse.data.subStationLatitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.subStationLatitude.toString()),
            subStationLongitude: apiResponse.data.subStationLongitude.isEmpty ? 0.0 : double.parse(apiResponse.data.subStationLongitude.toString()),
            inchargeName:apiResponse.data.subStationInchargeName ?? "",
            subStationInchargeContact:apiResponse.data.subStationInchargeContact ?? "",
            operatorName: apiResponse.data.operatorName ?? "",
            operatorContact:apiResponse.data.operatorContact ?? "",
            subStationVoltageLevel:apiResponse.data.subStationVoltageLevel ?? "",
            subStationCapacity: apiResponse.data.subStationCapacity ?? "",
            distanceSubStationToLand:apiResponse.data.distanceSubStationToLand ?? "",
            plotDistanceFromMainRoad: apiResponse.data.plotDistanceFromMainRoad ?? "",
            evacuationLevel:apiResponse.data.evacuationLevel ?? "",
            windZone:apiResponse.data.windZone ?? "",
            groundWaterRainFall:apiResponse.data.groundWaterRainfall ?? "",
            soilType:apiResponse.data.soilType ?? "",
            nearestHighway:apiResponse.data.nearestHighway ?? "",
            // surveyForms: basicFormProvider.surveyFormsmediaFile != null ? [basicFormProvider.surveyFormsmediaFile!.path!] : [],
            // landPictures: basicFormProvider.OtherLandmediaFiles.where((file) => file != null) // keep only non-null
            //     .map((file) => file!.path) // extract paths
            //     .toList(),
            landPictures: otherImages,
            surveyForms:landImages,
            consentForms: [],
            isSync:  int.parse(apiResponse.data.isSync.toString()),
            serverSynced: 1,
             needSynced:0,
            isSurveyapproved: apiResponse.data.isSurveyApproved,
            consentAvailable: apiResponse.data.consentAvailable,
            selectedLanguage: apiResponse.data.selectedLanguage,
            surveyDate:DateTime.parse(apiResponse.data.createdAt.toString()).millisecondsSinceEpoch,

            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
            surveyStatus:apiResponse.data.approvalStatus.approvalStatusName,);


              print(
            "---------------------------------------------------------------");

            print("------------UPDATED ID----------------");
 final updatedRows = await DatabaseHelper.instance
              .updateSurveyBySurveyId(survey,survey.surveyId!);
          print("Survey : ${survey.surveyId}");
              print("Survey : ${survey.surveyStatus}");
          print("Survey : ${survey.isSurveyapproved}");
          if (updatedRows > 0) {
            print("✅ Survey updated successfully");
          } else {
            print("⚠️ No survey found to update");
          }

        
      } else {
        final message = apiResponse.message;
        print(message);
        showToast(message);
      }
      }
      else
      {
        
        showToast(jsonResponse['message']);
      }
     
    } else {
      var responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      print('Error: ${response.statusCode}');
      // Failure
      print('Error: ${response.statusCode}');
      showToast("Server Not Responding ${response.statusCode}");
      
    }
  }

Future<List<SurveyModel>> getSurveysNeedingSync() async {
  final db = await DatabaseHelper.instance.database;
  final res = await db.query(
    'survey',
    where: 'needSynced = ?',
    whereArgs: [1],
  );
  return res.map((e) => SurveyModel.fromJsonDB(e)).toList();
}


Future<void> uploadConsentLandSurvey(List<SurveyMediaModel> consentForm,String id) async {
    var uri = Uri.parse(APIManager.createLAndSurvey);

    // Creating a multipart request
    var request = http.MultipartRequest('POST', uri);
    print("APIManager.uploadConsentSurvey");
    print(APIManager.uploadConsentSurvey);
    // Add the post text as form data
    request.fields['land_survey_id'] = id;
    
    logLong(
      const JsonEncoder.withIndent('  ').convert(request.fields),
    );
    // debugPrint("CREATE ${request.fields}");
    String? token = await SPManager().getAuthToken();
    // Add the files to the request
    print("HYWORTH CONSENT");
    print(consentForm.length);

    for (var file in consentForm!) {
      var mimeType = lookupMimeType(
          file.localPath!); // Get mime type based on file extension
      var multipartFile = await http.MultipartFile.fromPath(
          'consents', file.localPath,
          contentType: mimeType != null
              ? MediaType.parse(mimeType)
              : MediaType('application', 'octet-stream'));
      request.files.add(multipartFile);
    }
    // print(request.files);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${token}';
    request.headers['Cookie'] =
        "connect.sid=s%3A2tdDJk7GtxkDgwdGLz5i-8Q3zrIf8Jab.Km0GWJSzt2vY96oF19B8CTleU%2F7HZstVOdCsfSgcMLM";

    // Sending the request
//     var response = await request.send();
//     print('Post COnSent uploaded successfully');

//     // Handle the response
//     if (response.statusCode == 200) {
//       // Success

//       var responseData = await response.stream.bytesToString();
//       print('Response: $responseData');
//       final jsonResponse = json.decode(responseData);
//       if(jsonResponse['success']==true){
//          final apiResponse = LandSurveyCreatedModel.fromJson(jsonResponse);
// // Now access the message
//       final message = jsonResponse['message']; // or whatever key your API uses
//       print("RUCHITA Upload consent IN SERVER");
//       if (apiResponse.success == true) {
//         print(apiResponse.data!.surveyId!);
//         var db = DatabaseHelper.instance;
       
       
        
//       } else {
//         final message = apiResponse.message;
//         print(message);
//         showToast(message);
//       }
//       }
//       else
//       {
        
//         showToast(jsonResponse['message']);
//       }
     
    // } else {
    //   var responseData = await response.stream.bytesToString();
    //   print('Response: $responseData');
    //   print('Error: ${response.statusCode}');
    //   // Failure
    //   print('Error: ${response.statusCode}');
    //   showToast("Server Not Responding ${response.statusCode}");
    // }
  }

//UPDATE LAND SURVEY
  void logLong(String text) {
    const chunk = 500;
    for (int i = 0; i < text.length; i += chunk) {
      print(text.substring(
        i,
        i + chunk > text.length ? text.length : i + chunk,
      ));
    }
  }

  String buildKeepIdsString(SurveyModel surveyModel) {
    final parts = [
      buildPart(1, surveyModel.consentForms), // consentKeepIds
      buildPart(2, surveyModel.surveyForms), // surveyImageKeepIds
      buildPart(3, surveyModel.landPictures), // otherImageKeepIds
    ].where((p) => p.isNotEmpty).toList();

    final keepIdsString = parts.join('|');

    return keepIdsString;
  }

  String buildPart(int type, List<SurveyMediaModel>? files) {
    print("buildPart");
    print("type ${type}");
    print("file ${files!.length}");
    print("KeepId");

    if (files == null) return '';

    final ids = files
        .where((f) =>
            f.serverMediaId != null &&
            f.serverMediaId != 0) // only existing server files
        .map((f) => f.serverMediaId.toString())
        .toList();
    print(ids);
    debugPrint('Type $type IDs: $ids'); // 🔹 print the IDs for this type

    if (ids.isEmpty) return '';

    return '$type:${ids.join(',')}';
  }

  Future<void> updateLandSurvey(SurveyModel surveyModel,int id) async {
    var uri = Uri.parse(APIManager.updateLAndSurvey);

    // Creating a multipart request
    var request = http.MultipartRequest('POST', uri);
    print("APIManager.updateLAndSurvey");
    print(APIManager.updateLAndSurvey);
    // Add the post text as form data
    request.fields['land_survey_id'] = surveyModel.surveyId.toString();
    request.fields['land_location'] = surveyModel.landLocation ?? "";

    request.fields['land_state_id'] = surveyModel.landStateID.toString();
    request.fields['land_state_name'] = surveyModel.landState ?? "";

    request.fields['land_district_id'] = surveyModel.landDistrictID ?? "";
    request.fields['land_district_name'] = surveyModel.landDistrict ?? "";

    request.fields['land_taluka_id'] = surveyModel.landTalukaID ?? "";
    request.fields['land_taluka_name'] = surveyModel.landTaluka ?? "";

    request.fields['land_village_id'] = surveyModel.landVillageID ?? "";
    request.fields['land_village_name'] = surveyModel.landVillage ?? "";

    request.fields['land_latitude'] = surveyModel.landLatitude.toString() ?? "";
    request.fields['land_longitude'] =
        surveyModel.landLongitude.toString() ?? "";

    request.fields['land_area_in_acres'] = surveyModel.landAreaInAcres ?? "";
    request.fields['land_type'] = surveyModel.landType ?? "";
    // == "1"
    //     ? "Rent"
    //     : "Lease"; // surveyModel.landType?? "";
    request.fields['land_rate_commercial_escalation'] =
        surveyModel.landRateCommercialEscalation ?? "";

    request.fields['sub_station_name'] = surveyModel.subStationName ?? "";

    request.fields['sub_station_district_id'] =
        surveyModel.substationDistrictID ?? "";
    request.fields['sub_station_district_name'] =
        surveyModel.subStationDistrict ?? "";

    request.fields['sub_station_taluka_id'] =
        surveyModel.substationTalukaID ?? "";
    request.fields['sub_station_taluka_name'] =
        surveyModel.subStationTaluka ?? "";

    request.fields['sub_station_village_id'] =
        surveyModel.substationVillageID ?? "";
    request.fields['sub_station_village_name'] =
        surveyModel.subStationVillage ?? "";

    request.fields['sub_station_latitude'] =
        surveyModel.subStationLatitude.toString() ?? "";
    request.fields['sub_station_longitude'] =
        surveyModel.subStationLongitude.toString() ?? "";

    request.fields['sub_station_incharge_contact'] =
        surveyModel.subStationInchargeContact ?? "";
    request.fields['sub_station_incharge_name'] =
        surveyModel.inchargeName ?? "";

    request.fields['operator_name'] = surveyModel.operatorName ?? "";
    request.fields['operator_contact'] = surveyModel.operatorContact ?? "";

    request.fields['sub_station_voltage_level'] =
        surveyModel.subStationVoltageLevel ?? "";
    request.fields['sub_station_capacity'] =
        surveyModel.subStationCapacity ?? "";

    request.fields['distance_sub_station_to_land'] =
        surveyModel.distanceSubStationToLand ?? "";
    request.fields['plot_distance_from_main_road'] =
        surveyModel.plotDistanceFromMainRoad ?? "";

    request.fields['evacuation_level'] = surveyModel.evacuationLevel ?? "";
    request.fields['soil_type'] = surveyModel.soilType ?? "";
    request.fields['wind_zone'] = surveyModel.windZone ?? "";
    request.fields['ground_water_rainfall'] =
        surveyModel.groundWaterRainFall ?? "";

    request.fields['nearest_highway'] = surveyModel.nearestHighway ?? "";

    request.fields['consent_available'] =
        surveyModel.consentAvailable.toString() ?? "";
    request.fields['is_sync'] = surveyModel.isSync.toString() ?? "";
    request.fields['is_survey_approved'] =
        surveyModel.isSurveyapproved.toString() ?? "";

    request.fields['selected_language'] = surveyModel.selectedLanguage ?? "";
    // request.fields['survey_status'] = "0"; //surveyModel.surveyStatus?? "";
    request.fields['survey_status'] = (surveyModel.surveyStatus == "pending" ||
            surveyModel.surveyStatus == "Pending")
        ? "1"
        : surveyModel.surveyStatus == "Awaiting Approval"
            ? "2"
            : surveyModel.surveyStatus == "Approved"
                ? "3"
                : surveyModel.surveyStatus == "Rejected"
                    ? "4"
                    : "0";
    print("LAND IDS");
    print("AAAAAA");
   
    final keepIds = buildKeepIdsString(surveyModel);

    if (keepIds.isNotEmpty) {
      print(keepIds);
      request.fields['existing_images'] = keepIds;
    }

    print(request.fields);
    print("UPDATED IMAGES PATH");
    print(surveyModel.surveyForms!.length);
    print(surveyModel.landPictures.length);
    String? token = await SPManager().getAuthToken();
    // Add the files to the request
    // for (var file in surveyModel.surveyForms) {
    //   var mimeType = lookupMimeType(
    //       file.localPath); // Get mime type based on file extension
    //   var multipartFile = await http.MultipartFile.fromPath(
    //       'survey_images', file.localPath,
    //       contentType: mimeType != null
    //           ? MediaType.parse(mimeType)
    //           : MediaType('application', 'octet-stream'));
    //   request.files.add(multipartFile);
    // }
 logLong(
      const JsonEncoder.withIndent('  ').convert(request.fields),
    );
    for (var file in surveyModel.surveyForms) {
      // ✅ upload ONLY new (local) images
      if (file.serverMediaId.isNotEmpty) {
        print("⏭ Skipping survey_images server image: ${file.serverMediaId}");
        continue;
      }

      print("⬆ Uploading NEW land picture");
      print("path: ${file.localPath}");
      print("⏭ ID server survey_images image: ${file.serverMediaId}");
      final mimeType = lookupMimeType(file.localPath);
      final multipartFile = await http.MultipartFile.fromPath(
        'survey_images',
        file.localPath,
        contentType: mimeType != null
            ? MediaType.parse(mimeType)
            : MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);
    }
    
    for (var file in surveyModel.landPictures) {
      // ✅ upload ONLY new (local) images
      if (file.serverMediaId.isNotEmpty) {
        print("⏭ Skipping  other_images server image: ${file.serverMediaId}");
        continue;
      }

      print("⬆ Uploading NEW land picture");
      print("path: ${file.localPath}");
      print("⏭ ID other_images image: ${file.serverMediaId}");
      final mimeType = lookupMimeType(file.localPath);
      final multipartFile = await http.MultipartFile.fromPath(
        'other_images',
        file.localPath,
        contentType: mimeType != null
            ? MediaType.parse(mimeType)
            : MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);
    }
    // for (var file in surveyModel.consentForms) {
    //   // ✅ upload ONLY new (local) images
    //   if (file.serverMediaId.isNotEmpty) {
    //     print("⏭ Skipping consentForms server image: ${file.serverMediaId}");
    //     continue;
    //   }

    //   print("⬆ Uploading NEW land picture");
    //   print("path: ${file.localPath}");
    //   print("⏭ ID server consentForms image: ${file.serverMediaId}");
    //   final mimeType = lookupMimeType(file.localPath);
    //   final multipartFile = await http.MultipartFile.fromPath(
    //     'consents',
    //     file.localPath,
    //     contentType: mimeType != null
    //         ? MediaType.parse(mimeType)
    //         : MediaType('application', 'octet-stream'),
    //   );

    //   request.files.add(multipartFile);
    // }

    print(request.files);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${token}';
    request.headers['Cookie'] =
        "connect.sid=s%3A2tdDJk7GtxkDgwdGLz5i-8Q3zrIf8Jab.Km0GWJSzt2vY96oF19B8CTleU%2F7HZstVOdCsfSgcMLM";

    // Sending the request
    var response = await request.send();
    print('Post uploaded successfully');
    // Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success

      var responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      final jsonResponse = json.decode(responseData);
      final apiResponse = LandSurveyUpdateResponse.fromJson(jsonResponse);
// Now access the message1
      print(apiResponse);

      print("RUCHITA UPDATED LIST IN SERVER");
      var db = DatabaseHelper.instance;

     
     print("----HARD DELETED AT UPDATE----");
        await db.hardDeleteSurveyMediaByServerId(
            surveyLocalId: apiResponse.data.surveyId.toString());
        await DatabaseHelper.instance.hardDeleteSurveyMediaByServerId(
          surveyLocalId: apiResponse.data.surveyId.toString(),
        );
print("----AFETR DELETED AT UPDATE----");
        final remaining = await DatabaseHelper.instance
            .getSurveyMediaCount(apiResponse.data.surveyId.toString());

        if (remaining == 0) {
          print("✅ All survey media deleted successfully");
        } else {
          print("⚠ Still $remaining images left in DB");
        }
print("----INSERTION AFTER DELETED----");
        List<SurveyMediaModel> landImages = [];
        for (var media in apiResponse.data.surveyLandImages ?? []) {
          // Download the image and get the local file path
          print(media);
          final localPath = await urlToLocalPath(media.mediaUrl);

          // Create SurveyMediaModel with localPath
          landImages.add(SurveyMediaModel(
            surveyLocalId: apiResponse.data.surveyId,
            // surveyLocalId.toString(), //int.parse(detail.surveyId),
            mediaType: 'land',
            serverMediaId: media.id.toString(),
            isdeleted: 0,
            createdAt: 0,
            localPath: localPath, // ✅ store downloaded local file path
            isSynced: 1,
          ));
          print("LAND IMAGES");
          print(landImages.length);
          // print(landImages[0].localPath);
          // print(landImages[0].id);
        }

        List<SurveyMediaModel> otherImages = [];
        for (var media in apiResponse.data.surveyOtherDetailsImages ?? []) {
          // Download the image and get the local file path
          final localPath = await urlToLocalPath(media.mediaUrl);

          // Create SurveyMediaModel with localPath
          otherImages.add(SurveyMediaModel(
            surveyLocalId: apiResponse.data!.surveyId,
            mediaType: 'survey',
            serverMediaId: media.id.toString(),
            isdeleted: 0,
            createdAt: 0,
            localPath: localPath, // ✅ store downloaded local file path
            isSynced: 1,
          ));
          print("otherImages IMAGES");
          print(otherImages.length);
        }

        int insertedCount = await DatabaseHelper.instance.insertSurveyMediaList(
          surveyLocalId: apiResponse.data.surveyId, // keep as String
          landPictures: otherImages,
          surveyForms: landImages,
          consentForms: [],
        );

        if (insertedCount > 0) {
          print(
              "✅ Successfully inserted $insertedCount media files for survey ${apiResponse.data!.surveyId}");
        } else {
          print(
              "⚠️ No media files were inserted for survey ${apiResponse.data!.surveyId}");
        }

        print(
            "---------------------------------------------------------------");

        final againAdded = await DatabaseHelper.instance
            .getSurveyMediaCount(apiResponse.data.surveyId.toString());

        if (againAdded == 0) {
          print("✅ All survey media deleted successfully");
        } else {
          print("⚠ Still $againAdded images left in DB");
        }

 SurveyModel survey = SurveyModel(
            surveyId:
                apiResponse.data.surveyId.toString(), // never null
            userId: "1",
            landState: apiResponse.data.landStateName.toString(),
            landDistrict:
               apiResponse.data.landDistrictName.toString(),
            landTaluka:
               apiResponse.data.landTalukaName.toString(),
            landVillage:
                apiResponse.data.landVillageName.toString(),
            landStateID: apiResponse.data.landStateId.toString() ?? "",
            landDistrictID:apiResponse.data.landDistrictId.toString(),
            landTalukaID: apiResponse.data.landTalukaId.toString() ?? "",
            landVillageID:apiResponse.data.landVillageId.toString()?? "",
            substationDistrictID:
               apiResponse.data.subStationDistrictId.toString()?? "",
            substationTalukaID:
                apiResponse.data.subStationTalukaId.toString() ?? "",
            substationVillageID:
                apiResponse.data.subStationVillageId.toString() ?? "",
            landLatitude:apiResponse.data.landLatitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.landLatitude.toString()),
            landLongitude:apiResponse.data.landLongitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.landLongitude.toString()),
            landAreaInAcres:apiResponse.data.landAreaInAcres,
            landType:apiResponse.data.landType?? "",
            landRateCommercialEscalation:
                apiResponse.data.landRateCommercialEscalation ?? "",
            subStationName:
                apiResponse.data.subStationName ?? "",
            subStationDistrict: apiResponse.data.subStationDistrictName ??
                "",
            subStationTaluka:
              apiResponse.data.subStationTalukaName ??
                    "",
            subStationVillage:
                apiResponse.data.subStationVillageName ??
                    "",
            subStationLatitude: apiResponse.data.subStationLatitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.subStationLatitude.toString()),
            subStationLongitude: apiResponse.data.subStationLongitude.isEmpty ? 0.0 : double.parse(apiResponse.data.subStationLongitude.toString()),
            inchargeName:apiResponse.data.subStationInchargeName ?? "",
            subStationInchargeContact:apiResponse.data.subStationInchargeContact ?? "",
            operatorName: apiResponse.data.operatorName ?? "",
            operatorContact:apiResponse.data.operatorContact ?? "",
            subStationVoltageLevel:apiResponse.data.subStationVoltageLevel ?? "",
            subStationCapacity: apiResponse.data.subStationCapacity ?? "",
            distanceSubStationToLand:apiResponse.data.distanceSubStationToLand ?? "",
            plotDistanceFromMainRoad: apiResponse.data.plotDistanceFromMainRoad ?? "",
            evacuationLevel:apiResponse.data.evacuationLevel ?? "",
            windZone:apiResponse.data.windZone ?? "",
            groundWaterRainFall:apiResponse.data.groundWaterRainfall ?? "",
            soilType:apiResponse.data.soilType ?? "",
            nearestHighway:apiResponse.data.nearestHighway ?? "",
            // surveyForms: basicFormProvider.surveyFormsmediaFile != null ? [basicFormProvider.surveyFormsmediaFile!.path!] : [],
            // landPictures: basicFormProvider.OtherLandmediaFiles.where((file) => file != null) // keep only non-null
            //     .map((file) => file!.path) // extract paths
            //     .toList(),
            landPictures: otherImages,
            surveyForms:landImages,
            consentForms: [],
            isSync:  int.parse(apiResponse.data.isSync.toString()),
            serverSynced: 1,
             needSynced:0,
            isSurveyapproved: 0,
            consentAvailable: 0,
            selectedLanguage: apiResponse.data.selectedLanguage,
            surveyDate:DateTime.parse(apiResponse.data.createdAt).millisecondsSinceEpoch,

            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
            surveyStatus:apiResponse.data.approvalStatus.approvalStatusName,);


              print(
            "---------------------------------------------------------------");

            print("------------${id.toString()}----------------");
 final updatedRows = await DatabaseHelper.instance
              .updateSurveyBySurveyId(survey,survey.surveyId!);
          print("Survey : ${survey.surveyId}");
              print("Survey : ${survey.surveyStatus}");
          print("Survey : ${survey.isSurveyapproved}");
          if (updatedRows > 0) {
            print("✅ Survey updated successfully");
          } else {
            print("⚠️ No survey found to update");
          }
 Navigator.of(routeGlobalKey.currentContext!).pop();
      //    await db.updateSurveySyncFlags(
      //   surveyId: apiResponse.data.surveyId.toString(),
      //   syncStatus:
      //       int.parse(apiResponse.data.isSync.toString()), // update pending
      //   serverSynced: 1,
      //   surveyStatus: apiResponse.data.surveyStatus.toString(),
        
      // );
      // Navigator.canPop(context,true);
      //  await Navigator.of(routeGlobalKey.currentContext!).push(
      //     createSlideFromBottomRoute(
      //       Maintabscreen(),
      //     ),
      //   );
    } else {
      var responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      print('Error: ${response.statusCode}');
      // Failure
      print('Error: ${response.statusCode}');
       Navigator.of(routeGlobalKey.currentContext!).pop();
    }
  }
//UPDATE MULTIPLE


 Future<void> updateMultipleLandSurvey(SurveyModel surveyModel,int id) async {
    var uri = Uri.parse(APIManager.updateLAndSurvey);

    // Creating a multipart request
    var request = http.MultipartRequest('POST', uri);
    print("APIManager.updateLAndSurvey");
    print(APIManager.updateLAndSurvey);
    // Add the post text as form data
    request.fields['land_survey_id'] = surveyModel.surveyId.toString();
    request.fields['land_location'] = surveyModel.landLocation ?? "";

    request.fields['land_state_id'] = surveyModel.landStateID.toString();
    request.fields['land_state_name'] = surveyModel.landState ?? "";

    request.fields['land_district_id'] = surveyModel.landDistrictID ?? "";
    request.fields['land_district_name'] = surveyModel.landDistrict ?? "";

    request.fields['land_taluka_id'] = surveyModel.landTalukaID ?? "";
    request.fields['land_taluka_name'] = surveyModel.landTaluka ?? "";

    request.fields['land_village_id'] = surveyModel.landVillageID ?? "";
    request.fields['land_village_name'] = surveyModel.landVillage ?? "";

    request.fields['land_latitude'] = surveyModel.landLatitude.toString() ?? "";
    request.fields['land_longitude'] =
        surveyModel.landLongitude.toString() ?? "";

    request.fields['land_area_in_acres'] = surveyModel.landAreaInAcres ?? "";
    request.fields['land_type'] = surveyModel.landType ?? "";
    // == "1"
    //     ? "Rent"
    //     : "Lease"; // surveyModel.landType?? "";
    request.fields['land_rate_commercial_escalation'] =
        surveyModel.landRateCommercialEscalation ?? "";

    request.fields['sub_station_name'] = surveyModel.subStationName ?? "";

    request.fields['sub_station_district_id'] =
        surveyModel.substationDistrictID ?? "";
    request.fields['sub_station_district_name'] =
        surveyModel.subStationDistrict ?? "";

    request.fields['sub_station_taluka_id'] =
        surveyModel.substationTalukaID ?? "";
    request.fields['sub_station_taluka_name'] =
        surveyModel.subStationTaluka ?? "";

    request.fields['sub_station_village_id'] =
        surveyModel.substationVillageID ?? "";
    request.fields['sub_station_village_name'] =
        surveyModel.subStationVillage ?? "";

    request.fields['sub_station_latitude'] =
        surveyModel.subStationLatitude.toString() ?? "";
    request.fields['sub_station_longitude'] =
        surveyModel.subStationLongitude.toString() ?? "";

    request.fields['sub_station_incharge_contact'] =
        surveyModel.subStationInchargeContact ?? "";
    request.fields['sub_station_incharge_name'] =
        surveyModel.inchargeName ?? "";

    request.fields['operator_name'] = surveyModel.operatorName ?? "";
    request.fields['operator_contact'] = surveyModel.operatorContact ?? "";

    request.fields['sub_station_voltage_level'] =
        surveyModel.subStationVoltageLevel ?? "";
    request.fields['sub_station_capacity'] =
        surveyModel.subStationCapacity ?? "";

    request.fields['distance_sub_station_to_land'] =
        surveyModel.distanceSubStationToLand ?? "";
    request.fields['plot_distance_from_main_road'] =
        surveyModel.plotDistanceFromMainRoad ?? "";

    request.fields['evacuation_level'] = surveyModel.evacuationLevel ?? "";
    request.fields['soil_type'] = surveyModel.soilType ?? "";
    request.fields['wind_zone'] = surveyModel.windZone ?? "";
    request.fields['ground_water_rainfall'] =
        surveyModel.groundWaterRainFall ?? "";

    request.fields['nearest_highway'] = surveyModel.nearestHighway ?? "";

    request.fields['consent_available'] =
        surveyModel.consentAvailable.toString() ?? "";
    request.fields['is_sync'] = surveyModel.isSync.toString() ?? "";
    request.fields['is_survey_approved'] =
        surveyModel.isSurveyapproved.toString() ?? "";

    request.fields['selected_language'] = surveyModel.selectedLanguage ?? "";
    // request.fields['survey_status'] = "0"; //surveyModel.surveyStatus?? "";
    request.fields['survey_status'] = (surveyModel.surveyStatus == "pending" ||
            surveyModel.surveyStatus == "Pending")
        ? "1"
        : surveyModel.surveyStatus == "Awaiting Approval"
            ? "2"
            : surveyModel.surveyStatus == "Approved"
                ? "3"
                : surveyModel.surveyStatus == "Rejected"
                    ? "4"
                    : "0";
    print("LAND IDS");
    print("AAAAAA");
   
    final keepIds = buildKeepIdsString(surveyModel);

    if (keepIds.isNotEmpty) {
      print(keepIds);
      request.fields['existing_images'] = keepIds;
    }

    print(request.fields);
    print("UPDATED IMAGES PATH");
    print(surveyModel.surveyForms!.length);
    print(surveyModel.landPictures.length);
    String? token = await SPManager().getAuthToken();
   
 logLong(
      const JsonEncoder.withIndent('  ').convert(request.fields),
    );
    for (var file in surveyModel.surveyForms) {
      // ✅ upload ONLY new (local) images
      if (file.serverMediaId.isNotEmpty) {
        print("⏭ Skipping survey_images server image: ${file.serverMediaId}");
        continue;
      }

      print("⬆ Uploading Multiple NEW land picture");
      print("path: ${file.localPath}");
      print("⏭ ID server survey_images image: ${file.serverMediaId}");
      final mimeType = lookupMimeType(file.localPath);
      final multipartFile = await http.MultipartFile.fromPath(
        'survey_images',
        file.localPath,
        contentType: mimeType != null
            ? MediaType.parse(mimeType)
            : MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);
    }
    
    for (var file in surveyModel.landPictures) {
      // ✅ upload ONLY new (local) images
      if (file.serverMediaId.isNotEmpty) {
        print("⏭ Skipping  other_images server image: ${file.serverMediaId}");
        continue;
      }

      print("⬆ Uploading Multiple NEW land picture");
      print("path: ${file.localPath}");
      print("⏭ ID other_images image: ${file.serverMediaId}");
      final mimeType = lookupMimeType(file.localPath);
      final multipartFile = await http.MultipartFile.fromPath(
        'other_images',
        file.localPath,
        contentType: mimeType != null
            ? MediaType.parse(mimeType)
            : MediaType('application', 'octet-stream'),
      );

      request.files.add(multipartFile);
    }
    // for (var file in surveyModel.consentForms) {
    //   // ✅ upload ONLY new (local) images
    //   if (file.serverMediaId.isNotEmpty) {
    //     print("⏭ Skipping consentForms server image: ${file.serverMediaId}");
    //     continue;
    //   }

    //   print("⬆ Uploading NEW land picture");
    //   print("path: ${file.localPath}");
    //   print("⏭ ID server consentForms image: ${file.serverMediaId}");
    //   final mimeType = lookupMimeType(file.localPath);
    //   final multipartFile = await http.MultipartFile.fromPath(
    //     'consents',
    //     file.localPath,
    //     contentType: mimeType != null
    //         ? MediaType.parse(mimeType)
    //         : MediaType('application', 'octet-stream'),
    //   );

    //   request.files.add(multipartFile);
    // }

    print(request.files);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${token}';
    request.headers['Cookie'] =
        "connect.sid=s%3A2tdDJk7GtxkDgwdGLz5i-8Q3zrIf8Jab.Km0GWJSzt2vY96oF19B8CTleU%2F7HZstVOdCsfSgcMLM";

    // Sending the request
    var response = await request.send();
    print('Post Updated uploaded successfully');
    // Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success

      var responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      final jsonResponse = json.decode(responseData);
      final apiResponse = LandSurveyUpdateResponse.fromJson(jsonResponse);
// Now access the message1
      print(apiResponse);

      print("RUCHITA UPDATED LIST IN SERVER");
      var db = DatabaseHelper.instance;

     
     print("----HARD DELETED AT UPDATE----");
        await db.hardDeleteSurveyMediaByServerId(
            surveyLocalId: apiResponse.data.surveyId.toString());
        await DatabaseHelper.instance.hardDeleteSurveyMediaByServerId(
          surveyLocalId: apiResponse.data.surveyId.toString(),
        );
print("----AFETR DELETED AT UPDATE----");
        final remaining = await DatabaseHelper.instance
            .getSurveyMediaCount(apiResponse.data.surveyId.toString());

        if (remaining == 0) {
          print("✅ All survey media deleted successfully");
        } else {
          print("⚠ Still $remaining images left in DB");
        }
print("----INSERTION AFTER DELETED----");
        List<SurveyMediaModel> landImages = [];
        for (var media in apiResponse.data.surveyLandImages ?? []) {
          // Download the image and get the local file path
          print(media);
          final localPath = await urlToLocalPath(media.mediaUrl);

          // Create SurveyMediaModel with localPath
          landImages.add(SurveyMediaModel(
            surveyLocalId: apiResponse.data.surveyId,
            // surveyLocalId.toString(), //int.parse(detail.surveyId),
            mediaType: 'land',
            serverMediaId: media.id.toString(),
            isdeleted: 0,
            createdAt: 0,
            localPath: localPath, // ✅ store downloaded local file path
            isSynced: 1,
          ));
          print("LAND IMAGES");
          print(landImages.length);
          // print(landImages[0].localPath);
          // print(landImages[0].id);
        }

        List<SurveyMediaModel> otherImages = [];
        for (var media in apiResponse.data.surveyOtherDetailsImages ?? []) {
          // Download the image and get the local file path
          final localPath = await urlToLocalPath(media.mediaUrl);

          // Create SurveyMediaModel with localPath
          otherImages.add(SurveyMediaModel(
            surveyLocalId: apiResponse.data!.surveyId,
            mediaType: 'survey',
            serverMediaId: media.id.toString(),
            isdeleted: 0,
            createdAt: 0,
            localPath: localPath, // ✅ store downloaded local file path
            isSynced: 1,
          ));
          print("otherImages IMAGES");
          print(otherImages.length);
        }

        int insertedCount = await DatabaseHelper.instance.insertSurveyMediaList(
          surveyLocalId: apiResponse.data.surveyId, // keep as String
          landPictures: otherImages,
          surveyForms: landImages,
          consentForms: [],
        );

        if (insertedCount > 0) {
          print(
              "✅ Successfully inserted $insertedCount media files for survey ${apiResponse.data!.surveyId}");
        } else {
          print(
              "⚠️ No media files were inserted for survey ${apiResponse.data!.surveyId}");
        }

        print(
            "---------------------------------------------------------------");

        final againAdded = await DatabaseHelper.instance
            .getSurveyMediaCount(apiResponse.data.surveyId.toString());

        if (againAdded == 0) {
          print("✅ All survey media deleted successfully");
        } else {
          print("⚠ Still $againAdded images left in DB");
        }

 SurveyModel survey = SurveyModel(
            surveyId:
                apiResponse.data.surveyId.toString(), // never null
            userId: "1",
            landState: apiResponse.data.landStateName.toString(),
            landDistrict:
               apiResponse.data.landDistrictName.toString(),
            landTaluka:
               apiResponse.data.landTalukaName.toString(),
            landVillage:
                apiResponse.data.landVillageName.toString(),
            landStateID: apiResponse.data.landStateId.toString() ?? "",
            landDistrictID:apiResponse.data.landDistrictId.toString(),
            landTalukaID: apiResponse.data.landTalukaId.toString() ?? "",
            landVillageID:apiResponse.data.landVillageId.toString()?? "",
            substationDistrictID:
               apiResponse.data.subStationDistrictId.toString()?? "",
            substationTalukaID:
                apiResponse.data.subStationTalukaId.toString() ?? "",
            substationVillageID:
                apiResponse.data.subStationVillageId.toString() ?? "",
            landLatitude:apiResponse.data.landLatitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.landLatitude.toString()),
            landLongitude:apiResponse.data.landLongitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.landLongitude.toString()),
            landAreaInAcres:apiResponse.data.landAreaInAcres,
            landType:apiResponse.data.landType?? "",
            landRateCommercialEscalation:
                apiResponse.data.landRateCommercialEscalation ?? "",
            subStationName:
                apiResponse.data.subStationName ?? "",
            subStationDistrict: apiResponse.data.subStationDistrictName ??
                "",
            subStationTaluka:
              apiResponse.data.subStationTalukaName ??
                    "",
            subStationVillage:
                apiResponse.data.subStationVillageName ??
                    "",
            subStationLatitude: apiResponse.data.subStationLatitude.isEmpty
                ? 0.0
                : double.parse(apiResponse.data.subStationLatitude.toString()),
            subStationLongitude: apiResponse.data.subStationLongitude.isEmpty ? 0.0 : double.parse(apiResponse.data.subStationLongitude.toString()),
            inchargeName:apiResponse.data.subStationInchargeName ?? "",
            subStationInchargeContact:apiResponse.data.subStationInchargeContact ?? "",
            operatorName: apiResponse.data.operatorName ?? "",
            operatorContact:apiResponse.data.operatorContact ?? "",
            subStationVoltageLevel:apiResponse.data.subStationVoltageLevel ?? "",
            subStationCapacity: apiResponse.data.subStationCapacity ?? "",
            distanceSubStationToLand:apiResponse.data.distanceSubStationToLand ?? "",
            plotDistanceFromMainRoad: apiResponse.data.plotDistanceFromMainRoad ?? "",
            evacuationLevel:apiResponse.data.evacuationLevel ?? "",
            windZone:apiResponse.data.windZone ?? "",
            groundWaterRainFall:apiResponse.data.groundWaterRainfall ?? "",
            soilType:apiResponse.data.soilType ?? "",
            nearestHighway:apiResponse.data.nearestHighway ?? "",
            // surveyForms: basicFormProvider.surveyFormsmediaFile != null ? [basicFormProvider.surveyFormsmediaFile!.path!] : [],
            // landPictures: basicFormProvider.OtherLandmediaFiles.where((file) => file != null) // keep only non-null
            //     .map((file) => file!.path) // extract paths
            //     .toList(),
            landPictures: otherImages,
            surveyForms:landImages,
            consentForms: [],
            isSync:  int.parse(apiResponse.data.isSync.toString()),
            serverSynced: 1,
             needSynced:0,
            isSurveyapproved: 0,
            consentAvailable: 0,
            selectedLanguage: apiResponse.data.selectedLanguage,
            surveyDate:DateTime.parse(apiResponse.data.createdAt).millisecondsSinceEpoch,

            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
            surveyStatus:apiResponse.data.approvalStatus.approvalStatusName,);


              print(
            "---------------------------------------------------------------");

            print("------------${id.toString()}----------------");
 final updatedRows = await DatabaseHelper.instance
              .updateSurveyBySurveyId(survey,survey.surveyId!);
          print("Survey : ${survey.surveyId}");
              print("Survey : ${survey.surveyStatus}");
          print("Survey : ${survey.isSurveyapproved}");
          if (updatedRows > 0) {
            print("✅ Survey updated successfully");
          } else {
            print("⚠️ No survey found to update");
          }
    
    } else {
      var responseData = await response.stream.bytesToString();
      print('Response: $responseData');
      print('Error: ${response.statusCode}');
      // Failure
      print('Error: ${response.statusCode}');
     
    }
  }

  Future<String> urlToLocalPath(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    final dir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageUrl); // keeps original name
    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(response.bodyBytes);
    return file.path; // ✅ THIS is the local path
  }
}
