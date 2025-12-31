import 'package:hyworth_land_survey/model/SurveyModel.dart';

extension SurveySyncValidation on SurveyModel {
  bool isReadyForSync() {
    // ---------- Land master ----------
    if (!_hasValue(landStateID)) return false;
    if (!_hasValue(landDistrictID)) return false;
    if (!_hasValue(landTalukaID)) return false;
    if (!_hasValue(landVillageID)) return false;

    // ---------- Land location ----------
    if (landLatitude == null || landLatitude == 0) return false;
    if (landLongitude == null || landLongitude == 0) return false;

    // ---------- Land details ----------
    if (landAreaInAcres == null || landAreaInAcres == 0) return false;
    if (landRateCommercialEscalation == null) return false;

    // ---------- Substation master ----------
    if (!_hasValue(substationDistrictID)) return false;
    if (!_hasValue(substationTalukaID)) return false;
    if (!_hasValue(substationVillageID)) return false;

    // ---------- Substation location ----------
    if (subStationLatitude == null || subStationLatitude == 0) return false;
    if (subStationLongitude == null || subStationLongitude == 0) return false;

    // ---------- Substation details ----------
    if (!_hasText(subStationName)) return false;
    if (!_hasText(inchargeName)) return false;
    if (!_hasText(subStationInchargeContact)) return false;
    if (!_hasText(operatorName)) return false;
    if (!_hasText(operatorContact)) return false;
    if (!_hasText(subStationVoltageLevel)) return false;
    if (!_hasText(subStationCapacity)) return false;
    if (distanceSubStationToLand == null) return false;
    if (plotDistanceFromMainRoad == null) return false;

    // ---------- Environmental ----------
    if (!_hasText(evacuationLevel)) return false;
    if (!_hasText(windZone)) return false;
    if (!_hasText(groundWaterRainFall)) return false;
    if (!_hasText(soilType)) return false;
    if (!_hasText(nearestHighway)) return false;

    // ---------- Media ----------
    // if (!_hasValidMedia(landPictures, min: 7)) return false;
    if (!_hasValidMedia(surveyForms, min: 1)) return false;

    return true;
  }
}
bool _hasValue(String? v) =>
    v != null && v.trim().isNotEmpty;

bool _hasText(String? v) =>
    v != null && v.trim().isNotEmpty;

bool _hasValidMedia(List<SurveyMediaModel>? list, {int min = 1}) {
  if (list == null || list.isEmpty) return false;

  final valid = list.where((m) =>
      m.isdeleted == 0 &&
      (m.localPath?.isNotEmpty ?? false || m.serverMediaId.isNotEmpty ?? false)
  ).length;

  return valid >= min;
}
