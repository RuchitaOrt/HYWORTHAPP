class SurveyResponse {
  bool success;
  List<SurveyData> data;
  Pagination pagination;

  SurveyResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory SurveyResponse.fromJson(Map<String, dynamic> json) {
    return SurveyResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => SurveyData.fromJson(e))
              .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map((e) => e.toJson()).toList(),
        'pagination': pagination.toJson(),
      };
}

class SurveyData {
  int id;
  String surveyId;
  String landLocation;
  int landStateId;
  String landStateName;
  int landDistrictId;
  String landDistrictName;
  int landTalukaId;
  String landTalukaName;
  int landVillageId;
  String landVillageName;
  String landLatitude;
  String landLongitude;
  String landAreaInAcres;
  int landType;
  String landRateCommercialEscalation;
  String subStationName;
  int subStationDistrictId;
  String subStationDistrictName;
  int subStationTalukaId;
  String subStationTalukaName;
  int subStationVillageId;
  String subStationVillageName;
  String subStationLatitude;
  String subStationLongitude;
  String subStationInchargeContact;
  String subStationInchargeName;
  String operatorName;
  String operatorContact;
  String subStationVoltageLevel;
  String subStationCapacity;
  String distanceSubStationToLand;
  String plotDistanceFromMainRoad;
  String evacuationLevel;
  String soilType;
  String windZone;
  String groundWaterRainfall;
  String nearestHighway;
  int consentAvailable;
  int isSync;
  int isSurveyApproved;
  String selectedLanguage;
  int surveyStatus;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  List<Media> consents;
  List<Media> surveyLandImages;
  List<Media> surveyOtherDetailsImages;
  ApprovalStatus approvalStatus;

  SurveyData({
    required this.id,
    required this.surveyId,
    required this.landLocation,
    required this.landStateId,
    required this.landStateName,
    required this.landDistrictId,
    required this.landDistrictName,
    required this.landTalukaId,
    required this.landTalukaName,
    required this.landVillageId,
    required this.landVillageName,
    required this.landLatitude,
    required this.landLongitude,
    required this.landAreaInAcres,
    required this.landType,
    required this.landRateCommercialEscalation,
    required this.subStationName,
    required this.subStationDistrictId,
    required this.subStationDistrictName,
    required this.subStationTalukaId,
    required this.subStationTalukaName,
    required this.subStationVillageId,
    required this.subStationVillageName,
    required this.subStationLatitude,
    required this.subStationLongitude,
    required this.subStationInchargeContact,
    required this.subStationInchargeName,
    required this.operatorName,
    required this.operatorContact,
    required this.subStationVoltageLevel,
    required this.subStationCapacity,
    required this.distanceSubStationToLand,
    required this.plotDistanceFromMainRoad,
    required this.evacuationLevel,
    required this.soilType,
    required this.windZone,
    required this.groundWaterRainfall,
    required this.nearestHighway,
    required this.consentAvailable,
    required this.isSync,
    required this.isSurveyApproved,
    required this.selectedLanguage,
    required this.surveyStatus,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    this.deletedBy,
    required this.consents,
    required this.surveyLandImages,
    required this.surveyOtherDetailsImages,
    required this.approvalStatus,
  });

