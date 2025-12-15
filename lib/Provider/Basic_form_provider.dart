import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';

import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
import 'package:hyworth_land_survey/model/LandStateModel.dart';
import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
import 'package:hyworth_land_survey/model/LandVillagesModel.dart';

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
    'name': 'Select District',
  };
  Map<String, String>? selectedLandTaluka = {
    'id': '',
    'name': 'Select Taluka',
  };
  Map<String, String>? selectedLandVillage = {
    'id': '',
    'name': 'Select Village',
  };
  Map<String, String>? selectedsubstationDistrict = {
    'id': '',
    'name': 'Select Substation District',
  };
  Map<String, String>? selectedsubstationTaluka = {
    'id': '',
    'name': 'Select Substation Taluka',
  };
  Map<String, String>? selectedsubstationVillage = {
    'id': '',
    'name': 'Select Substation Village',
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
    return mediaFiles.every((file) => file != null);
  }

  final List<File?> mediaFiles = List.generate(7, (index) => null); // 8 fields

  bool get isMediaValid {
    return mediaFiles.every((file) => file != null);
  }

  void setMediaFile(int index, File file) {
    mediaFiles[index] = file;
    notifyListeners();
  }

  void removeMediaFile(int index) {
    mediaFiles[index] = null;
    notifyListeners();
  }

  File? mediaFile; // single file instead of list

  void setImage(File file) {
    mediaFile = file;
    notifyListeners();
  }

  void removeImage() {
    mediaFile = null;
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
}
