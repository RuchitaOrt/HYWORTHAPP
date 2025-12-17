import 'dart:convert';

class SurveyModel {
  int? id; // local auto-incremented id
  final String? surveyId;
  final String? userId;
  final String? solarParkACCapacity;
  final String? solarParkDCCapacity;
  final String? gridConnectivity;
  final String? landLocation;
  final String? landDHQ;
  final String? landState;
  final String? landDistrict;
  final String? landTaluka;
  final String? landVillage;
  final double? landLatitude;
  final double? landLongitude;
  final String? landAreaInAcres;
  final String? landType;
  final String? landRateCommercialEscalation;
  final String? subStationName;
  final String? subStationDistrict;
  final String? subStationTaluka;
  final String? subStationVillage;
  final double? subStationLatitude;
  final double? subStationLongitude;
  final String? subStationInchargeContact;
  final String? inchargeName;
  final String? operatorName;
  final String? operatorContact;
  final String? subStationVoltageLevel;
  final String? subStationCapacity;
  final String? distanceSubStationToLand;
  final String? plotDistanceFromMainRoad;
  final String? evacuationLevel;
  final String? soilType;
  final String? windZone;
  final String? groundWaterRainFall;
  final String? nearestHighway;
  final int? consentAvailable; //isapproved or not
  final int?
      isSurveyapproved; //means that is sync with admin and not in awaited confirmation
  final int? isSync;
  final List<String>? landPictures;
  final List<String>? surveyForms;
  final List<String>? consentForms;
  final String? selectedLanguage;
  final int? surveyDate;
  final int? updatedsurveyDate;
  final String?
      surveyStatus; //pending,rejected,required,not required,await confirmation,rejected
       final String? landStateID;
  final String? landDistrictID;
  final String? landTalukaID;
  final String? landVillageID;
  final String? substationDistrictID;
  final String? substationTalukaID;
  final String? substationVillageID;
  
  SurveyModel({
    this.id, // nullable for new inserts
    this.surveyId,
    this.userId,
    this.solarParkACCapacity,
    this.solarParkDCCapacity,
    this.gridConnectivity,
    this.landLocation,
    this.landDHQ,
    this.landState,
    this.landDistrict,
    this.landTaluka,
    this.landVillage,
    this.landLatitude,
    this.landLongitude,
    this.landAreaInAcres,
    this.landType,
    this.landRateCommercialEscalation,
    this.subStationName,
    this.subStationDistrict,
    this.subStationTaluka,
    this.subStationVillage,
    this.subStationLatitude,
    this.subStationLongitude,
    this.subStationInchargeContact,
    this.inchargeName,
    this.operatorName,
    this.operatorContact,
    this.subStationVoltageLevel,
    this.subStationCapacity,
    this.distanceSubStationToLand,
    this.plotDistanceFromMainRoad,
    this.evacuationLevel,
    this.soilType,
    this.windZone,
    this.groundWaterRainFall,
    this.nearestHighway,
    this.consentAvailable,
    this.isSurveyapproved,
    this.landPictures,
    this.surveyForms,
    this.isSync,
    this.selectedLanguage,
    this.consentForms,
    this.surveyDate,
    this.updatedsurveyDate,
    this.surveyStatus,
    this.landDistrictID,
    this.landTalukaID,
    this.landStateID,
    this.landVillageID,
    this.substationDistrictID,
    this.substationTalukaID,
    this.substationVillageID,
  });

