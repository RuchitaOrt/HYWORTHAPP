import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/model/DistrictModel.dart';

class BasicFormProvider extends ChangeNotifier {
  TextEditingController solarCapacityController = TextEditingController();
  TextEditingController gridConnectivityController = TextEditingController();
  TextEditingController landStateController = TextEditingController();
  // TextEditingController landDistrictController = TextEditingController();
  Map<String, String>? selectedLandDistrict={
  'id': '',
  'name': 'Select District',
};
  Map<String, String>? selectedLandTaluka={
  'id': '',
  'name': 'Select Taluka',
};
  Map<String, String>? selectedLandVillage={
  'id': '',
  'name': 'Select Village',
};
  Map<String, String>? selectedsubstationDistrict={
  'id': '',
  'name': 'Select Substation District',
};
  Map<String, String>? selectedsubstationTaluka={
  'id': '',
  'name': 'Select Substation Taluka',
};
  Map<String, String>? selectedsubstationVillage={
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

  Future<List<District>> fetchDistricts() async {
    final districtMaps = await DatabaseHelper.instance.getAllDistricts();
    return districtMaps.map((e) => District.fromMap(e)).toList();
  }

  Future<List<District>> fetchTaluka() async {
    final talukaMaps = await DatabaseHelper.instance.getAllTalukas();
    return talukaMaps.map((e) => District.fromMap(e)).toList();
  }

  Future<List<District>> fetchVillage() async {
    final villageMaps = await DatabaseHelper.instance.getAllVillages();
    return villageMaps.map((e) => District.fromMap(e)).toList();
  }
  String? _rentLeaseOption; // Rent or Lease

  // Getter
  String? get rentLeaseOption => _rentLeaseOption;

  // Setter
  void setRentLeaseOption(String option) {
    _rentLeaseOption = option;
    notifyListeners(); // notify UI
  }



}
