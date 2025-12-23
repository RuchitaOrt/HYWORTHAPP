class LandSurveyUpdateResponse {
  final bool success;
  final String? message;
  final LandSurveyUpdatedData? data;

  LandSurveyUpdateResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory LandSurveyUpdateResponse.fromJson(Map<String, dynamic> json) {
    return LandSurveyUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? LandSurveyUpdatedData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class LandSurveyUpdatedData {
  final int? id;
  final String? surveyId;
  final String? landLocation;
  final String? landStateId;
  final String? landStateName;
  final String? landDistrictId;
  final String? landDistrictName;
  final String? landTalukaId;
  final String? landTalukaName;
  final String? landVillageId;
  final String? landVillageName;
  final String? landLatitude;
  final String? landLongitude;
  final String? landAreaInAcres;
  final String? landType;
  final String? landRateCommercialEscalation;
  final String? subStationName;
  final String? subStationDistrictId;
  final String? subStationDistrictName;
  final String? subStationTalukaId;
  final String? subStationTalukaName;
  final String? subStationVillageId;
  final String? subStationVillageName;
  final String? subStationLatitude;
  final String? subStationLongitude;
  final String? subStationInchargeContact;
  final String? subStationInchargeName;
  final String? operatorName;
  final String? operatorContact;
  final String? subStationVoltageLevel;
  final String? subStationCapacity;
  final String? distanceSubStationToLand;
  final String? plotDistanceFromMainRoad;
  final String? evacuationLevel;
  final String? soilType;
  final String? windZone;
  final String? groundWaterRainfall;
  final String? nearestHighway;
  final String? consentAvailable;
  final int? isSync;
  final String? isSurveyApproved;
  final String? selectedLanguage;
  final String? surveyStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? createdBy;
  final int? updatedBy;
  final int? deletedBy;

  LandSurveyUpdatedData({
    this.id,
    this.surveyId,
    this.landLocation,
    this.landStateId,
    this.landStateName,
    this.landDistrictId,
    this.landDistrictName,
    this.landTalukaId,
    this.landTalukaName,
    this.landVillageId,
    this.landVillageName,
    this.landLatitude,
    this.landLongitude,
    this.landAreaInAcres,
    this.landType,
    this.landRateCommercialEscalation,
    this.subStationName,
    this.subStationDistrictId,
    this.subStationDistrictName,
    this.subStationTalukaId,
    this.subStationTalukaName,
    this.subStationVillageId,
    this.subStationVillageName,
    this.subStationLatitude,
    this.subStationLongitude,
    this.subStationInchargeContact,
    this.subStationInchargeName,
    this.operatorName,
    this.operatorContact,
    this.subStationVoltageLevel,
    this.subStationCapacity,
    this.distanceSubStationToLand,
    this.plotDistanceFromMainRoad,
    this.evacuationLevel,
    this.soilType,
    this.windZone,
    this.groundWaterRainfall,
    this.nearestHighway,
    this.consentAvailable,
    this.isSync,
    this.isSurveyApproved,
    this.selectedLanguage,
    this.surveyStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  factory LandSurveyUpdatedData.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return LandSurveyUpdatedData(
      id: json['id'] as int?,
      surveyId: json['survey_id'] as String?,
      landLocation: json['land_location'] as String?,
      landStateId: json['land_state_id'] as String?,
      landStateName: json['land_state_name'] as String?,
      landDistrictId: json['land_district_id'] as String?,
      landDistrictName: json['land_district_name'] as String?,
      landTalukaId: json['land_taluka_id'] as String?,
      landTalukaName: json['land_taluka_name'] as String?,
      landVillageId: json['land_village_id'] as String?,
      landVillageName: json['land_village_name'] as String?,
      landLatitude: json['land_latitude'] as String?,
      landLongitude: json['land_longitude'] as String?,
      landAreaInAcres: json['land_area_in_acres'] as String?,
      landType: json['land_type'] as String?,
      landRateCommercialEscalation: json['land_rate_commercial_escalation'] as String?,
      subStationName: json['sub_station_name'] as String?,
      subStationDistrictId: json['sub_station_district_id'] as String?,
      subStationDistrictName: json['sub_station_district_name'] as String?,
      subStationTalukaId: json['sub_station_taluka_id'] as String?,
      subStationTalukaName: json['sub_station_taluka_name'] as String?,
      subStationVillageId: json['sub_station_village_id'] as String?,
      subStationVillageName: json['sub_station_village_name'] as String?,
      subStationLatitude: json['sub_station_latitude'] as String?,
      subStationLongitude: json['sub_station_longitude'] as String?,
      subStationInchargeContact: json['sub_station_incharge_contact'] as String?,
      subStationInchargeName: json['sub_station_incharge_name'] as String?,
      operatorName: json['operator_name'] as String?,
      operatorContact: json['operator_contact'] as String?,
      subStationVoltageLevel: json['sub_station_voltage_level'] as String?,
      subStationCapacity: json['sub_station_capacity'] as String?,
      distanceSubStationToLand: json['distance_sub_station_to_land'] as String?,
      plotDistanceFromMainRoad: json['plot_distance_from_main_road'] as String?,
      evacuationLevel: json['evacuation_level'] as String?,
      soilType: json['soil_type'] as String?,
      windZone: json['wind_zone'] as String?,
      groundWaterRainfall: json['ground_water_rainfall'] as String?,
      nearestHighway: json['nearest_highway'] as String?,
      consentAvailable: json['consent_available'] as String?,
      isSync: json['is_sync'] ,
      isSurveyApproved: json['is_survey_approved'] as String?,
      selectedLanguage: json['selected_language'] as String?,
      surveyStatus: json['survey_status'] as String?,
      createdAt: parseDate(json['created_at']),
      updatedAt: null, // since updated_at is {"fn": "NOW", "args": []}, can't parse directly
      deletedAt: parseDate(json['deleted_at']),
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
      deletedBy: json['deleted_by'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
    };
  }
}
