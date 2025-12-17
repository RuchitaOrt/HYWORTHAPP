import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Utils/APIManager.dart';
import 'package:hyworth_land_survey/Utils/SPManager.dart';
import 'package:hyworth_land_survey/main.dart';

import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
import 'package:hyworth_land_survey/model/LandStateModel.dart';
import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
import 'package:hyworth_land_survey/model/LandVillagesModel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';

import 'package:mime/mime.dart';

class BasicFormProvider extends ChangeNotifier {
  TextEditingController solarCapacityController = TextEditingController();
  TextEditingController gridConnectivityController = TextEditingController();
  // TextEditingController landStateController = TextEditingController();
  // TextEditingController landDistrictController = TextEditingController();
  Map<String, String>? selectedLandState = {
    'id': '',
    'name': 'Select State',
  };
  Map<String, String>? selectedLandDistrict = {
    'id': '',
    'district_name': 'Select District',
  };
  Map<String, String>? selectedLandTaluka = {
    'id': '',
    'taluka_name': 'Select Taluka',
  };
  Map<String, String>? selectedLandVillage = {
    'id': '',
    'village_name': 'Select Village',
  };
  Map<String, String>? selectedsubstationDistrict = {
    'id': '',
    'district_name': 'Select Substation District',
  };
  Map<String, String>? selectedsubstationTaluka = {
    'id': '',
    'taluka_name': 'Select Substation Taluka',
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

  final List<File?> OtherLandmediaFiles = List.generate(7, (index) => null); // 8 fields

  bool get isMediaValid {
    return OtherLandmediaFiles.every((file) => file != null);
  }

  void setMediaFile(int index, File file) {
    OtherLandmediaFiles[index] = file;
    notifyListeners();
  }

  void removeMediaFile(int index) {
    OtherLandmediaFiles[index] = null;
    notifyListeners();
  }

  File? surveyFormsmediaFile; // single file instead of list

  void setImage(File file) {
    surveyFormsmediaFile = file;
    notifyListeners();
  }

  void removeImage() {
    surveyFormsmediaFile = null;
    notifyListeners();
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

  Future<List<DistrictData>> fetchDistrict() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query("district");

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

  Future<List<TalukaData>> fetchTaluka() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query("taluka");

    return result
        .map((e) => TalukaData(
            id: e['id'] as int,
            stateCode: e['state_code'] as String,
            stateName: e['state_name'] as String,
            districtName: e['district_name'] as String,
            districtCode: e['district_code'] as String,
            talukaCode: e['taluka_code'] as String,
            talukaName: e['taluka_name'] as String
            ))
        .toList();
  }
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
Future<List<Map<String, dynamic>>> searchVillage(String filter) async {
  final db = await DatabaseHelper.instance.database;

  if (filter.isEmpty) {
    // Return a small set to avoid heavy UI load
    return await db.rawQuery(
      "SELECT id, village_name FROM village ORDER BY village_name LIMIT 100"
    );
  }

  // First search by prefix (fast using index)
  var result = await db.rawQuery(
    """
    SELECT id, village_name FROM village
    WHERE village_name LIKE ?
    ORDER BY village_name
    LIMIT 100
    """,
    ['$filter%']
  );

  // If not enough results, fallback to contains search (slow)
  if (result.length < 20) {
    result = await db.rawQuery(
      """
      SELECT id, village_name FROM village
      WHERE village_name LIKE ?
      ORDER BY village_name
      LIMIT 100
      """,
      ['%$filter%']
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
    _rentLeaseOption = option;
    notifyListeners(); // notify UI
  }



  Future<void> submitLandSurvey( SurveyModel surveyModel) async {
  
  var uri = Uri.parse(APIManager.createLAndSurvey);
  
  // Creating a multipart request
  var request = http.MultipartRequest('POST', uri);
  print("APIManager.createLAndSurvey");
print(APIManager.createLAndSurvey);
  // Add the post text as form data
  request.fields['survey_id'] = surveyModel.surveyId.toString();
request.fields['land_location'] = surveyModel.landLocation ?? "";

request.fields['land_state_id'] = surveyModel.landStateID.toString();
request.fields['land_state_name'] = surveyModel.landState?? "";

request.fields['land_district_id'] = surveyModel.landDistrictID?? "";
request.fields['land_district_name'] =surveyModel.landDistrict?? "";

request.fields['land_taluka_id'] = surveyModel.landTalukaID?? "";
request.fields['land_taluka_name'] =surveyModel.landTaluka?? "";

request.fields['land_village_id'] = surveyModel.landVillageID?? "";
request.fields['land_village_name'] = surveyModel.landVillage?? "";

request.fields['land_latitude'] = surveyModel.landLatitude.toString()?? "";
request.fields['land_longitude'] = surveyModel.landLongitude.toString()?? "";

request.fields['land_area_in_acres'] =surveyModel.landAreaInAcres?? "";
request.fields['land_type'] = "2";//surveyModel.landType?? "";
request.fields['land_rate_commercial_escalation'] = "2";// surveyModel.landRateCommercialEscalation?? "";

request.fields['sub_station_name'] = surveyModel.subStationName?? "";

request.fields['sub_station_district_id'] = surveyModel.substationDistrictID?? "";
request.fields['sub_station_district_name'] = surveyModel.subStationDistrict?? "";

request.fields['sub_station_taluka_id'] = surveyModel.substationTalukaID ?? "";
request.fields['sub_station_taluka_name'] =   surveyModel.subStationTaluka?? "";

request.fields['sub_station_village_id'] =surveyModel.substationVillageID?? "";
request.fields['sub_station_village_name'] = surveyModel.subStationVillage?? "";

request.fields['sub_station_latitude'] = surveyModel.subStationLatitude.toString() ?? "";
request.fields['sub_station_longitude'] =surveyModel.subStationLongitude.toString() ?? "";

request.fields['sub_station_incharge_contact'] = surveyModel.subStationInchargeContact?? "";
request.fields['sub_station_incharge_name'] =surveyModel.inchargeName?? "";

request.fields['operator_name'] =surveyModel.operatorName?? "";
request.fields['operator_contact'] = surveyModel.operatorContact?? "";

request.fields['sub_station_voltage_level'] =surveyModel.subStationVoltageLevel?? "";
request.fields['sub_station_capacity'] = surveyModel.subStationCapacity?? "";

request.fields['distance_sub_station_to_land'] = surveyModel.distanceSubStationToLand?? "";
request.fields['plot_distance_from_main_road'] = surveyModel.plotDistanceFromMainRoad?? "";

request.fields['evacuation_level'] = surveyModel.evacuationLevel?? "";
request.fields['soil_type'] = surveyModel.soilType?? "";
request.fields['wind_zone'] = surveyModel.windZone?? "";
request.fields['ground_water_rainfall'] = surveyModel.groundWaterRainFall?? "";

request.fields['nearest_highway'] =surveyModel.nearestHighway?? "";

request.fields['consent_available'] =surveyModel.consentAvailable.toString() ?? "";
request.fields['is_sync'] = surveyModel.isSync.toString() ?? "";
request.fields['is_survey_approved'] = surveyModel.isSurveyapproved.toString()?? "";

request.fields['selected_language'] =surveyModel.selectedLanguage?? "";
request.fields['survey_status'] = "0";//surveyModel.surveyStatus?? "";

   print(request.fields);
String? token = await SPManager().getAuthToken();
  // Add the files to the request
  for (var file in surveyModel.surveyForms!) {
    var mimeType = lookupMimeType(file); // Get mime type based on file extension
    var multipartFile = await http.MultipartFile.fromPath(
      'survey_images', 
      file, 
      contentType: mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'octet-stream')
    );
    request.files.add(multipartFile);
  }
 for (var file in surveyModel.landPictures!) {
    var mimeType = lookupMimeType(file!); // Get mime type based on file extension
    var multipartFile = await http.MultipartFile.fromPath(
      'other_images', 
      file, 
      contentType: mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'octet-stream')
    );
    request.files.add(multipartFile);
  }
  print(request.files);
  
   request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
  request.headers['Authorization'] = 'Bearer ${token}';
  request.headers['Cookie'] = "connect.sid=s%3A2tdDJk7GtxkDgwdGLz5i-8Q3zrIf8Jab.Km0GWJSzt2vY96oF19B8CTleU%2F7HZstVOdCsfSgcMLM";

  // Sending the request
  var response = await request.send();
  print('Post uploaded successfully');
  // Handle the response
  if (response.statusCode == 200) {
    // Success
  
    var responseData = await response.stream.bytesToString();
    print('Response: $responseData');
    final jsonResponse = json.decode(responseData);

// Now access the message
   final message = jsonResponse['message']; // or whatever key your API uses

 
  } else {
    var responseData = await response.stream.bytesToString();
    print('Response: $responseData');
     print('Error: ${response.statusCode}');
    // Failure
    print('Error: ${response.statusCode}');
  
  }

   final result =
              await Navigator.of(routeGlobalKey.currentContext!).push(
            createSlideFromBottomRoute(
              Maintabscreen(),
            ),
          );

}

}
