class LandSurveyCreatedModel {
  final bool success;
  final String message;
  final LandSurveyData data;

  LandSurveyCreatedModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LandSurveyCreatedModel.fromJson(Map<String, dynamic> json) {
    return LandSurveyCreatedModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: LandSurveyData.fromJson(json['data'] ?? {}),
    );
  }
}
class LandSurveyData {
  final int id;
  final String surveyId;
  final String landLocation;

  final int landStateId;
  final String landStateName;
  final int landDistrictId;
  final String landDistrictName;
  final int landTalukaId;
  final String landTalukaName;
  final int landVillageId;
  final String landVillageName;

  final String landLatitude;
  final String landLongitude;
  final String landAreaInAcres;
  final String landType;
  final String landRateCommercialEscalation;

  final String subStationName;
  final int subStationDistrictId;
  final String subStationDistrictName;
  final int subStationTalukaId;
  final String subStationTalukaName;
  final int subStationVillageId;
  final String subStationVillageName;

  final String subStationLatitude;
  final String subStationLongitude;
  final String subStationInchargeContact;
  final String subStationInchargeName;
  final String operatorName;
  final String operatorContact;

  final String subStationVoltageLevel;
  final String subStationCapacity;
  final String distanceSubStationToLand;
  final String plotDistanceFromMainRoad;
  final String evacuationLevel;
  final String soilType;
  final String windZone;
  final String groundWaterRainfall;
  final String nearestHighway;

  final int consentAvailable;
  final int isSync;
  final int isSurveyApproved;
  final String selectedLanguage;
  final int surveyStatus;

  final DateTime createdAt;
  final DateTime updatedAt;

  final List<SurveyMedia> surveyLandImages;
  final List<SurveyMedia> surveyOtherDetailsImages;

  final ApprovalStatus approvalStatus;
  final Creator creator;

  LandSurveyData({
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
    required this.surveyLandImages,
    required this.surveyOtherDetailsImages,
    required this.approvalStatus,
    required this.creator,
  });

  factory LandSurveyData.fromJson(Map<String, dynamic> json) {
    return LandSurveyData(
      id: json['id'],
      surveyId: json['survey_id'],
      landLocation: json['land_location'] ?? '',
      landStateId: json['land_state_id'],
      landStateName: json['land_state_name'] ?? '',
      landDistrictId: json['land_district_id'],
      landDistrictName: json['land_district_name'] ?? '',
      landTalukaId: json['land_taluka_id'],
      landTalukaName: json['land_taluka_name'] ?? '',
      landVillageId: json['land_village_id'],
      landVillageName: json['land_village_name'] ?? '',
      landLatitude: json['land_latitude'] ?? '',
      landLongitude: json['land_longitude'] ?? '',
      landAreaInAcres: json['land_area_in_acres'] ?? '',
      landType: json['land_type'] ?? '',
      landRateCommercialEscalation:
          json['land_rate_commercial_escalation'] ?? '',
      subStationName: json['sub_station_name'] ?? '',
      subStationDistrictId: json['sub_station_district_id'],
      subStationDistrictName: json['sub_station_district_name'] ?? '',
      subStationTalukaId: json['sub_station_taluka_id'],
      subStationTalukaName: json['sub_station_taluka_name'] ?? '',
      subStationVillageId: json['sub_station_village_id'],
      subStationVillageName: json['sub_station_village_name'] ?? '',
      subStationLatitude: json['sub_station_latitude'] ?? '',
      subStationLongitude: json['sub_station_longitude'] ?? '',
      subStationInchargeContact:
          json['sub_station_incharge_contact'] ?? '',
      subStationInchargeName: json['sub_station_incharge_name'] ?? '',
      operatorName: json['operator_name'] ?? '',
      operatorContact: json['operator_contact'] ?? '',
      subStationVoltageLevel: json['sub_station_voltage_level'] ?? '',
      subStationCapacity: json['sub_station_capacity'] ?? '',
      distanceSubStationToLand:
          json['distance_sub_station_to_land'] ?? '',
      plotDistanceFromMainRoad:
          json['plot_distance_from_main_road'] ?? '',
      evacuationLevel: json['evacuation_level'] ?? '',
      soilType: json['soil_type'] ?? '',
      windZone: json['wind_zone'] ?? '',
      groundWaterRainfall:
          json['ground_water_rainfall'] ?? '',
      nearestHighway: json['nearest_highway'] ?? '',
      consentAvailable: json['consent_available'] ?? 0,
      isSync: json['is_sync'] ?? 0,
      isSurveyApproved: json['is_survey_approved'] ?? 0,
      selectedLanguage: json['selected_language'] ?? 'en',
      surveyStatus: json['survey_status'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      surveyLandImages: (json['survey_land_images'] as List)
          .map((e) => SurveyMedia.fromJson(e))
          .toList(),
      surveyOtherDetailsImages:
          (json['survey_other_details_images'] as List)
              .map((e) => SurveyMedia.fromJson(e))
              .toList(),
      approvalStatus:
          ApprovalStatus.fromJson(json['approval_status']),
      creator: Creator.fromJson(json['creator']),
    );
  }
}
class SurveyMedia {
  final int id;
  final int status;
  final String createdAt;
  final String mediaUrl;

  SurveyMedia({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.mediaUrl,
  });

  factory SurveyMedia.fromJson(Map<String, dynamic> json) {
    return SurveyMedia(
      id: json['id'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      mediaUrl: json['media_url'] ?? '',
    );
  }
}
class ApprovalStatus {
  final int id;
  final String approvalStatusName;

  ApprovalStatus({
    required this.id,
    required this.approvalStatusName,
  });

  factory ApprovalStatus.fromJson(Map<String, dynamic> json) {
    return ApprovalStatus(
      id: json['id'] ?? 0,
      approvalStatusName: json['approval_status_name'] ?? '',
    );
  }
}
class Creator {
  final int id;
  final String name;
  final String email;

  Creator({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