  /// Convert to JSON for API
  Map<String, dynamic> toJson() => {
        'id': id,
        "surveyId": surveyId,
        "userId": userId,
        "solarParkACCapacity": solarParkACCapacity,
        "solarParkDCCapacity": solarParkDCCapacity,
        "gridConnectivity": gridConnectivity,
        "landLocation": landLocation,
        "landDHQ": landDHQ,
        "landState": landState,
        "landDistrict": landDistrict,
        "landTaluka": landTaluka,
        "landVillage": landVillage,
        "landLatitude": landLatitude,
        "landLongitude": landLongitude,
        "landAreaInAcres": landAreaInAcres,
        "landType": landType,
        "landRateCommercialEscalation": landRateCommercialEscalation,
        "subStationName": subStationName,
        "subStationDistrict": subStationDistrict,
        "subStationTaluka": subStationTaluka,
        "subStationVillage": subStationVillage,
        "subStationLatitude": subStationLatitude,
        "subStationLongitude": subStationLongitude,
        "subStationInchargeContact": subStationInchargeContact,
        "inchargeName": inchargeName,
        "operatorName": operatorName,
        "operatorContact": operatorContact,
        "subStationVoltageLevel": subStationVoltageLevel,
        "subStationCapacity": subStationCapacity,
        "distanceSubStationToLand": distanceSubStationToLand,
        "plotDistanceFromMainRoad": plotDistanceFromMainRoad,
        "evacuationLevel": evacuationLevel,
        "soilType": soilType,
        "windZone": windZone,
        "groundWaterRainFall": groundWaterRainFall,
        "nearestHighway": nearestHighway,
        "consentAvailable": consentAvailable,
        "isSurveyapproved": isSurveyapproved,
        "isSync": isSync,
        "landPictures": landPictures,
        "surveyForms": surveyForms,
        "selectedLanguage": selectedLanguage,
        "consentForms": consentForms,
        "surveyDate": surveyDate,
        "updatedsurveyDate": updatedsurveyDate,
        'surveyStatus': surveyStatus,
         "landStateID":landStateID,
        "landDistrictID": landDistrictID,
        "landTalukaID": landTalukaID,
        "landVillageID": landVillageID,
        "substationDistrictID": substationDistrictID,
        "substationTalukaID": substationTalukaID,
        "substationVillageID": substationVillageID
      };

  /// Convert to DB (store lists as JSON string)
  Map<String, dynamic> toJsonDB() => {
        "id": id,
        "surveyId": surveyId,
        "userId": userId,
        "solarParkACCapacity": solarParkACCapacity,
        "solarParkDCCapacity": solarParkDCCapacity,
        "gridConnectivity": gridConnectivity,
        "landLocation": landLocation,
        "landDHQ": landDHQ,
        "landState": landState,
        "landDistrict": landDistrict,
        "landTaluka": landTaluka,
        "landVillage": landVillage,
        "landLatitude": landLatitude,
        "landLongitude": landLongitude,
        "landAreaInAcres": landAreaInAcres,
        "landType": landType,
        "landRateCommercialEscalation": landRateCommercialEscalation,
        "subStationName": subStationName,
        "subStationDistrict": subStationDistrict,
        "subStationTaluka": subStationTaluka,
        "subStationVillage": subStationVillage,
        "subStationLatitude": subStationLatitude,
        "subStationLongitude": subStationLongitude,
        "subStationInchargeContact": subStationInchargeContact,
        "inchargeName": inchargeName,
        "operatorName": operatorName,
        "operatorContact": operatorContact,
        "subStationVoltageLevel": subStationVoltageLevel,
        "subStationCapacity": subStationCapacity,
        "distanceSubStationToLand": distanceSubStationToLand,
        "plotDistanceFromMainRoad": plotDistanceFromMainRoad,
        "evacuationLevel": evacuationLevel,
        "soilType": soilType,
        "windZone": windZone,
        "groundWaterRainFall": groundWaterRainFall,
        "nearestHighway": nearestHighway,
        "consentAvailable": consentAvailable,
        "isSurveyapproved": isSurveyapproved,
        "isSync": isSync,
        "landPictures": jsonEncode(landPictures ?? []),
        "surveyForms": jsonEncode(surveyForms ?? []),
        "selectedLanguage": selectedLanguage,
        "consentForms": jsonEncode(
          consentForms ?? [],
        ),
        "surveyDate": surveyDate,
        "updatedsurveyDate": updatedsurveyDate,
        "surveyStatus": surveyStatus,
       "landStateID":landStateID,
        "landDistrictID": landDistrictID,
        "landTalukaID": landTalukaID,
        "landVillageID": landVillageID,
        "substationDistrictID": substationDistrictID,
        "substationTalukaID": substationTalukaID,
        "substationVillageID": substationVillageID
      };