  factory SurveyData.fromJson(Map<String, dynamic> json) => SurveyData(
        id: json['id'] ?? 0,
        surveyId: json['survey_id'] ?? '',
        landLocation: json['land_location'] ?? '',
        landStateId: json['land_state_id'] ?? 0,
        landStateName: json['land_state_name'] ?? '',
        landDistrictId: json['land_district_id'] ?? 0,
        landDistrictName: json['land_district_name'] ?? '',
        landTalukaId: json['land_taluka_id'] ?? 0,
        landTalukaName: json['land_taluka_name'] ?? '',
        landVillageId: json['land_village_id'] ?? 0,
        landVillageName: json['land_village_name'] ?? '',
        landLatitude: json['land_latitude'] ?? '',
        landLongitude: json['land_longitude'] ?? '',
        landAreaInAcres: json['land_area_in_acres'] ?? '',
        landType: json['land_type'] ?? 0,
        landRateCommercialEscalation: json['land_rate_commercial_escalation'] ?? '',
        subStationName: json['sub_station_name'] ?? '',
        subStationDistrictId: json['sub_station_district_id'] ?? 0,
        subStationDistrictName: json['sub_station_district_name'] ?? '',
        subStationTalukaId: json['sub_station_taluka_id'] ?? 0,
        subStationTalukaName: json['sub_station_taluka_name'] ?? '',
        subStationVillageId: json['sub_station_village_id'] ?? 0,
        subStationVillageName: json['sub_station_village_name'] ?? '',
        subStationLatitude: json['sub_station_latitude'] ?? '',
        subStationLongitude: json['sub_station_longitude'] ?? '',
        subStationInchargeContact: json['sub_station_incharge_contact'] ?? '',
        subStationInchargeName: json['sub_station_incharge_name'] ?? '',
        operatorName: json['operator_name'] ?? '',
        operatorContact: json['operator_contact'] ?? '',
        subStationVoltageLevel: json['sub_station_voltage_level'] ?? '',
        subStationCapacity: json['sub_station_capacity'] ?? '',
        distanceSubStationToLand: json['distance_sub_station_to_land'] ?? '',
        plotDistanceFromMainRoad: json['plot_distance_from_main_road'] ?? '',
        evacuationLevel: json['evacuation_level'] ?? '',
        soilType: json['soil_type'] ?? '',
        windZone: json['wind_zone'] ?? '',
        groundWaterRainfall: json['ground_water_rainfall'] ?? '',
        nearestHighway: json['nearest_highway'] ?? '',
        consentAvailable: json['consent_available'] ?? 0,
        isSync: json['is_sync'] ?? 0,
        isSurveyApproved: json['is_survey_approved'] ?? 0,
        selectedLanguage: json['selected_language'] ?? '',
        surveyStatus: json['survey_status'] ?? 0,
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        deletedAt: json['deleted_at'],
        createdBy: json['created_by'] ?? 0,
        updatedBy: json['updated_by'] ?? 0,
        deletedBy: json['deleted_by'],
        consents: (json['consents'] as List<dynamic>?)
                ?.map((e) => Media.fromJson(e))
                .toList() ??
            [],
        surveyLandImages: (json['survey_land_images'] as List<dynamic>?)
                ?.map((e) => Media.fromJson(e))
                .toList() ??
            [],
        surveyOtherDetailsImages:
            (json['survey_other_details_images'] as List<dynamic>?)
                    ?.map((e) => Media.fromJson(e))
                    .toList() ??
                [],
        approvalStatus:
            ApprovalStatus.fromJson(json['approval_status'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'survey_id': surveyId,
        'land_location': landLocation,
        'land_state_id': landStateId,
        'land_state_name': landStateName,
        'land_district_id': landDistrictId,
        'land_district_name': landDistrictName,
        'land_taluka_id': landTalukaId,
        'land_taluka_name': landTalukaName,
        'land_village_id': landVillageId,
        'land_village_name': landVillageName,
        'land_latitude': landLatitude,
        'land_longitude': landLongitude,
        'land_area_in_acres': landAreaInAcres,
        'land_type': landType,
        'land_rate_commercial_escalation': landRateCommercialEscalation,
        'sub_station_name': subStationName,
        'sub_station_district_id': subStationDistrictId,
        'sub_station_district_name': subStationDistrictName,
        'sub_station_taluka_id': subStationTalukaId,
        'sub_station_taluka_name': subStationTalukaName,
        'sub_station_village_id': subStationVillageId,
        'sub_station_village_name': subStationVillageName,
        'sub_station_latitude': subStationLatitude,
        'sub_station_longitude': subStationLongitude,
        'sub_station_incharge_contact': subStationInchargeContact,
        'sub_station_incharge_name': subStationInchargeName,
        'operator_name': operatorName,
        'operator_contact': operatorContact,
        'sub_station_voltage_level': subStationVoltageLevel,
        'sub_station_capacity': subStationCapacity,
        'distance_sub_station_to_land': distanceSubStationToLand,
        'plot_distance_from_main_road': plotDistanceFromMainRoad,
        'evacuation_level': evacuationLevel,
        'soil_type': soilType,
        'wind_zone': windZone,
        'ground_water_rainfall': groundWaterRainfall,
        'nearest_highway': nearestHighway,
        'consent_available': consentAvailable,
        'is_sync': isSync,
        'is_survey_approved': isSurveyApproved,
        'selected_language': selectedLanguage,
        'survey_status': surveyStatus,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'deleted_by': deletedBy,
        'consents': consents.map((e) => e.toJson()).toList(),
        'survey_land_images': surveyLandImages.map((e) => e.toJson()).toList(),
        'survey_other_details_images':
            surveyOtherDetailsImages.map((e) => e.toJson()).toList(),
        'approval_status': approvalStatus.toJson(),
      };
}

class Media {
  int id;
  int status;
  String createdAt;
  String mediaUrl;

  Media({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.mediaUrl,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json['id'] ?? 0,
        status: json['status'] ?? 0,
        createdAt: json['created_at'] ?? '',
        mediaUrl: json['media_url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'created_at': createdAt,
        'media_url': mediaUrl,
      };
}

class ApprovalStatus {
  int id;
  String approvalStatusName;

  ApprovalStatus({
    required this.id,
    required this.approvalStatusName,
  });

  factory ApprovalStatus.fromJson(Map<String, dynamic> json) =>
      ApprovalStatus(
        id: json['id'] ?? 0,
        approvalStatusName: json['approval_status_name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'approval_status_name': approvalStatusName,
      };
}

class Pagination {
  int total;
  int page;
  int limit;
  int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json['total'] ?? 0,
        page: json['page'] ?? 0,
        limit: json['limit'] ?? 0,
        totalPages: json['totalPages'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
      };
}


// import 'dart:convert';

// SurveyListResponse surveyListResponseFromJson(String str) =>
//     SurveyListResponse.fromJson(json.decode(str));

// class SurveyListResponse {
//   bool? success;
//   List<SurveyData>? data;

//   SurveyListResponse({this.success, this.data});

//   factory SurveyListResponse.fromJson(Map<String, dynamic> json) =>
//       SurveyListResponse(
//         success: json["success"],
//         data: json["data"] == null
//             ? []
//             : List<SurveyData>.from(
//                 json["data"].map((x) => SurveyData.fromJson(x))),
//       );
// }

// class SurveyData {
//   int? id;
//   String? surveyId;
//   String? landLocation;
//   int? landStateId;
//   String? landStateName;
//   int? landDistrictId;
//   String? landDistrictName;
//   int? landTalukaId;
//   String? landTalukaName;
//   int? landVillageId;
//   String? landVillageName;
//   String? landLatitude;
//   String? landLongitude;
//   String? landAreaInAcres;
//   int? landType;
//   String? landRateCommercialEscalation;
//   String? subStationName;
//   int? subStationDistrictId;
//   String? subStationDistrictName;
//   int? subStationTalukaId;
//   String? subStationTalukaName;
//   int? subStationVillageId;
//   String? subStationVillageName;
//   String? subStationLatitude;
//   String? subStationLongitude;
//   String? subStationInchargeContact;
//   String? subStationInchargeName;
//   String? operatorName;
//   String? operatorContact;
//   String? subStationVoltageLevel;
//   String? subStationCapacity;
//   String? distanceSubStationToLand;
//   String? plotDistanceFromMainRoad;
//   String? evacuationLevel;
//   String? soilType;
//   String? windZone;
//   String? groundWaterRainfall;
//   String? nearestHighway;
//   int? consentAvailable;
//   int? isSync;
//   int? isSurveyApproved;
//   String? selectedLanguage;
//   int? surveyStatus;
//   String? createdAt;
//   String? updatedAt;
//   dynamic deletedAt;
//   int? createdBy;
//   int? updatedBy;
//   dynamic deletedBy;
//   List<ImageModel>? consents;
//   List<ImageModel>? surveyLandImages;
//   List<ImageModel>? surveyOtherDetailsImages;
//   ApprovalStatus? approvalStatus;

//   SurveyData({
//     this.id,
//     this.surveyId,
//     this.landLocation,
//     this.landStateId,
//     this.landStateName,
//     this.landDistrictId,
//     this.landDistrictName,
//     this.landTalukaId,
//     this.landTalukaName,
//     this.landVillageId,
//     this.landVillageName,
//     this.landLatitude,
//     this.landLongitude,
//     this.landAreaInAcres,
//     this.landType,
//     this.landRateCommercialEscalation,
//     this.subStationName,
//     this.subStationDistrictId,
//     this.subStationDistrictName,
//     this.subStationTalukaId,
//     this.subStationTalukaName,
//     this.subStationVillageId,
//     this.subStationVillageName,
//     this.subStationLatitude,
//     this.subStationLongitude,
//     this.subStationInchargeContact,
//     this.subStationInchargeName,
//     this.operatorName,
//     this.operatorContact,
//     this.subStationVoltageLevel,
//     this.subStationCapacity,
//     this.distanceSubStationToLand,
//     this.plotDistanceFromMainRoad,
//     this.evacuationLevel,
//     this.soilType,
//     this.windZone,
//     this.groundWaterRainfall,
//     this.nearestHighway,
//     this.consentAvailable,
//     this.isSync,
//     this.isSurveyApproved,
//     this.selectedLanguage,
//     this.surveyStatus,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.createdBy,
//     this.updatedBy,
//     this.deletedBy,
//     this.consents,
//     this.surveyLandImages,
//     this.surveyOtherDetailsImages,
//     this.approvalStatus,
//   });

//   factory SurveyData.fromJson(Map<String, dynamic> json) => SurveyData(
//         id: json["id"],
//         surveyId: json["survey_id"],
//         landLocation: json["land_location"],
//         landStateId: json["land_state_id"],
//         landStateName: json["land_state_name"],
//         landDistrictId: json["land_district_id"],
//         landDistrictName: json["land_district_name"],
//         landTalukaId: json["land_taluka_id"],
//         landTalukaName: json["land_taluka_name"],
//         landVillageId: json["land_village_id"],
//         landVillageName: json["land_village_name"],
//         landLatitude: json["land_latitude"],
//         landLongitude: json["land_longitude"],
//         landAreaInAcres: json["land_area_in_acres"],
//         landType: json["land_type"],
//         landRateCommercialEscalation:
//             json["land_rate_commercial_escalation"],
//         subStationName: json["sub_station_name"],
//         subStationDistrictId: json["sub_station_district_id"],
//         subStationDistrictName: json["sub_station_district_name"],
//         subStationTalukaId: json["sub_station_taluka_id"],
//         subStationTalukaName: json["sub_station_taluka_name"],
//         subStationVillageId: json["sub_station_village_id"],
//         subStationVillageName: json["sub_station_village_name"],
//         subStationLatitude: json["sub_station_latitude"],
//         subStationLongitude: json["sub_station_longitude"],
//         subStationInchargeContact: json["sub_station_incharge_contact"],
//         subStationInchargeName: json["sub_station_incharge_name"],
//         operatorName: json["operator_name"],
//         operatorContact: json["operator_contact"],
//         subStationVoltageLevel: json["sub_station_voltage_level"],
//         subStationCapacity: json["sub_station_capacity"],
//         distanceSubStationToLand: json["distance_sub_station_to_land"],
//         plotDistanceFromMainRoad: json["plot_distance_from_main_road"],
//         evacuationLevel: json["evacuation_level"],
//         soilType: json["soil_type"],
//         windZone: json["wind_zone"],
//         groundWaterRainfall: json["ground_water_rainfall"],
//         nearestHighway: json["nearest_highway"],
//         consentAvailable: json["consent_available"],
//         isSync: json["is_sync"],
//         isSurveyApproved: json["is_survey_approved"],
//         selectedLanguage: json["selected_language"],
//         surveyStatus: json["survey_status"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         deletedAt: json["deleted_at"],
//         createdBy: json["created_by"],
//         updatedBy: json["updated_by"],
//         deletedBy: json["deleted_by"],
//         consents: json["consents"] == null
//             ? []
//             : List<ImageModel>.from(
//                 json["consents"].map((x) => ImageModel.fromJson(x))),
//         surveyLandImages: json["survey_land_images"] == null
//             ? []
//             : List<ImageModel>.from(
//                 json["survey_land_images"].map((x) => ImageModel.fromJson(x))),
//         surveyOtherDetailsImages: json["survey_other_details_images"] == null
//             ? []
//             : List<ImageModel>.from(json["survey_other_details_images"]
//                 .map((x) => ImageModel.fromJson(x))),
//         approvalStatus: json["approval_status"] == null
//             ? null
//             : ApprovalStatus.fromJson(json["approval_status"]),
//       );
// }

// class ImageModel {
//   int? id;
//   int? status;
//   String? createdAt;
//   String? mediaUrl;

//   ImageModel({this.id, this.status, this.createdAt, this.mediaUrl});

//   factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
//         id: json["id"],
//         status: json["status"],
//         createdAt: json["created_at"],
//         mediaUrl: json["media_url"],
//       );
// }

// class ApprovalStatus {
//   int? id;
//   String? approvalStatusName;

//   ApprovalStatus({
//     this.id,
//     this.approvalStatusName,
//   });

//   factory ApprovalStatus.fromJson(Map<String, dynamic> json) => ApprovalStatus(
//         id: json["id"],
//         approvalStatusName: json["approval_status_name"],
//       );
// }
