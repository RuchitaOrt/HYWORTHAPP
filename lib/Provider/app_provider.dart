import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Utils/APIManager.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/Utils/internetConnection.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:hyworth_land_survey/model/DeleteLandSurveyModel.dart';
import 'package:hyworth_land_survey/model/LandSurveyByIDModel.dart';
import 'package:hyworth_land_survey/model/LandSuveryListModel.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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
    print("SURVEYLISTINGSCREEN appprovider");

    await DatabaseHelper.instance.getAllSurveysWithCounts();

    await updateSurveySequencesFromLoadedSurveys(_Surveys);
    notifyListeners();
  }

  Future<void> updateSurveySequencesFromLoadedSurveys(
      List<SurveyModel> surveys) async {
    for (var survey in surveys) {
      String surveyId = survey.surveyId!; // e.g., LS-2025-00000005
      final match = RegExp(r'LS-(\d{4})-(\d+)').firstMatch(surveyId);

      if (match != null) {
        final year = int.parse(match.group(1)!); // 2025
        final seq = int.parse(match.group(2)!); // 5

        await updateSurveySequence(year, seq); // update DB
      }
    }
  }

  Future<void> updateSurveySequence(int year, int seq) async {
    final db = await DatabaseHelper.instance.database;

    final existing = await db.query(
      'survey_sequence',
      where: 'yearMonth = ?',
      whereArgs: [year],
    );

    if (existing.isEmpty) {
      await db.insert('survey_sequence', {
        'yearMonth': year,
        'lastSeq': seq,
      });
    } else {
      final lastSeq = existing.first['lastSeq'] as int;
      if (seq > lastSeq) {
        await db.update(
          'survey_sequence',
          {'lastSeq': seq},
          where: 'yearMonth = ?',
          whereArgs: [year],
        );
      }
    }
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

  Future<void> backgroundSurveySync() async {
    final hasInternet = await ConnectionDetector.checkInternetConnection();
    if (!hasInternet) return;

    // Run quietly
    fetchLandListInBackground(); // page 1
    loadSPendingurveys();
    loadCompletedSurveys();
    loadSurveys();
  }

  Future<void> fetchLandListInBackground() async {
    _currentPage = 1;
    _hasMore = true;

    print("🚀 Background land survey sync started");

    while (_hasMore) {
      await _fetchLandListPage();

      // wait till API finishes
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // small delay to protect server
      await Future.delayed(const Duration(milliseconds: 150));
    }

    print("✅ Background land survey sync completed");
  }

  // Update an existing survey
  void updateSurvey(SurveyModel updatedSurvey) {
    final index = surveys.indexWhere((s) => s.id == updatedSurvey.id);
    if (index != -1) {
      surveys[index] = updatedSurvey;
      notifyListeners(); // triggers UI refresh
    }
  }

  Map<String, dynamic> createRequestBody(int page) {
    return {
      "page": page,
      "limit": 50, // keep small
      "include_media": true,
    };
  }

  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  Future<void> _fetchLandListPage() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;

    final status1 = await ConnectionDetector.checkInternetConnection();
    if (!status1) {
      showToast("Please check internet connection");
      _isLoading = false;
      return;
    }

    final jsonbody = createRequestBody(_currentPage);
    print("📤 Fetching page $_currentPage");

    APIManager().apiRequest(
      routeGlobalKey.currentContext!,
      API.landsurveylist,
      (response) async {
        SurveyResponse resp = response;

        if (resp.data == null || resp.data!.isEmpty) {
          _hasMore = false;
          _isLoading = false;
          return;
        }

        _totalPages = resp.pagination?.totalPages ?? 1;
        _hasMore = _currentPage < _totalPages;

        final db = DatabaseHelper.instance;

        for (var detail in resp.data!) {
          // ---- YOUR EXISTING SAVE CODE (UNCHANGED) ----
          //  LAND IMAGES
          print("RUCHI SURVEY IMAGE ID");
          print(detail.surveyId);
          print(detail.surveyLandImages.length);
          // print(detail.surveyLandImages[0].mediaUrl);
          // print(detail.surveyLandImages[0].id.toString());

          List<SurveyMediaModel> landImages = [];
          for (var media in detail.surveyLandImages ?? []) {
            // Download the image and get the local file path
            print(media);
            final localPath = await urlToLocalPath(media.mediaUrl);
            int surveyLocalId = 0;
            final match =
                RegExp(r'LS-(\d{4})-(\d+)').firstMatch(detail.surveyId);
            if (match != null) {
              surveyLocalId =
                  int.parse(match.group(2)!); // only the sequence number
            }
            // Create SurveyMediaModel with localPath
            landImages.add(SurveyMediaModel(
              surveyLocalId: detail.surveyId,
              // surveyLocalId.toString(), //int.parse(detail.surveyId),
              mediaType: 'land',
              serverMediaId: media.id.toString(),
              isdeleted: 0,
              createdAt: 0,
              localPath: localPath, // ✅ store downloaded local file path
              isSynced: 1,
            ));
            print("LAND IMAGES");
            print(landImages.length);
            // print(landImages[0].localPath);
            // print(landImages[0].id);
          }

          List<SurveyMediaModel> otherImages = [];
          for (var media in detail.surveyOtherDetailsImages ?? []) {
            // Download the image and get the local file path
            final localPath = await urlToLocalPath(media.mediaUrl);

            // Create SurveyMediaModel with localPath
            otherImages.add(SurveyMediaModel(
              surveyLocalId: detail.surveyId,
              mediaType: 'survey',
              serverMediaId: media.id.toString(),
              isdeleted: 0,
              createdAt: 0,
              localPath: localPath, // ✅ store downloaded local file path
              isSynced: 1,
            ));
            print("otherImages IMAGES");
            print(otherImages.length);
          }

          List<SurveyMediaModel> consentImages = [];
          for (var media in detail.consents ?? []) {
            // Download the image and get the local file path
            final localPath = await urlToLocalPath(media.mediaUrl);

            // Create SurveyMediaModel with localPath
            consentImages.add(SurveyMediaModel(
              surveyLocalId: detail.surveyId,
              mediaType: 'consent',
              serverMediaId: media.id.toString(),
              isdeleted: 0,
              createdAt: 0,
              localPath: localPath, // ✅ store downloaded local file path
              isSynced: 1,
            ));
          }
          print("SURVEY OTHER IMAGES");
          print(otherImages);
          // print(otherImages[0].id.toString());
          //    print(otherImages[0].localPath.toString());

          int surveyLocalId = 0;
          final match =
              RegExp(r'LS-(\d{4})-(\d+)').firstMatch(detail.id.toString());
          if (match != null) {
            surveyLocalId =
                int.parse(match.group(2)!); // only the sequence number
          }
          final survey = SurveyModel(
            id: detail.id, //detail.id ?? 0,
            surveyId: detail.surveyId ?? "",
            userId: detail.createdBy?.toString() ?? "",
            landState: detail.landStateName ?? "",
            landLocation: detail.landLocation ?? "",
            landStateID: detail.landStateId?.toString() ?? "",
            landDistrictID: detail.landDistrictId.toString(),
            landTalukaID: detail.landTalukaId.toString(),
            landVillageID: detail.landVillageId.toString(),
            landDistrict: detail.landDistrictName ?? "",
            landTaluka: detail.landTalukaName ?? "",
            landVillage: detail.landVillageName ?? "",
            landLatitude: double.tryParse(detail.landLatitude ?? "0") ?? 0.0,
            landLongitude: double.tryParse(detail.landLongitude ?? "0") ?? 0.0,
            landAreaInAcres: detail.landAreaInAcres ?? "",
            landType: detail.landType?.toString() ?? "",
            landRateCommercialEscalation:
                detail.landRateCommercialEscalation ?? "",

            landPictures: otherImages,
            surveyForms: landImages,
            consentForms: consentImages,

            subStationName: detail.subStationName ?? "",
            subStationDistrict: detail.subStationDistrictName ?? "",
            subStationTaluka: detail.subStationTalukaName ?? "",
            subStationVillage: detail.subStationVillageName ?? "",
            subStationLatitude:
                double.tryParse(detail.subStationLatitude ?? "0") ?? 0.0,
            subStationLongitude:
                double.tryParse(detail.subStationLongitude ?? "0") ?? 0.0,
            inchargeName: detail.subStationInchargeName ?? "",
            subStationInchargeContact: detail.subStationInchargeContact ?? "",
            operatorName: detail.operatorName ?? "",
            operatorContact: detail.operatorContact ?? "",
            subStationVoltageLevel: detail.subStationVoltageLevel ?? "",
            subStationCapacity: detail.subStationCapacity ?? "",
            distanceSubStationToLand: detail.distanceSubStationToLand ?? "",
            plotDistanceFromMainRoad: detail.plotDistanceFromMainRoad ?? "",

            evacuationLevel: detail.evacuationLevel ?? "",
            windZone: detail.windZone ?? "",
            groundWaterRainFall: detail.groundWaterRainfall ?? "",
            soilType: detail.soilType ?? "",
            nearestHighway: detail.nearestHighway ?? "",

            isSurveyapproved: detail.isSurveyApproved ?? 0,
            consentAvailable: detail.consentAvailable ?? 0,
            isSync: 1, // API data

            selectedLanguage: detail.selectedLanguage ?? "en",
            serverSynced: 1,
            surveyDate: detail.createdAt != null
                ? DateTime.parse(detail.createdAt!).millisecondsSinceEpoch
                : DateTime.now().millisecondsSinceEpoch,
            updatedsurveyDate: detail.updatedAt != null
                ? DateTime.parse(detail.updatedAt!).millisecondsSinceEpoch
                : DateTime.now().millisecondsSinceEpoch,

            surveyStatus: detail.surveyStatus.toString(),
            substationDistrictID: detail.subStationDistrictId.toString(),
            substationVillageID: detail.subStationVillageId.toString(),
            substationTalukaID: detail.subStationTalukaId.toString(),
          );

          final exists = await db.surveyExists(survey.surveyId!);
          print("SURVEY OTHER landPictures");
          print(survey.landPictures.length);

          if (exists) {
            int insertedCount =
                await DatabaseHelper.instance.upsertSurveyMediaList(
              surveyLocalId: survey.surveyId!, // keep as String
              landPictures: otherImages,
              surveyForms: landImages,
              consentForms: consentImages,
            );
            if (insertedCount > 0) {
              print(
                  "✅ Updated inserted $insertedCount media files for survey ${survey.surveyId}");
            } else {
              print(
                  "⚠️ No media files were inserted for survey ${survey.surveyId}");
            }
          } else {
            int insertedCount =
                await DatabaseHelper.instance.insertSurveyMediaList(
              surveyLocalId: survey.surveyId!, // keep as String
              landPictures: otherImages,
              surveyForms: landImages,
              consentForms: consentImages,
            );

            if (insertedCount > 0) {
              print(
                  "✅ Successfully inserted $insertedCount media files for survey ${survey.surveyId}");
            } else {
              print(
                  "⚠️ No media files were inserted for survey ${survey.surveyId}");
            }
          }

          int totalmedia = await db.mediaCunt();
          print("totalmedia ${totalmedia.toString()}");

          if (exists) {
            await db.updateSurvey(survey, surveyLocalId);
          } else {
            await db.insertSurvey(survey);
          }
          db.printAllSurveys(survey.surveyId!);
        }

        _currentPage++;
        _isLoading = false;
        notifyListeners();
      },
      (error) {
        _isLoading = false;
        // 🔴 STOP further pagination
        _hasMore = false;
        showToast("Server Not Responding");
        notifyListeners();
      },
      jsonval: jsonbody,
    );
  }

  Map<String, dynamic> createRequestfetchLandBYID(String surveyID) {
    return {"land_survey_id": surveyID};
  }

  deleteLandList(String surveyID) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      dynamic jsonbody = createRequestfetchLandBYID(surveyID);
      print("-----SURVEY DELETE RESPONSE____");
      print(jsonbody);

      APIManager()
          .apiRequest(routeGlobalKey.currentContext!, API.landsurveydelete,
              (response) async {
        print("-----SURVEY DELETE RESPONSE____");
        DeleteLandSurveyModel resp = response;

        print("-----SURVEY LAND____");
        if (resp == null) return;
        print("-----SURVEY LAND1____");
        final db = DatabaseHelper.instance;
        showToast(resp.message);
        await db.deleteSurvey(int.parse(resp.deletedSurveyId.toString()));
        await db.getAllSurveys();

        print("Land Surveys DELETED to DB successfully!");
        notifyListeners();
      }, (error) {
        print('ERR msg is $error');

        showToast("Server Not Responding");
      }, jsonval: jsonbody);
    } else {
      /// Navigator.of(_keyLoader.currentContext).pop();
      showToast("Please check internet connection");
    }
  }

  fetchLandBYID(String surveyID) async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      dynamic jsonbody = createRequestfetchLandBYID(surveyID);
      print(jsonbody);

      APIManager().apiRequest(routeGlobalKey.currentContext!, API.getById,
          (response) async {
        LandSurveyByIdModel resp = response;
        print("-----TOKEN FROM API____");
      }, (error) {
        print('ERR msg is $error');

        showToast("Server Not Responding");
      }, jsonval: jsonbody);
    } else {
      /// Navigator.of(_keyLoader.currentContext).pop();
      showToast("Please check internet connection");
    }
  }

  Future<String> urlToLocalPath(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    final dir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageUrl); // keeps original name
    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(response.bodyBytes);
    return file.path; // ✅ THIS is the local path
  }
}