  factory SurveyModel.fromJsonDB(Map<String, dynamic> json) => SurveyModel(
      id: json['id'],
      surveyId: json["surveyId"],
      userId: json["userId"],
      solarParkACCapacity: json["solarParkACCapacity"],
      solarParkDCCapacity: json["solarParkDCCapacity"],
      gridConnectivity: json["gridConnectivity"],
      landLocation: json["landLocation"],
      landDHQ: json["landDHQ"],
      landState: json["landState"],
      landDistrict: json["landDistrict"],
      landTaluka: json["landTaluka"],
      landVillage: json["landVillage"],
      landLatitude: (json["landLatitude"] as num?)?.toDouble(),
      landLongitude: (json["landLongitude"] as num?)?.toDouble(),
      landAreaInAcres: json["landAreaInAcres"],
      landType: json["landType"],
      landRateCommercialEscalation: json["landRateCommercialEscalation"],
      subStationName: json["subStationName"],
      subStationDistrict: json["subStationDistrict"],
      subStationTaluka: json["subStationTaluka"],
      subStationVillage: json["subStationVillage"],
      subStationLatitude: (json["subStationLatitude"] as num?)?.toDouble(),
      subStationLongitude: (json["subStationLongitude"] as num?)?.toDouble(),
      subStationInchargeContact: json["subStationInchargeContact"],
      inchargeName: json["inchargeName"],
      operatorName: json["operatorName"],
      operatorContact: json["operatorContact"],
      subStationVoltageLevel: json["subStationVoltageLevel"],
      subStationCapacity: json["subStationCapacity"],
      distanceSubStationToLand: json["distanceSubStationToLand"],
      plotDistanceFromMainRoad: json["plotDistanceFromMainRoad"],
      evacuationLevel: json["evacuationLevel"],
      soilType: json["soilType"],
      windZone: json["windZone"],
      groundWaterRainFall: json["groundWaterRainFall"],
      nearestHighway: json["nearestHighway"],
      consentAvailable: json["consentAvailable"],
      isSync: json["isSync"],
      isSurveyapproved: json["isSurveyapproved"],
      landPictures: List<String>.from(jsonDecode(json["landPictures"] ?? '[]')),
      surveyForms: List<String>.from(jsonDecode(json["surveyForms"] ?? '[]')),
      selectedLanguage: json['selectedLanguage'],
      consentForms: List<String>.from(jsonDecode(json["consentForms"] ?? '[]')),
      surveyDate: json['surveyDate'],
      updatedsurveyDate: json['updatedsurveyDate'],
      surveyStatus: json["surveyStatus"] ?? "",
      landDistrictID: json["landDistrictID"],
      landTalukaID: json["landTalukaID"],
      landVillageID: json['landVillageID'],
      substationDistrictID: json["substationDistrictID"],
      substationTalukaID: json['substationTalukaID'],
      landStateID:json['landStateID'],
      substationVillageID: json['substationVillageID']);
}
class SurveyDetailVM {
  final SurveyModel survey;
  final List<SurveyMediaModel> landPictures;
  final List<SurveyMediaModel> surveyForms;
  final List<SurveyMediaModel> consentForms;

  SurveyDetailVM({
    required this.survey,
    required this.landPictures,
    required this.surveyForms,
    required this.consentForms,
  });
}
class SurveyMediaModel {
  final String localId;
  final int surveyLocalId;
  final String? serverMediaId;
  final MediaTypeValue mediaType;
  final String path;
  final bool isSynced;
  final bool isDeleted;
  final int createdAt;

  SurveyMediaModel({
    required this.localId,
    required this.surveyLocalId,
    this.serverMediaId,
    required this.mediaType,
    required this.path,
    required this.isSynced,
    required this.isDeleted,
    required this.createdAt,
  });
}
enum MediaTypeValue {
  landPicture,
  surveyForm,
  consentForm,
}
