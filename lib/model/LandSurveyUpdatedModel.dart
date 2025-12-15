class LandSurveyUpdatedData {
  final int id;
  final String? surveyId;

  final String? landLocation;
  final int? landStateId;
  final String? landStateName;
  final int? landDistrictId;
  final String? landDistrictName;
  final int? landTalukaId;
  final String? landTalukaName;
  final int? landVillageId;
  final String? landVillageName;

  final String? landLatitude;
  final String? landLongitude;
  final String? landAreaInAcres;
  final int? landType;
  final String? landRateCommercialEscalation;

  final String? subStationName;
  final int? subStationDistrictId;
  final String? subStationDistrictName;
  final int? subStationTalukaId;
  final String? subStationTalukaName;
  final int? subStationVillageId;
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

  final int? consentAvailable;
  final int? isSync;
  final int? isSurveyApproved;
  final String? selectedLanguage;
  final int? surveyStatus;

  final String? createdAt;

  /// updated_at can be:
  /// - a string timestamp
  /// - an object { fn: "NOW" }
  final dynamic updatedAt;

  final String? deletedAt;
  final int? createdBy;
  final int? updatedBy;
  final int? deletedBy;

  LandSurveyUpdatedData({
    required this.id,
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
    return LandSurveyUpdatedData(
      id: json['id'] ?? 0,
      surveyId: json['survey_id'],

      landLocation: json['land_location'],
      landStateId: int.tryParse(json['land_state_id']?.toString() ?? ''),
      landStateName: json['land_state_name'],
      landDistrictId: int.tryParse(json['land_district_id']?.toString() ?? ''),
      landDistrictName: json['land_district_name'],
      landTalukaId: int.tryParse(json['land_taluka_id']?.toString() ?? ''),
      landTalukaName: json['land_taluka_name'],
      landVillageId: int.tryParse(json['land_village_id']?.toString() ?? ''),
      landVillageName: json['land_village_name'],

      landLatitude: json['land_latitude'],
      landLongitude: json['land_longitude'],
      landAreaInAcres: json['land_area_in_acres'],
      landType: int.tryParse(json['land_type']?.toString() ?? ''),
      landRateCommercialEscalation:
          json['land_rate_commercial_escalation']?.toString(),

      subStationName: json['sub_station_name'],
      subStationDistrictId:
          int.tryParse(json['sub_station_district_id']?.toString() ?? ''),
      subStationDistrictName: json['sub_station_district_name'],
      subStationTalukaId:
          int.tryParse(json['sub_station_taluka_id']?.toString() ?? ''),
      subStationTalukaName: json['sub_station_taluka_name'],
      subStationVillageId:
          int.tryParse(json['sub_station_village_id']?.toString() ?? ''),
      subStationVillageName: json['sub_station_village_name'],

      subStationLatitude: json['sub_station_latitude'],
      subStationLongitude: json['sub_station_longitude'],
      subStationInchargeContact: json['sub_station_incharge_contact'],
      subStationInchargeName: json['sub_station_incharge_name'],

      operatorName: json['operator_name'],
      operatorContact: json['operator_contact'],

      subStationVoltageLevel: json['sub_station_voltage_level'],
      subStationCapacity: json['sub_station_capacity'],

      distanceSubStationToLand: json['distance_sub_station_to_land'],
      plotDistanceFromMainRoad: json['plot_distance_from_main_road'],
      evacuationLevel: json['evacuation_level'],
      soilType: json['soil_type'],
      windZone: json['wind_zone'],
      groundWaterRainfall: json['ground_water_rainfall'],
      nearestHighway: json['nearest_highway'],

      consentAvailable:
          int.tryParse(json['consent_available']?.toString() ?? ''),
      isSync: int.tryParse(json['is_sync']?.toString() ?? ''),
      isSurveyApproved:
          int.tryParse(json['is_survey_approved']?.toString() ?? ''),
      selectedLanguage: json['selected_language'],
      surveyStatus: int.tryParse(json['survey_status']?.toString() ?? ''),

      createdAt: json['created_at'],

      /// updated_at may be string OR object (like {"fn": "NOW"})
      updatedAt: json['updated_at'],

      deletedAt: json['deleted_at'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
    );
  }
}
