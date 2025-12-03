
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';

class AppProvider extends ChangeNotifier {
 
  AppProvider() {}
  
  List<SurveyModel> _pendingSurveys = [];

  List<SurveyModel> get pendingsurveys => _pendingSurveys;
   List<SurveyModel> _consentSurveys = [];

  List<SurveyModel> get consentSurveys => _consentSurveys;
   List<SurveyModel> _Surveys = [];

  List<SurveyModel> get surveys => _Surveys;


  List<SurveyModel> _completeSurveys = [];

  List<SurveyModel> get completeSurveys => _completeSurveys;
 final List<SurveyModel> staticSurveys = [
    SurveyModel(
      surveyId: "202509001",
      landState: "Maharashtra",
      landDistrict: "Mumbai",
      landVillage: "Goa",
      subStationCapacity: "10",
      landAreaInAcres: "20",
      subStationName: "Mame",
      landType: "Soil",
      landRateCommercialEscalation: "20",
    ),
    SurveyModel(
      surveyId: "202509002",
      landState: "Maharashtra",
      subStationCapacity: "10",
      landVillage: "Goa",
      landDistrict: "Mumbai",
      landAreaInAcres: "20",
      subStationName: "Mame",
      landType: "Soil",
      landRateCommercialEscalation: "20",
    ),
  ];

  Future<void> loadSPendingurveys() async {
    //  _surveys = staticSurveys;
    _pendingSurveys = await DatabaseHelper.instance.getPendingSurveys();
    await DatabaseHelper.instance.getAllSurveysWithCounts();
    notifyListeners();
  }
    Future<void> loadConsentSurveys() async {
    //  _surveys = staticSurveys;
    _consentSurveys = await DatabaseHelper.instance.getConsentSurveys();
    
    notifyListeners();
  }
  Future<void> loadCompletedSurveys() async {
    //  _surveys = staticSurveys;
    _completeSurveys = await DatabaseHelper.instance.getCompletedSurveys();
 
    notifyListeners();
  }
  Future<void> loadSurveys() async {
    //  _surveys = staticSurveys;
    _Surveys = await DatabaseHelper.instance.getAllSurveys();
    await DatabaseHelper.instance.getAllSurveysWithCounts();
    notifyListeners();
  }

  Future<void> addSurvey(SurveyModel survey) async {
    await DatabaseHelper.instance.insertSurvey(survey);
    await loadSPendingurveys(); // reload after insert
  }
  Future<void> refreshDashboard() async {
    // fetch dashboard counts or reset state
    notifyListeners();
  }
  String _currentLanguage = 'en'; // default

  String get currentLanguage => _currentLanguage;

  void changeLanguage(String lang) {
    _currentLanguage = lang;
    notifyListeners();
  }
  // Update an existing survey
  void updateSurvey(SurveyModel updatedSurvey) {
    final index = surveys.indexWhere((s) => s.id == updatedSurvey.id);
    if (index != -1) {
      surveys[index] = updatedSurvey;
      notifyListeners(); // triggers UI refresh
    }
  }

}
