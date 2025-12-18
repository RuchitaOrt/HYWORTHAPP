import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/StepForm.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonstrings.dart';
import 'package:hyworth_land_survey/Utils/internetConnection.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';

import 'package:hyworth_land_survey/widgets/CommonAppBar.dart';
import 'package:hyworth_land_survey/widgets/StepProgressBar.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';
import 'package:provider/provider.dart';

class SurveyDetailForm extends StatefulWidget {
  final int isEdit; //if edit pass 1
  final SurveyModel? surveyListing;

  const SurveyDetailForm({
    super.key,
    required this.isEdit,
    this.surveyListing,
  });

  @override
  State<SurveyDetailForm> createState() => _SurveyDetailFormState();
}

class _SurveyDetailFormState extends State<SurveyDetailForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CommonColors.white,
        body: ChangeNotifierProvider(
            create: (_) => BasicFormProvider(),
            child: Consumer<BasicFormProvider>(
              builder: (context, provider, _) {
                return DetailForm(
                  isEdit: widget.isEdit,
                  surveyListing: widget.surveyListing,
                );
              },
            )));
  }
}

class DetailForm extends StatefulWidget {
  final int isEdit;
  final SurveyModel? surveyListing;
  const DetailForm({
    super.key,
    this.surveyListing,
    required this.isEdit,
  });

  @override
  State<DetailForm> createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  int currentStep = 1;
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // ✅ Safe place for inherited widget lookups

  // }

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<BasicFormProvider>(context, listen: false);

