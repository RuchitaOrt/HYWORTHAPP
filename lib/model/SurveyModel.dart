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
  final int? serverSynced;
  // final List<String>? landPictures;
  // final List<String>? surveyForms;
  // final List<String>? consentForms;

  final List<SurveyMediaModel> landPictures;
  final List<SurveyMediaModel> surveyForms;
  final List<SurveyMediaModel> consentForms;

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
    this.serverSynced,
     required this.landPictures,
    required this.surveyForms,
    required this.consentForms,
    // this.landPictures,
    // this.surveyForms,
    this.isSync,
    this.selectedLanguage,
    // this.consentForms,
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
        "serverSynced":serverSynced,
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
        // "id": id,
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
        "serverSynced":serverSynced,
        'landPictures': jsonEncode(
  landPictures.map((e) => e.localPath).toList(),
),

'surveyForms': jsonEncode(
  surveyForms.map((e) => e.localPath).toList(),
),

'consentForms': jsonEncode(
  consentForms.map((e) => e.localPath).toList(),
),

        // "landPictures": jsonEncode(landPictures ?? []),
        // "surveyForms": jsonEncode(surveyForms ?? []),
        "selectedLanguage": selectedLanguage,
        // "consentForms": jsonEncode(
        //   consentForms ?? [],
        // ),
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
      serverSynced:json["serverSynced"],
      isSurveyapproved: json["isSurveyapproved"],
      // landPictures: List<SurveyMediaModel>.from(jsonDecode(json["landPictures"] ?? '[]')),
      // surveyForms: List<SurveyMediaModel>.from(jsonDecode(json["surveyForms"] ?? '[]')),
      // consentForms: List<SurveyMediaModel>.from(jsonDecode(json["consentForms"] ?? '[]')),
      landPictures: (json['landPictures'] != null)
    ? (jsonDecode(json['landPictures']) as List)
        .map((path) => SurveyMediaModel(
              surveyLocalId: json['id'],
              mediaType: MediaTypeValue.landPicture,
              localPath: path,
              isSynced: 1,
            ))
        .toList()
    : [],

surveyForms: (json['surveyForms'] != null)
    ? (jsonDecode(json['surveyForms']) as List)
        .map((path) => SurveyMediaModel(
              surveyLocalId: json['id'],
              mediaType: MediaTypeValue.surveyForm,
              localPath: path,
              isSynced: 1,
            ))
        .toList()
    : [],

consentForms: (json['consentForms'] != null)
    ? (jsonDecode(json['consentForms']) as List)
        .map((path) => SurveyMediaModel(
              surveyLocalId: json['id'],
              mediaType: MediaTypeValue.consentForm,
              localPath: path,
              isSynced: 1,
            ))
        .toList()
    : [],

      selectedLanguage: json['selectedLanguage'],
      
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
// class SurveyDetailVM {
//   final SurveyModel survey;
//   final List<SurveyMediaModel> landPictures;
//   final List<SurveyMediaModel> surveyForms;
//   final List<SurveyMediaModel> consentForms;

//   SurveyDetailVM({
//     required this.survey,
//     required this.landPictures,
//     required this.surveyForms,
//     required this.consentForms,
//   });
// }
class SurveyMediaModel {
  final int? id;
  final int surveyLocalId;
  final String mediaType;
  final String localPath;
  final String? serverId;
  final int isSynced;

  SurveyMediaModel({
    this.id,
    required this.surveyLocalId,
    required this.mediaType,
    required this.localPath,
    this.serverId,
    required this.isSynced, 
  });

  factory SurveyMediaModel.fromMap(Map<String, dynamic> map) {
    return SurveyMediaModel(
      id: map['id'],
      surveyLocalId: map['survey_local_id'],
      mediaType: map['media_type'],
      localPath: map['local_path'],
      serverId: map['server_id'],
      isSynced: map['is_synced'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'survey_local_id': surveyLocalId,
      'media_type': mediaType,
      'local_path': localPath,
      'server_id': serverId,
      'is_synced': isSynced,
    };
  }
  
}

class MediaTypeValue {
  static const landPicture = 'LAND_PICTURE';
  static const surveyForm = 'SURVEY_FORM';
  static const consentForm = 'CONSENT_FORM';
}