    // Add listeners to trigger rebuild
    [
      // provider.solarCapacityController,
      // provider.gridConnectivityController,
      // provider.landStateController,
      // provider.landDistrictController,
      // provider.landTalukaController,
      // provider.landVillageController,
      provider.landLatitudeController,
      provider.landLonitudeController,
      provider.landAreaController,
      provider.landRateontroller,
      provider.subStationCapacityController,
      provider.subStationDistancebtwLandController,
      provider.subStationDistancebtwPlotController,
      // provider.subStationDistrictController,
      provider.subStationInchargeContactController,
      provider.subStationInchargeNameController,
      provider.subStationLatitudeController,
      provider.subStationLongitudeController,
      provider.subStationNameController,
      provider.subStationOperatorContactController,
      provider.subStationOperatorNameController,
      // provider.subStationTalukaController,
      // provider.subStationVillageController,
      provider.subStationVoltageLevelController,
      provider.otherEvacuationController,
      provider.typeofSoilController,
      provider.windZoneController,
      provider.groundWaterController,
      provider.nearestHighwayController
    ].forEach((controller) {
      controller.addListener(() => setState(() {}));
    });
    if (widget.isEdit == 1) {
      //LAND DETAILS
      print(widget.surveyListing!.surveyId);
      // provider.landDistrictController.text =
      //     widget.surveyListing!.landDistrict!;
      provider.selectedLandState = {
        'id': widget.surveyListing!.landStateID!,
        'name': widget.surveyListing!.landState!,
      };
      provider.selectedLandDistrict = {
        'id': widget.surveyListing!.landDistrictID!,
        'district_name': widget.surveyListing!.landDistrict!,
      };
      // provider.landTalukaController.text = widget.surveyListing!.landTaluka!;
      provider.selectedLandTaluka = {
        'id': widget.surveyListing!.landTalukaID!,
        'taluka_name': widget.surveyListing!.landTaluka!,
      };
      provider.landLatitudeController.text =
          widget.surveyListing!.landLatitude!.toString();
      provider.landLonitudeController.text =
          widget.surveyListing!.landLongitude!.toString();

      // (widget.surveyListing!.landState == null ||
      //         widget.surveyListing!.landState == "")
      //     ? ""
      //     : widget.surveyListing!.landState!;
      // provider.landVillageController.text =
      //     widget.surveyListing!.landVillage! ?? "";
      provider.selectedLandVillage = {
        'id': widget.surveyListing!.landVillageID!,
        'village_name': widget.surveyListing!.landVillage!,
      };
      provider.landAreaController.text = widget.surveyListing!.landAreaInAcres!;

      provider.setRentLeaseOption(widget.surveyListing!.landType!);
      provider.landRateontroller.text =
          widget.surveyListing!.landRateCommercialEscalation!;
      provider.solarCapacityController.text =
          widget.surveyListing!.subStationCapacity!;

//SUB_STATION
      provider.subStationNameController.text =
          widget.surveyListing!.subStationName!;
      // provider.subStationDistrictController.text =
      //     widget.surveyListing!.subStationDistrict!;
      provider.selectedsubstationDistrict = {
        'id': widget.surveyListing!.substationDistrictID!,
        'district_name': widget.surveyListing!.subStationDistrict!,
      };
      // provider.subStationTalukaController.text =
      //     widget.surveyListing!.subStationTaluka!;
      provider.selectedsubstationTaluka = {
        'id': widget.surveyListing!.substationTalukaID!,
        'taluka_name': widget.surveyListing!.subStationTaluka!,
      };
      // provider.subStationVillageController.text =
      //     widget.surveyListing!.subStationVillage!;
      provider.selectedsubstationVillage = {
        'id': widget.surveyListing!.substationVillageID!,
        'village_name': widget.surveyListing!.subStationVillage!,
      };
      provider.subStationLatitudeController.text =
          widget.surveyListing!.subStationLatitude!.toString();
      provider.subStationLongitudeController.text =
          widget.surveyListing!.subStationLongitude!.toString();
      provider.subStationInchargeContactController.text =
          widget.surveyListing!.subStationInchargeContact!;
      provider.subStationInchargeNameController.text =
          widget.surveyListing!.inchargeName!;
      provider.subStationOperatorNameController.text =
          widget.surveyListing!.operatorName!;
      provider.subStationOperatorContactController.text =
          widget.surveyListing!.operatorContact!;
      provider.subStationVoltageLevelController.text =
          widget.surveyListing!.subStationVoltageLevel!;
      provider.subStationCapacityController.text =
          widget.surveyListing!.subStationCapacity!;
      provider.subStationDistancebtwLandController.text =
          widget.surveyListing!.distanceSubStationToLand!;
      provider.subStationDistancebtwPlotController.text =
          widget.surveyListing!.plotDistanceFromMainRoad!;
//OTHER DETAILS
      provider.otherEvacuationController.text =
          widget.surveyListing!.evacuationLevel!;
      provider.windZoneController.text = widget.surveyListing!.windZone!;
      provider.groundWaterController.text =
          widget.surveyListing!.groundWaterRainFall!;
      provider.typeofSoilController.text = widget.surveyListing!.soilType!;
      provider.nearestHighwayController.text =
          widget.surveyListing!.nearestHighway!;

// Load survey form (single file)
      if (widget.surveyListing?.surveyForms != null &&
          widget.surveyListing!.surveyForms!.isNotEmpty) {
        final surveyFormMedia = widget.surveyListing!.surveyForms![0];
        if (surveyFormMedia.localPath.isNotEmpty) {
          final file = File(surveyFormMedia.localPath);
          provider.surveyFormsmediaFile = file;
          provider.setImage(file); // your provider method
        }
      }

// Load land pictures (multiple files)
      if (widget.surveyListing?.landPictures != null &&
          widget.surveyListing!.landPictures!.isNotEmpty) {
        final landMedias = widget.surveyListing!.landPictures!;

        provider.OtherLandmediaFiles.clear();
        provider.OtherLandmediaFiles.addAll(
          landMedias.map((media) => File(media.localPath)).toList(),
        );

        // If your provider needs to set them individually
        for (int i = 0; i < landMedias.length; i++) {
          provider.setMediaFile(i, File(landMedias[i].localPath));
        }
      }

      // provider.mediaFile=widget.surveyListing!.surveyForms[0];
      // if (widget.surveyListing!.surveyForms != null &&
      //     widget.surveyListing!.surveyForms!.isNotEmpty) {
      //   // assign to provider
      //   context.read<BasicFormProvider>().surveyFormsmediaFile = File(
      //       widget.surveyListing!.surveyForms![0]); // convert path back to File
      //   provider.setImage(File(widget.surveyListing!.surveyForms![0]));
      // }

      // // Assuming landPictures is a List<String> of file paths
      // if (widget.surveyListing?.landPictures != null &&
      //     widget.surveyListing!.landPictures!.isNotEmpty) {
      //   final provider = context.read<BasicFormProvider>();
      //   print("LAND PICTURE");
      //   print(widget.surveyListing!.landPictures!.length);
      //   for (int i = 0; i < widget.surveyListing!.landPictures!.length; i++) {
      //     if (i < provider.OtherLandmediaFiles.length) {
      //       // Convert path string to File
      //       final file = File(widget.surveyListing!.landPictures![i]);

      //       // Assign to OtherLandmediaFiles list
      //       provider.OtherLandmediaFiles[i] = file;

      //       // If your provider manages these images, set them too
      //       provider.setMediaFile(i, file);
      //     }
      //   }
      // }
    }
  }

  void nextStep() async {
    final provider = Provider.of<BasicFormProvider>(context, listen: false);

    bool isStepValid = true;

    switch (currentStep) {
      case 1:
        isStepValid = provider.isBasicFormValid;
        break;
      case 2:
        isStepValid = provider.isSubstaionFormValid; // ⬅️ you'll define this
        break;
      case 3:
        isStepValid = provider.isOtherFormValid; // ⬅️ and this too
        break;
      case 4:
        isStepValid = provider.isBasicFormValid;
        break;
      // case 5:
      //   isStepValid = provider.isBasicFormValid;
      //   break;
    }

    // if (!isStepValid) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Please fill all required fields")),
    //   );
    //   return;
    // }

    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    } else {
      final basicFormProvider =
          Provider.of<BasicFormProvider>(context, listen: false);
      print("Last FORM");
      if (widget.isEdit == 1) {
        print("ISEDIT Last Button Save & EXIT");
        final bool canSync = await isSurveyComplete(basicFormProvider);
        print("canSync Update");
        print(canSync);
// LAND PICTURES
        List<SurveyMediaModel> landPictures =
            basicFormProvider.OtherLandmediaFiles.where(
                    (file) => file != null) // keep only non-null
                .map((file) => SurveyMediaModel(
                      surveyLocalId: 0, // set after inserting survey
                      mediaType: 'land',
                      localPath: file!.path,
                      isSynced: 0, // not synced yet
                    ))
                .toList();

// SURVEY FORMS (single file example)
        List<SurveyMediaModel> surveyForms =
            basicFormProvider.surveyFormsmediaFile != null
                ? [
                    SurveyMediaModel(
                      surveyLocalId: 0, // set after inserting survey
                      mediaType: 'survey',
                      localPath: basicFormProvider.surveyFormsmediaFile!.path,
                      isSynced: 0,
                    )
                  ]
                : [];

        SurveyModel survey = SurveyModel(
            surveyId:
                widget.surveyListing!.surveyId.toString() ?? "", // never null
            userId: "1",
            landState: basicFormProvider.selectedLandState!['name'] ?? "",
            landDistrict:
                basicFormProvider.selectedLandDistrict!['district_name'],
            landTaluka:
                basicFormProvider.selectedLandTaluka!['taluka_name'] ?? "",
            landVillage:
                basicFormProvider.selectedLandVillage!['village_name'] ?? "",
            landStateID: basicFormProvider.selectedLandState!['id'] ?? "",
            landDistrictID: basicFormProvider.selectedLandDistrict!['id'],
            landTalukaID: basicFormProvider.selectedLandTaluka!['id'] ?? "",
            landVillageID: basicFormProvider.selectedLandVillage!['id'] ?? "",
            substationDistrictID:
                basicFormProvider.selectedsubstationDistrict!['id'] ?? "",
            substationTalukaID:
                basicFormProvider.selectedsubstationTaluka!['id'] ?? "",
            substationVillageID:
                basicFormProvider.selectedsubstationVillage!['id'] ?? "",
            landLatitude: basicFormProvider.landLatitudeController.text.isEmpty
                ? 0.0
                : double.parse(basicFormProvider.landLatitudeController.text),
            landLongitude: basicFormProvider.landLonitudeController.text.isEmpty
                ? 0.0
                : double.parse(basicFormProvider.landLonitudeController.text),
            landAreaInAcres: basicFormProvider.landAreaController.text ?? "",
            landType: basicFormProvider.rentLeaseOption ?? "",
            landRateCommercialEscalation:
                basicFormProvider.landRateontroller.text ?? "",
            subStationName:
                basicFormProvider.subStationNameController.text ?? "",
            subStationDistrict: basicFormProvider
                    .selectedsubstationDistrict!['district_name'] ??
                "",
            subStationTaluka:
                basicFormProvider.selectedsubstationTaluka!['taluka_name'] ??
                    "",
            subStationVillage:
                basicFormProvider.selectedsubstationVillage!['village_name'] ??
                    "",
            subStationLatitude: basicFormProvider
                    .subStationLatitudeController.text.isEmpty
                ? 0.0
                : double.parse(basicFormProvider.subStationLatitudeController.text),
            subStationLongitude: basicFormProvider.subStationLongitudeController.text.isEmpty ? 0.0 : double.parse(basicFormProvider.subStationLongitudeController.text),
            inchargeName: basicFormProvider.subStationInchargeNameController.text ?? "",
            subStationInchargeContact: basicFormProvider.subStationInchargeContactController.text ?? "",
            operatorName: basicFormProvider.subStationOperatorNameController.text ?? "",
            operatorContact: basicFormProvider.subStationOperatorContactController.text ?? "",
            subStationVoltageLevel: basicFormProvider.subStationVoltageLevelController.text ?? "",
            subStationCapacity: basicFormProvider.subStationCapacityController.text ?? "",
            distanceSubStationToLand: basicFormProvider.subStationDistancebtwLandController.text ?? "",
            plotDistanceFromMainRoad: basicFormProvider.subStationDistancebtwPlotController.text ?? "",
            evacuationLevel: basicFormProvider.otherEvacuationController.text ?? "",
            windZone: basicFormProvider.windZoneController.text ?? "",
            groundWaterRainFall: basicFormProvider.groundWaterController.text ?? "",
            soilType: basicFormProvider.typeofSoilController.text ?? "",
            nearestHighway: basicFormProvider.nearestHighwayController.text ?? "",
            // surveyForms: basicFormProvider.surveyFormsmediaFile != null ? [basicFormProvider.surveyFormsmediaFile!.path!] : [],
            // landPictures: basicFormProvider.OtherLandmediaFiles.where((file) => file != null) // keep only non-null
            //     .map((file) => file!.path) // extract paths
            //     .toList(),
            landPictures: landPictures,
            surveyForms: surveyForms,
            consentForms: [],
            isSync: 0,
            serverSynced: widget.surveyListing!.serverSynced,
            isSurveyapproved: 0,
            consentAvailable: 0,
            selectedLanguage: Provider.of<AppProvider>(context, listen: false).currentLanguage,
            surveyDate: widget.surveyListing!.surveyDate,
            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
            surveyStatus: CommonStrings.strPending);
        var status1 = await ConnectionDetector.checkInternetConnection();
        if (canSync && status1) {
          print("CALIING UPDATE API TO INSERT HERE");
          basicFormProvider.submitLandSurvey(survey);
          final updatedRows = await DatabaseHelper.instance
              .updateSurvey(survey, widget.surveyListing!.id!);
          print("Survey : ${survey.surveyId}");
          print("Survey : ${survey.isSurveyapproved}");
          await DatabaseHelper.instance.insertSurveyMediaList(
            surveyLocalId: int.parse(survey.surveyId.toString()),

            landPictures:
                basicFormProvider.OtherLandmediaFiles.whereType<File>()
                    .toList(),

            surveyForms: basicFormProvider.surveyFormsmediaFile != null
                ? [basicFormProvider.surveyFormsmediaFile!]
                : [],

            consentForms: [], // not available at creation time
          );
          if (updatedRows > 0) {
            print("✅ Survey updated successfully");
          } else {
            print("⚠️ No survey found to update");
          }
        } else {
          final updatedRows = await DatabaseHelper.instance
              .updateSurvey(survey, widget.surveyListing!.id!);
          print("Survey : ${survey.surveyId}");
          print("Survey : ${survey.isSurveyapproved}");
          if (updatedRows > 0) {
            print("✅ Survey updated successfully");
          } else {
            print("⚠️ No survey found to update");
          }
          await DatabaseHelper.instance.insertSurveyMediaList(
            surveyLocalId: int.parse(survey.surveyId.toString()),

            landPictures:
                basicFormProvider.OtherLandmediaFiles.whereType<File>()
                    .toList(),

            surveyForms: basicFormProvider.surveyFormsmediaFile != null
                ? [basicFormProvider.surveyFormsmediaFile!]
                : [],

            consentForms: [], // not available at creation time
          );
          final result =
              await Navigator.of(routeGlobalKey.currentContext!).push(
            createSlideFromBottomRoute(
              Maintabscreen(),
            ),
          );
        }

        // Navigator.pop(context, true);
      } else {
        print("Inserted 0 Last Button Save & EXIT");

        final bool canSync = await isSurveyComplete(basicFormProvider);
        print("canSync");
        print(canSync);
        List<SurveyMediaModel> landPictures =
            basicFormProvider.OtherLandmediaFiles.where(
                    (file) => file != null) // keep only non-null
                .map((file) => SurveyMediaModel(
                      surveyLocalId: 0, // set after inserting survey
                      mediaType: 'land',
                      localPath: file!.path,
                      isSynced: 0, // not synced yet
                    ))
                .toList();

// SURVEY FORMS (single file example)
        List<SurveyMediaModel> surveyForms =
            basicFormProvider.surveyFormsmediaFile != null
                ? [
                    SurveyMediaModel(
                      surveyLocalId: 0, // set after inserting survey
                      mediaType: 'survey',
                      localPath: basicFormProvider.surveyFormsmediaFile!.path,
                      isSynced: 0,
                    )
                  ]
                : [];

        SurveyModel survey = SurveyModel(
          surveyId: await generateSurveyId() ?? "",
          userId: "1",
          landStateID: basicFormProvider.selectedLandState!['id'] ?? "",
          landState: basicFormProvider.selectedLandState?['name'] ?? "",
          landDistrict:
              basicFormProvider.selectedLandDistrict?['district_name'] ?? "",
          landTaluka:
              basicFormProvider.selectedLandTaluka?['taluka_name'] ?? "",
          landVillage:
              basicFormProvider.selectedLandVillage?['village_name'] ?? "",

          landDistrictID: basicFormProvider.selectedLandDistrict?['id'] ?? "",
          landTalukaID: basicFormProvider.selectedLandTaluka?['id'] ?? "",
          landVillageID: basicFormProvider.selectedLandVillage?['id'] ?? "",

          landLatitude:
              double.tryParse(basicFormProvider.landLatitudeController.text) ??
                  0.0,

          landLongitude:
              double.tryParse(basicFormProvider.landLonitudeController.text) ??
                  0.0,

          landAreaInAcres: basicFormProvider.landAreaController.text,
          landType: basicFormProvider.rentLeaseOption ?? "",
          landRateCommercialEscalation:
              basicFormProvider.landRateontroller.text,

          subStationName: basicFormProvider.subStationNameController.text,

          subStationDistrict:
              basicFormProvider.selectedsubstationDistrict?['district_name'] ??
                  "",
          subStationTaluka:
              basicFormProvider.selectedsubstationTaluka?['taluka_name'] ?? "",
          subStationVillage:
              basicFormProvider.selectedsubstationVillage?['village_name'] ??
                  "",

          substationDistrictID:
              basicFormProvider.selectedsubstationDistrict?['id'] ?? "",
          substationTalukaID:
              basicFormProvider.selectedsubstationTaluka?['id'] ?? "",
          substationVillageID:
              basicFormProvider.selectedsubstationVillage?['id'] ?? "",

          subStationLatitude: double.tryParse(
                  basicFormProvider.subStationLatitudeController.text) ??
              0.0,

          subStationLongitude: double.tryParse(
                  basicFormProvider.subStationLongitudeController.text) ??
              0.0,

          inchargeName: basicFormProvider.subStationInchargeNameController.text,
          subStationInchargeContact:
              basicFormProvider.subStationInchargeContactController.text,
          operatorName: basicFormProvider.subStationOperatorNameController.text,
          operatorContact:
              basicFormProvider.subStationOperatorContactController.text,

          subStationVoltageLevel:
              basicFormProvider.subStationVoltageLevelController.text,
          subStationCapacity:
              basicFormProvider.subStationCapacityController.text,

          distanceSubStationToLand:
              basicFormProvider.subStationDistancebtwLandController.text,
          plotDistanceFromMainRoad:
              basicFormProvider.subStationDistancebtwPlotController.text,

          evacuationLevel: basicFormProvider.otherEvacuationController.text,
          windZone: basicFormProvider.windZoneController.text,
          groundWaterRainFall: basicFormProvider.groundWaterController.text,
          soilType: basicFormProvider.typeofSoilController.text,
          nearestHighway: basicFormProvider.nearestHighwayController.text,
          landPictures: landPictures,
          surveyForms: surveyForms,
          consentForms: [],

          // surveyForms: basicFormProvider.surveyFormsmediaFile != null
          //     ? [basicFormProvider.surveyFormsmediaFile!.path]
          //     : [],

          // landPictures: basicFormProvider.OtherLandmediaFiles.whereType<File>()
          //     .map((f) => f.path)
          //     .toList(),

          isSurveyapproved: 0,
          consentAvailable: 0,

          /// 🔑 FINAL DECISION
          isSync: 0,
          serverSynced: 0,
          
          selectedLanguage:
              Provider.of<AppProvider>(context, listen: false).currentLanguage,

          surveyDate: DateTime.now().millisecondsSinceEpoch,
          updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
          surveyStatus: CommonStrings.strPending,
        );

        var status1 = await ConnectionDetector.checkInternetConnection();
        if (canSync && status1) {
          print("CALIING API TO INSERT HERE");
          basicFormProvider.submitLandSurvey(survey);
          // 1️⃣ INSERT SURVEY FIRST
          final int surveyLocalId =
              await DatabaseHelper.instance.insertSurvey(survey);

          print("✅ Survey inserted locally with id = $surveyLocalId");

// 2️⃣ INSERT MEDIA FILES
          await DatabaseHelper.instance.insertSurveyMediaList(
            surveyLocalId: surveyLocalId,

            landPictures:
                basicFormProvider.OtherLandmediaFiles.whereType<File>()
                    .toList(),

            surveyForms: basicFormProvider.surveyFormsmediaFile != null
                ? [basicFormProvider.surveyFormsmediaFile!]
                : [],

            consentForms: [], // not available at creation time
          );

          print("✅ Media inserted for survey Inserted $surveyLocalId");

          print("✅ Survey inserted locally with id = $surveyLocalId");

          print("✅ Survey saved locally");
          print("Survey : ${survey.surveyId}");
          print("Survey : ${survey.isSurveyapproved}");
        } else {
          final int surveyLocalId =
              await DatabaseHelper.instance.insertSurvey(survey);
          print("✅ Survey saved locally");
          print("Survey : ${survey.surveyId}");
          print("Survey : ${survey.isSurveyapproved}");
          await DatabaseHelper.instance.insertSurveyMediaList(
            surveyLocalId: surveyLocalId,

            landPictures:
                basicFormProvider.OtherLandmediaFiles.whereType<File>()
                    .toList(),

            surveyForms: basicFormProvider.surveyFormsmediaFile != null
                ? [basicFormProvider.surveyFormsmediaFile!]
                : [],

            consentForms: [], // not available at creation time
          );

          print("✅ Media inserted for survey Inserted $surveyLocalId");

          print("✅ Survey inserted locally with id = $surveyLocalId");

          print("✅ Survey saved locally");
          print("Survey : ${survey.surveyId}");
          print("Survey : ${survey.isSurveyapproved}");
        }
      }

//       List<SurveyModel> surveys = await DatabaseHelper.instance.getAllSurveys();
// // for (var survey in surveys) {
//       print("Survey : ${surveys.length}");

//       final db = await DatabaseHelper.instance.database;
//       final List<Map<String, dynamic>> maps = await db.query('surveys');
//       print(maps); // prints all rows in console

      Navigator.pop(context, true);
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  bool isSurveyComplete(BasicFormProvider p) {
    // ---------- Land master ----------
    if (!_validId(p.selectedLandState)) {
      debugPrint("${p.selectedLandState}");
      debugPrint("❌ Land State invalid");
      return false;
    }
    if (!_validId(p.selectedLandDistrict)) {
      debugPrint("❌ Land District invalid");
      return false;
    }
    if (!_validId(p.selectedLandTaluka)) {
      debugPrint("❌ Land Taluka invalid");
      return false;
    }
    if (!_validId(p.selectedLandVillage)) {
      debugPrint("❌ Land Village invalid");
      return false;
    }

    // ---------- Land location ----------
    if (!_validDouble(p.landLatitudeController)) {
      debugPrint("❌ Land Latitude invalid");
      return false;
    }
    if (!_validDouble(p.landLonitudeController)) {
      debugPrint("❌ Land Longitude invalid");
      return false;
    }

    // ---------- Land details ----------
    if (!_hasText(p.landAreaController)) {
      debugPrint("❌ Land Area missing");
      return false;
    }
    if (p.rentLeaseOption?.isEmpty ?? true) {
      debugPrint("❌ Rent / Lease option missing");
      return false;
    }
    if (!_hasText(p.landRateontroller)) {
      debugPrint("❌ Land Rate missing");
      return false;
    }

    // ---------- Substation master ----------
    if (!_validId(p.selectedsubstationDistrict)) {
      debugPrint("❌ Substation District invalid");
      return false;
    }
    if (!_validId(p.selectedsubstationTaluka)) {
      debugPrint("❌ Substation Taluka invalid");
      return false;
    }
    if (!_validId(p.selectedsubstationVillage)) {
      debugPrint("❌ Substation Village invalid");
      return false;
    }

    // ---------- Substation location ----------
    if (!_validDouble(p.subStationLatitudeController)) {
      debugPrint("❌ Substation Latitude invalid");
      return false;
    }
    if (!_validDouble(p.subStationLongitudeController)) {
      debugPrint("❌ Substation Longitude invalid");
      return false;
    }

    // ---------- Substation details ----------
    if (!_hasText(p.subStationNameController)) {
      debugPrint("❌ Substation Name missing");
      return false;
    }
    if (!_hasText(p.subStationInchargeNameController)) {
      debugPrint("❌ Incharge Name missing");
      return false;
    }
    if (!_hasText(p.subStationInchargeContactController)) {
      debugPrint("❌ Incharge Contact missing");
      return false;
    }
    if (!_hasText(p.subStationOperatorNameController)) {
      debugPrint("❌ Operator Name missing");
      return false;
    }
    if (!_hasText(p.subStationOperatorContactController)) {
      debugPrint("❌ Operator Contact missing");
      return false;
    }
    if (!_hasText(p.subStationVoltageLevelController)) {
      debugPrint("❌ Voltage Level missing");
      return false;
    }
    if (!_hasText(p.subStationCapacityController)) {
      debugPrint("❌ Capacity missing");
      return false;
    }
    if (!_hasText(p.subStationDistancebtwLandController)) {
      debugPrint("❌ Distance between land missing");
      return false;
    }
    if (!_hasText(p.subStationDistancebtwPlotController)) {
      debugPrint("❌ Distance between plot missing");
      return false;
    }

    // ---------- Environmental ----------
    if (!_hasText(p.otherEvacuationController)) {
      debugPrint("❌ Other Evacuation missing");
      return false;
    }
    if (!_hasText(p.windZoneController)) {
      debugPrint("❌ Wind Zone missing");
      return false;
    }
    if (!_hasText(p.groundWaterController)) {
      debugPrint("❌ Ground Water missing");
      return false;
    }
    if (!_hasText(p.typeofSoilController)) {
      debugPrint("❌ Type of Soil missing");
      return false;
    }
    if (!_hasText(p.nearestHighwayController)) {
      debugPrint("❌ Nearest Highway missing");
      return false;
    }

    // ---------- Media ----------
    if (!_hasList(p.OtherLandmediaFiles)) {
      debugPrint("❌ Other Land media missing");
      return false;
    }

    debugPrint("✅ Survey is complete");
    return true;
  }

  // bool isSurveyComplete(BasicFormProvider p) {
  //   return
  //       // ---------- Land master ----------
  //       _validId(p.selectedLandState) &&
  //           _validId(p.selectedLandDistrict) &&
  //           _validId(p.selectedLandTaluka) &&
  //           _validId(p.selectedLandVillage) &&

  //           // ---------- Land location ----------
  //           _validDouble(p.landLatitudeController) &&
  //           _validDouble(p.landLonitudeController) &&

  //           // ---------- Land details ----------
  //           _hasText(p.landAreaController) &&
  //           (p.rentLeaseOption?.isNotEmpty ?? false) &&
  //           _hasText(p.landRateontroller) &&

  //           // ---------- Substation master ----------
  //           _validId(p.selectedsubstationDistrict) &&
  //           _validId(p.selectedsubstationTaluka) &&
  //           _validId(p.selectedsubstationVillage) &&

  //           // ---------- Substation location ----------
  //           _validDouble(p.subStationLatitudeController) &&
  //           _validDouble(p.subStationLongitudeController) &&

  //           // ---------- Substation details ----------
  //           _hasText(p.subStationNameController) &&
  //           _hasText(p.subStationInchargeNameController) &&
  //           _hasText(p.subStationInchargeContactController) &&
  //           _hasText(p.subStationOperatorNameController) &&
  //           _hasText(p.subStationOperatorContactController) &&
  //           _hasText(p.subStationVoltageLevelController) &&
  //           _hasText(p.subStationCapacityController) &&
  //           _hasText(p.subStationDistancebtwLandController) &&
  //           _hasText(p.subStationDistancebtwPlotController) &&

  //           // ---------- Environmental ----------
  //           _hasText(p.otherEvacuationController) &&
  //           _hasText(p.windZoneController) &&
  //           _hasText(p.groundWaterController) &&
  //           _hasText(p.typeofSoilController) &&
  //           _hasText(p.nearestHighwayController) &&

  //           // ---------- Media ----------
  //           _hasList(p.OtherLandmediaFiles);
  // }

  bool _hasText(TextEditingController c) => c.text.trim().isNotEmpty;

  bool _validId(Map<String, dynamic>? m) =>
      m != null && m['id'] != null && m['id'].toString().isNotEmpty;
  //  &&
  // m['id'].toString() != '-1';

  bool _validDouble(TextEditingController c) {
    final v = double.tryParse(c.text);
    return v != null && v != 0.0;
  }

  bool _hasList(List list) => list.isNotEmpty;

  bool getIsCurrentStepValid() {
    final provider = Provider.of<BasicFormProvider>(context, listen: false);

    switch (currentStep) {
      case 1:
        return provider.isBasicFormValid;
      case 2:
        return provider.isSubstaionFormValid;
      case 3:
        return provider.isOtherFormValid;
      case 4:
        return provider.isBasicFormValid;
      // case 5:
      //   return provider.isBasicFormValid;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final basicFormProvider = Provider.of<BasicFormProvider>(context, listen: false);
    return Scaffold(
      appBar: CommonAppBar(
        title: t(context, "add_survey"),
        isCloseIconVisible: true,
      ),
      backgroundColor: CommonColors.white,
      body: CustomScrollView(
        slivers: [
          /// Sticky Stepper
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              currentStep: currentStep,
              child: Container(
                color: CommonColors.white,
                // padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: StepProgressBar(
                  currentStep: currentStep,
                  steps: const ['', '', '', '', ''],
                ),
              ),
            ),
          ),

          /// Form content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: StepForm(currentStep: currentStep),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<BasicFormProvider>(
        builder: (context, basicFormProvider, _) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 22),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      // print(basicFormProvider.mediaFile!.path);
                      if (widget.isEdit == 1) {
                        print("ISEDIT Save & EXIT");
                        // LAND PICTURES
                        List<SurveyMediaModel> landPictures =
                            basicFormProvider.OtherLandmediaFiles.where(
                                    (file) =>
                                        file != null) // keep only non-null
                                .map((file) => SurveyMediaModel(
                                      surveyLocalId:
                                          0, // set after inserting survey
                                      mediaType: 'land',
                                      localPath: file!.path,
                                      isSynced: 0, // not synced yet
                                    ))
                                .toList();

// SURVEY FORMS (single file example)
                        List<SurveyMediaModel> surveyForms =
                            basicFormProvider.surveyFormsmediaFile != null
                                ? [
                                    SurveyMediaModel(
                                      surveyLocalId:
                                          0, // set after inserting survey
                                      mediaType: 'survey',
                                      localPath: basicFormProvider
                                          .surveyFormsmediaFile!.path,
                                      isSynced: 0,
                                    )
                                  ]
                                : [];
                        SurveyModel survey = SurveyModel(
                            surveyId: widget.surveyListing!.surveyId.toString() ??
                                "", // never null
                            userId: "1",
                            landState: basicFormProvider.selectedLandState?['name'] ??
                                "",
                            landDistrict: basicFormProvider
                                    .selectedLandDistrict?['district_name'] ??
                                "",
                            landTaluka:
                                basicFormProvider.selectedLandTaluka!['taluka_name'] ??
                                    "",
                            landVillage: basicFormProvider
                                    .selectedLandVillage!['village_name'] ??
                                "",
                            landDistrictID:
                                basicFormProvider.selectedLandDistrict!['id'],
                            landTalukaID:
                                basicFormProvider.selectedLandTaluka!['id'] ??
                                    "",
                            landVillageID:
                                basicFormProvider.selectedLandVillage!['id'] ??
                                    "",
                            substationDistrictID:
                                basicFormProvider.selectedsubstationDistrict!['id'] ??
                                    "",
                            substationTalukaID:
                                basicFormProvider.selectedsubstationTaluka!['id'] ?? "",
                            substationVillageID: basicFormProvider.selectedsubstationVillage!['id'] ?? "",
                            landLatitude: basicFormProvider.landLatitudeController.text.isEmpty ? 0.0 : double.parse(basicFormProvider.landLatitudeController.text),
                            landLongitude: basicFormProvider.landLonitudeController.text.isEmpty ? 0.0 : double.parse(basicFormProvider.landLonitudeController.text),
                            landAreaInAcres: basicFormProvider.landAreaController.text ?? "",
                            landType: basicFormProvider.rentLeaseOption ?? "",
                            landRateCommercialEscalation: basicFormProvider.landRateontroller.text ?? "",
                            subStationName: basicFormProvider.subStationNameController.text ?? "",
                            subStationDistrict: basicFormProvider.selectedsubstationDistrict!['district_name'] ?? "",
                            subStationTaluka: basicFormProvider.selectedsubstationTaluka!['taluka_name'] ?? "",
                            subStationVillage: basicFormProvider.selectedsubstationVillage!['village_name'] ?? "",
                            subStationLatitude: basicFormProvider.subStationLatitudeController.text.isEmpty ? 0.0 : double.parse(basicFormProvider.subStationLatitudeController.text),
                            subStationLongitude: basicFormProvider.subStationLongitudeController.text.isEmpty ? 0.0 : double.parse(basicFormProvider.subStationLongitudeController.text),
                            inchargeName: basicFormProvider.subStationInchargeNameController.text ?? "",
                            subStationInchargeContact: basicFormProvider.subStationInchargeContactController.text ?? "",
                            operatorName: basicFormProvider.subStationOperatorNameController.text ?? "",
                            operatorContact: basicFormProvider.subStationOperatorContactController.text ?? "",
                            subStationVoltageLevel: basicFormProvider.subStationVoltageLevelController.text ?? "",
                            subStationCapacity: basicFormProvider.subStationCapacityController.text ?? "",
                            distanceSubStationToLand: basicFormProvider.subStationDistancebtwLandController.text ?? "",
                            plotDistanceFromMainRoad: basicFormProvider.subStationDistancebtwPlotController.text ?? "",
                            evacuationLevel: basicFormProvider.otherEvacuationController.text ?? "",
                            windZone: basicFormProvider.windZoneController.text ?? "",
                            groundWaterRainFall: basicFormProvider.groundWaterController.text ?? "",
                            soilType: basicFormProvider.typeofSoilController.text ?? "",
                            nearestHighway: basicFormProvider.nearestHighwayController.text ?? "",
                            // surveyForms: basicFormProvider.surveyFormsmediaFile != null ? [basicFormProvider.surveyFormsmediaFile!.path] : [],
                            // landPictures: basicFormProvider.OtherLandmediaFiles.where((file) => file != null) // keep only non-null
                            //     .map((file) => file!.path) // extract paths
                            //     .toList(),
                            landPictures: landPictures,
                            surveyForms: surveyForms,
                            consentForms: [],
                            isSurveyapproved: 0,
                            consentAvailable: 0,
                            isSync: 0,
                            serverSynced: widget.surveyListing!.serverSynced,
                            selectedLanguage: Provider.of<AppProvider>(context, listen: false).currentLanguage,
                            surveyDate: widget.surveyListing!.surveyDate,
                            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
                            surveyStatus: CommonStrings.strPending);
                        print(
                            "Survey : ${widget.surveyListing!.id.toString()}");

                        final updatedRows = await DatabaseHelper.instance
                            .updateSurvey(survey, widget.surveyListing!.id!);
                        await DatabaseHelper.instance.insertSurveyMediaList(
                          surveyLocalId: int.parse(survey.surveyId.toString()),

                          landPictures: basicFormProvider.OtherLandmediaFiles
                                  .whereType<File>()
                              .toList(),

                          surveyForms:
                              basicFormProvider.surveyFormsmediaFile != null
                                  ? [basicFormProvider.surveyFormsmediaFile!]
                                  : [],

                          consentForms: [], // not available at creation time
                        );
                        print("Survey : ${survey.surveyId}");
                        print("Survey : ${survey.isSurveyapproved}");
                        if (updatedRows > 0) {
                          print("✅ Survey updated successfully");
                        } else {
                          print("⚠️ No survey found to update");
                        }

                        // routeGlobalKey.currentState?.pop(survey);

//                         if (!mounted) return; // safety check
// Navigator.of(context).pop(survey);
                        // Navigator.of(context).pop(survey);

                        //  Navigator.of(context).pop(survey);
                        // Navigator.pop(context, true,);
                      } else {
                        print("ISEDIT  0 Save & EXIT");
                        final now = DateTime.now();
                        // LAND PICTURES
                        List<SurveyMediaModel> landPictures =
                            basicFormProvider.OtherLandmediaFiles.where(
                                    (file) =>
                                        file != null) // keep only non-null
                                .map((file) => SurveyMediaModel(
                                      surveyLocalId:
                                          0, // set after inserting survey
                                      mediaType: 'land',
                                      localPath: file!.path,
                                      isSynced: 0, // not synced yet
                                    ))
                                .toList();

// SURVEY FORMS (single file example)
                        List<SurveyMediaModel> surveyForms =
                            basicFormProvider.surveyFormsmediaFile != null
                                ? [
                                    SurveyMediaModel(
                                      surveyLocalId:
                                          0, // set after inserting survey
                                      mediaType: 'survey',
                                      localPath: basicFormProvider
                                          .surveyFormsmediaFile!.path,
                                      isSynced: 0,
                                    )
                                  ]
                                : [];
                        SurveyModel survey = SurveyModel(
                            surveyId:
                                await generateSurveyId() ?? "", // never null
                            userId: "1",
                            landState: basicFormProvider.selectedLandState?['name'] ??
                                "",
                            landDistrict: (basicFormProvider.selectedLandDistrict == null ||
                                    basicFormProvider
                                        .selectedLandDistrict!['id']!.isEmpty)
                                ? ""
                                : basicFormProvider.selectedLandDistrict![
                                    'district_name'], //  basicFormProvider.selectedLandDistrict!['name'].toString() ??
                            //     "",
                            landTaluka: (basicFormProvider.selectedLandTaluka == null || basicFormProvider.selectedLandTaluka!['id']!.isEmpty)
                                ? ""
                                : basicFormProvider
                                    .selectedLandTaluka!['taluka_name'],
                            landVillage:
                                (basicFormProvider.selectedLandVillage == null ||
                                        basicFormProvider
                                            .selectedLandVillage!['id']!
                                            .isEmpty)
                                    ? ""
                                    : basicFormProvider
                                        .selectedLandVillage!['village_name'],
                            landLatitude: basicFormProvider
                                    .landLatitudeController.text.isEmpty
                                ? 0.0
                                : double.parse(basicFormProvider.landLatitudeController.text),
                            landLongitude: basicFormProvider.landLonitudeController.text.isEmpty ? 0.0 : double.parse(basicFormProvider.landLonitudeController.text),
                            landAreaInAcres: basicFormProvider.landAreaController.text ?? "",
                            landType: basicFormProvider.rentLeaseOption ?? "",
                            landRateCommercialEscalation: basicFormProvider.landRateontroller.text ?? "",
                            subStationName: basicFormProvider.subStationNameController.text ?? "",
                            subStationDistrict: (basicFormProvider.selectedsubstationDistrict == null || basicFormProvider.selectedsubstationDistrict!['id']!.isEmpty) ? "" : basicFormProvider.selectedsubstationDistrict!['district_name'],
                            landDistrictID: basicFormProvider.selectedLandDistrict!['id'],
                            landTalukaID: basicFormProvider.selectedLandTaluka!['id'] ?? "",
                            landVillageID: basicFormProvider.selectedLandVillage!['id'] ?? "",
                            substationDistrictID: basicFormProvider.selectedsubstationDistrict!['id'] ?? "",
                            substationTalukaID: basicFormProvider.selectedsubstationTaluka!['id'] ?? "",
                            substationVillageID: basicFormProvider.selectedsubstationVillage!['id'] ?? "",
                            subStationTaluka: (basicFormProvider.selectedsubstationTaluka == null || basicFormProvider.selectedsubstationTaluka!['id']!.isEmpty) ? "" : basicFormProvider.selectedsubstationTaluka!['taluka_name'] ?? "",
                            subStationVillage: (basicFormProvider.selectedsubstationVillage == null || basicFormProvider.selectedsubstationVillage!['id']!.isEmpty) ? "" : basicFormProvider.selectedsubstationVillage!['village_name'] ?? "",
                            subStationLatitude: basicFormProvider.subStationLatitudeController.text.isEmpty ? 0.0 : double.parse(basicFormProvider.subStationLatitudeController.text),
                            subStationLongitude: basicFormProvider.subStationLongitudeController.text.isEmpty ? 0.0 : double.parse(basicFormProvider.subStationLongitudeController.text),
                            inchargeName: basicFormProvider.subStationInchargeNameController.text ?? "",
                            subStationInchargeContact: basicFormProvider.subStationInchargeContactController.text ?? "",
                            operatorName: basicFormProvider.subStationOperatorNameController.text ?? "",
                            operatorContact: basicFormProvider.subStationOperatorContactController.text ?? "",
                            subStationVoltageLevel: basicFormProvider.subStationVoltageLevelController.text ?? "",
                            subStationCapacity: basicFormProvider.subStationCapacityController.text ?? "",
                            distanceSubStationToLand: basicFormProvider.subStationDistancebtwLandController.text ?? "",
                            plotDistanceFromMainRoad: basicFormProvider.subStationDistancebtwPlotController.text ?? "",
                            evacuationLevel: basicFormProvider.otherEvacuationController.text ?? "",
                            windZone: basicFormProvider.windZoneController.text ?? "",
                            groundWaterRainFall: basicFormProvider.groundWaterController.text ?? "",
                            soilType: basicFormProvider.typeofSoilController.text ?? "",
                            nearestHighway: basicFormProvider.nearestHighwayController.text ?? "",
                            // surveyForms: basicFormProvider.surveyFormsmediaFile != null ? [basicFormProvider.surveyFormsmediaFile!.path] : [],
                            // landPictures: basicFormProvider.OtherLandmediaFiles.where((file) => file != null) // keep only non-null
                            //     .map((file) => file!.path) // extract paths
                            //     .toList(),
                            landPictures: landPictures,
                            surveyForms: surveyForms,
                            consentForms: [],
                            isSurveyapproved: 0,
                            consentAvailable: 0,
                            isSync: 0,
                            serverSynced: 0,
                            selectedLanguage: Provider.of<AppProvider>(context, listen: false).currentLanguage,
                            surveyDate: DateTime.now().millisecondsSinceEpoch,
                            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
                            surveyStatus: CommonStrings.strPending);

                        final int surveyLocalId =
                            await DatabaseHelper.instance.insertSurvey(survey);
                        print("✅ Survey saved locally");
                        print("Survey : ${survey.surveyId}");
                        print("Survey : ${survey.isSurveyapproved}");
                        await DatabaseHelper.instance.insertSurveyMediaList(
                          surveyLocalId: surveyLocalId,

                          landPictures: basicFormProvider.OtherLandmediaFiles
                                  .whereType<File>()
                              .toList(),

                          surveyForms:
                              basicFormProvider.surveyFormsmediaFile != null
                                  ? [basicFormProvider.surveyFormsmediaFile!]
                                  : [],

                          consentForms: [], // not available at creation time
                        );

                        print(
                            "✅ Media inserted for surveysave_exit  $surveyLocalId");
                      }

                      //                       List<SurveyModel> surveys =
                      //                           await DatabaseHelper.instance.getAllSurveys();
                      // // for (var survey in surveys) {
                      //                       print("Survey : ${surveys.length}");

                      //                       final db = await DatabaseHelper.instance.database;
                      //                       final List<Map<String, dynamic>> maps =
                      //                           await db.query('surveys');
                      //                       print(maps); // prints all rows in console

                      Navigator.pop(context, true);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(
                        color: CommonColors.bluishGreenMoreGreen,
                        width: 0.4,
                      ),
                    ),
                    child: Text(
                      t(context, "save_exit"),
                      style: TextStyle(
                          color: CommonColors.blackshade,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (currentStep > 1) ...[
                  OutlinedButton(
                    onPressed: prevStep,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(
                        color: CommonColors.bluishGreenMoreGreen,
                        width: 0.4,
                      ),
                    ),
                    child: Text(
                      t(context, "previous"),
                      style: TextStyle(
                          color: CommonColors.blackshade,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getIsCurrentStepValid()
                          ? CommonColors.bluishGreenMoreGreen
                          : CommonColors.greyButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: getIsCurrentStepValid() ? nextStep : null,
                    child: Text(
                      currentStep == 4
                          ? t(context, "submit")
                          : t(context, "continue"),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<String> generateSurveyId() async {
  final db = await DatabaseHelper.instance.database;
  final now = DateTime.now();
  final yearMonth =
      int.parse('${now.year}${now.month.toString().padLeft(2, '0')}');

  // Check if a sequence already exists for this yearMonth
  final seqResult = await db.query(
    'survey_sequence',
    where: 'yearMonth = ?',
    whereArgs: [yearMonth],
  );

  int nextSeq;
  if (seqResult.isEmpty) {
    // First survey for this month
    nextSeq = 1;
    await db.insert('survey_sequence', {
      'yearMonth': yearMonth,
      'lastSeq': nextSeq,
    });
  } else {
    // Increment last sequence
    final lastSeq = seqResult.first['lastSeq'] as int;
    nextSeq = lastSeq + 1;
    await db.update(
      'survey_sequence',
      {'lastSeq': nextSeq},
      where: 'yearMonth = ?',
      whereArgs: [yearMonth],
    );
  }

  // Construct surveyId like 202509001
  final surveyId = '$yearMonth${nextSeq.toString().padLeft(3, '0')}';
  return surveyId;
}

// Future<String> generateSurveyId(DatabaseHelper db) async {
//   int yearMonth = int.parse(
//       "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}");

//   final seqResult = await db.query('survey_sequence',
//       where: 'yearMonth = ?', whereArgs: [yearMonth]);

//   int nextSeq = 1;
//   if (seqResult.isNotEmpty) {
//     nextSeq = (seqResult.first['lastSeq'] as int) + 1;
//     await db.update('survey_sequence', {'lastSeq': nextSeq},
//         where: 'yearMonth = ?', whereArgs: [yearMonth]);
//   } else {
//     await db.insert('survey_sequence', {'yearMonth': yearMonth, 'lastSeq': nextSeq});
//   }

//   return "$yearMonth${nextSeq.toString().padLeft(3, '0')}";
// }

// Future<String> generateSurveyId() async {
//   int yearMonth = int.parse(
//       "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}"); // 202509

//   // Get max existing surveyId for current yearMonth
//   final result = await DatabaseHelper.instance.rawQuery(
//       'SELECT surveyId FROM surveys WHERE surveyId LIKE ? ORDER BY surveyId DESC LIMIT 1',
//       ['$yearMonth%']);

//   int nextSeq = 1;
//   if (result.isNotEmpty) {
//     // Extract last 3 digits as sequence number
//     final lastSurveyId = result.first['surveyId'] as String;
//     int lastSeq = int.parse(lastSurveyId.substring(6)); // YYYYMMXXX
//     nextSeq = lastSeq + 1;
//   }

//   String newSurveyId =
//       "$yearMonth${nextSeq.toString().padLeft(3, '0')}"; // e.g., 202509004
//   return newSurveyId;
// }

// Future<String> generateSurveyId() async {
//   final now = DateTime.now();
//   final yearMonth =
//       "${now.year}${now.month.toString().padLeft(2, '0')}"; // e.g., 202510

//   // Get the last survey ID for the current month
//   final List<Map<String, dynamic>> result =
//       await DatabaseHelper.instance.rawQuery(
//     "SELECT surveyId FROM surveys WHERE surveyId LIKE ? ORDER BY surveyId DESC LIMIT 1",
//     ['$yearMonth%'],
//   );

//   int nextNumber = 1; // default first number

//   if (result.isNotEmpty) {
//     final lastId = result.first['surveyId'] as String;
//     // Extract last 3 digits
//     final lastNumber = int.parse(lastId.substring(6));
//     nextNumber = lastNumber + 1;
//   }

//   // Return new ID in YYYYMMXXX format
//   return "$yearMonth${nextNumber.toString().padLeft(3, '0')}";
// }

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final int currentStep;

  _StickyHeaderDelegate({
    required this.child,
    required this.currentStep,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 28;

  @override
  double get minExtent => 28;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.currentStep != currentStep;
  }
}
