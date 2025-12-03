import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/StepForm.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonstrings.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';

import 'package:hyworth_land_survey/widgets/CommonAppBar.dart';
import 'package:hyworth_land_survey/widgets/StepProgressBar.dart';
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
      provider.landStateController,
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
      provider.selectedLandDistrict = {
        'id': widget.surveyListing!.landDistrictID!,
        'name': widget.surveyListing!.landDistrict!,
      };
      // provider.landTalukaController.text = widget.surveyListing!.landTaluka!;
      provider.selectedLandTaluka = {
        'id': widget.surveyListing!.landTalukaID!,
        'name': widget.surveyListing!.landTaluka!,
      };
      provider.landLatitudeController.text =
          widget.surveyListing!.landLatitude!.toString();
      provider.landLonitudeController.text =
          widget.surveyListing!.landLongitude!.toString();
      provider.landStateController.text =
          (widget.surveyListing!.landState == null ||
                  widget.surveyListing!.landState == "")
              ? ""
              : widget.surveyListing!.landState!;
      // provider.landVillageController.text =
      //     widget.surveyListing!.landVillage! ?? "";
      provider.selectedLandVillage = {
        'id': widget.surveyListing!.landVillageID!,
        'name': widget.surveyListing!.landVillage!,
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
        'name': widget.surveyListing!.subStationDistrict!,
      };
      // provider.subStationTalukaController.text =
      //     widget.surveyListing!.subStationTaluka!;
      provider.selectedsubstationTaluka = {
        'id': widget.surveyListing!.substationTalukaID!,
        'name': widget.surveyListing!.subStationTaluka!,
      };
      // provider.subStationVillageController.text =
      //     widget.surveyListing!.subStationVillage!;
      provider.selectedsubstationVillage = {
        'id': widget.surveyListing!.substationVillageID!,
        'name': widget.surveyListing!.subStationVillage!,
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

      // provider.mediaFile=widget.surveyListing!.surveyForms[0];
      if (widget.surveyListing!.surveyForms != null &&
          widget.surveyListing!.surveyForms!.isNotEmpty) {
        // assign to provider
        context.read<BasicFormProvider>().mediaFile = File(
            widget.surveyListing!.surveyForms![0]); // convert path back to File
        provider.setImage(File(widget.surveyListing!.surveyForms![0]));
      }

      // Assuming landPictures is a List<String> of file paths
      if (widget.surveyListing?.landPictures != null &&
          widget.surveyListing!.landPictures!.isNotEmpty) {
        final provider = context.read<BasicFormProvider>();
        print("LAND PICTURE");
        print(widget.surveyListing!.landPictures!.length);
        for (int i = 0; i < widget.surveyListing!.landPictures!.length; i++) {
          if (i < provider.mediaFiles.length) {
            // Convert path string to File
            final file = File(widget.surveyListing!.landPictures![i]);

            // Assign to mediaFiles list
            provider.mediaFiles[i] = file;

            // If your provider manages these images, set them too
            provider.setMediaFile(i, file);
          }
        }
      }
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
        SurveyModel survey = SurveyModel(
            surveyId:
                widget.surveyListing!.surveyId.toString() ?? "", // never null
            userId: "1",
            landState: basicFormProvider.landStateController.text ?? "",
            landDistrict: basicFormProvider.selectedLandDistrict!['name'],
            landTaluka: basicFormProvider.selectedLandTaluka!['name'] ?? "",
            landVillage: basicFormProvider.selectedLandVillage!['name'] ?? "",
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
            subStationDistrict:
                basicFormProvider.selectedsubstationDistrict!['name'] ?? "",
            subStationTaluka:
                basicFormProvider.selectedsubstationTaluka!['name'] ?? "",
            subStationVillage:
                basicFormProvider.selectedsubstationVillage!['name'] ?? "",
              
            subStationLatitude:
                basicFormProvider.subStationLatitudeController.text.isEmpty
                    ? 0.0
                    : double.parse(
                        basicFormProvider.subStationLatitudeController.text),
            subStationLongitude:
                basicFormProvider.subStationLongitudeController.text.isEmpty
                    ? 0.0
                    : double.parse(
                        basicFormProvider.subStationLongitudeController.text),
            inchargeName:
                basicFormProvider.subStationInchargeNameController.text ?? "",
            subStationInchargeContact:
                basicFormProvider.subStationInchargeContactController.text ??
                    "",
            operatorName:
                basicFormProvider.subStationOperatorNameController.text ?? "",
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
            surveyForms: basicFormProvider.mediaFile != null ? [basicFormProvider.mediaFile!.path] : [],
            landPictures: basicFormProvider.mediaFiles
                .where((file) => file != null) // keep only non-null
                .map((file) => file!.path) // extract paths
                .toList(),
            isSync: 0,
            isSurveyapproved: 0,
            consentAvailable: 0,
            selectedLanguage: Provider.of<AppProvider>(context, listen: false).currentLanguage,
            surveyDate: widget.surveyListing!.surveyDate,
            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
            surveyStatus: CommonStrings.strPending);
        final updatedRows = await DatabaseHelper.instance
            .updateSurvey(survey, widget.surveyListing!.id!);
        print("Survey : ${survey.surveyId}");
        print("Survey : ${survey.isSurveyapproved}");
        if (updatedRows > 0) {
          print("✅ Survey updated successfully");
        } else {
          print("⚠️ No survey found to update");
        }
        // Navigator.pop(context, true);
      } else {
        print("ISEDIT 0 Last Button Save & EXIT");
        SurveyModel survey = SurveyModel(
            surveyId: await generateSurveyId() ?? "", // never null
            userId: "1",
            landState: basicFormProvider.landStateController.text ?? "",
            landDistrict: basicFormProvider.selectedLandDistrict!['name'] ?? "",
            landTaluka: basicFormProvider.selectedLandTaluka!['name'] ?? "",
            landVillage: basicFormProvider.selectedLandVillage!['name'] ?? "",
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
            subStationDistrict:
                basicFormProvider.selectedsubstationDistrict!['name'] ?? "",
            subStationTaluka:
                basicFormProvider.selectedsubstationTaluka!['name'] ?? "",
            subStationVillage:
                basicFormProvider.selectedsubstationVillage!['name'] ?? "",
                landDistrictID: basicFormProvider.selectedLandDistrict!['id'],
            landTalukaID: basicFormProvider.selectedLandTaluka!['id'] ?? "",
            landVillageID: basicFormProvider.selectedLandVillage!['id'] ?? "",
               substationDistrictID:
                basicFormProvider.selectedsubstationDistrict!['id'] ?? "",
            substationTalukaID:
                basicFormProvider.selectedsubstationTaluka!['id'] ?? "",
            substationVillageID:
                basicFormProvider.selectedsubstationVillage!['id'] ?? "",
            subStationLatitude:
                basicFormProvider.subStationLatitudeController.text.isEmpty
                    ? 0.0
                    : double.parse(
                        basicFormProvider.subStationLatitudeController.text),
            subStationLongitude:
                basicFormProvider.subStationLongitudeController.text.isEmpty
                    ? 0.0
                    : double.parse(
                        basicFormProvider.subStationLongitudeController.text),
            inchargeName:
                basicFormProvider.subStationInchargeNameController.text ?? "",
            subStationInchargeContact:
                basicFormProvider.subStationInchargeContactController.text ??
                    "",
            operatorName:
                basicFormProvider.subStationOperatorNameController.text ?? "",
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
            surveyForms: basicFormProvider.mediaFile != null ? [basicFormProvider.mediaFile!.path] : [],
            landPictures: basicFormProvider.mediaFiles
                .where((file) => file != null) // keep only non-null
                .map((file) => file!.path) // extract paths
                .toList(),
            isSurveyapproved: 0,
            consentAvailable: 0,
            isSync: 0,
            selectedLanguage: Provider.of<AppProvider>(context, listen: false).currentLanguage,
            surveyDate: DateTime.now().millisecondsSinceEpoch,
            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
            surveyStatus: CommonStrings.strPending);
        await DatabaseHelper.instance.insertSurvey(survey);
        print("✅ Survey saved locally");
        print("Survey : ${survey.surveyId}");
        print("Survey : ${survey.isSurveyapproved}");
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
                        SurveyModel survey = SurveyModel(
                            surveyId: widget.surveyListing!.surveyId.toString() ??
                                "", // never null
                            userId: "1",
                            landState:
                                basicFormProvider.landStateController.text ??
                                    "",
                            landDistrict: basicFormProvider
                                    .selectedLandDistrict?['name'] ??
                                "",
                            landTaluka:
                                basicFormProvider.selectedLandTaluka!['name'] ??
                                    "",
                            landVillage:
                                basicFormProvider.selectedLandVillage!['name'] ??
                                    "",
                                    landDistrictID: basicFormProvider.selectedLandDistrict!['id'],
            landTalukaID: basicFormProvider.selectedLandTaluka!['id'] ?? "",
            landVillageID: basicFormProvider.selectedLandVillage!['id'] ?? "",
               substationDistrictID:
                basicFormProvider.selectedsubstationDistrict!['id'] ?? "",
            substationTalukaID:
                basicFormProvider.selectedsubstationTaluka!['id'] ?? "",
            substationVillageID:
                basicFormProvider.selectedsubstationVillage!['id'] ?? "",
                            landLatitude: basicFormProvider
                                    .landLatitudeController.text.isEmpty
                                ? 0.0
                                : double.parse(basicFormProvider
                                    .landLatitudeController.text),
                            landLongitude: basicFormProvider
                                    .landLonitudeController.text.isEmpty
                                ? 0.0
                                : double.parse(
                                    basicFormProvider.landLonitudeController.text),
                            landAreaInAcres: basicFormProvider.landAreaController.text ?? "",
                            landType: basicFormProvider.rentLeaseOption ?? "",
                            landRateCommercialEscalation: basicFormProvider.landRateontroller.text ?? "",
                            subStationName: basicFormProvider.subStationNameController.text ?? "",
                            subStationDistrict: basicFormProvider.selectedsubstationDistrict!['name'] ?? "",
                            subStationTaluka: basicFormProvider.selectedsubstationTaluka!['name'] ?? "",
                            subStationVillage: basicFormProvider.selectedsubstationVillage!['name'] ?? "",
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
                            surveyForms: basicFormProvider.mediaFile != null ? [basicFormProvider.mediaFile!.path] : [],
                            landPictures: basicFormProvider.mediaFiles
                                .where((file) => file != null) // keep only non-null
                                .map((file) => file!.path) // extract paths
                                .toList(),
                            isSurveyapproved: 0,
                            consentAvailable: 0,
                            isSync: 0,
                            selectedLanguage: Provider.of<AppProvider>(context, listen: false).currentLanguage,
                            surveyDate: widget.surveyListing!.surveyDate,
                            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
                            surveyStatus: CommonStrings.strPending);
                        print(
                            "Survey : ${widget.surveyListing!.id.toString()}");

                        final updatedRows = await DatabaseHelper.instance
                            .updateSurvey(survey, widget.surveyListing!.id!);
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
                        SurveyModel survey = SurveyModel(
                            surveyId:
                                await generateSurveyId() ?? "", // never null
                            userId: "1",
                            landState: basicFormProvider.landStateController.text ??
                                "",
                            landDistrict:
                                (basicFormProvider.selectedLandDistrict == null ||
                                        basicFormProvider
                                            .selectedLandDistrict!['id']!
                                            .isEmpty)
                                    ? ""
                                    : basicFormProvider.selectedLandDistrict![
                                        'name'], //  basicFormProvider.selectedLandDistrict!['name'].toString() ??
                            //     "",
                            landTaluka:
                                 (basicFormProvider.selectedLandTaluka == null ||
                                        basicFormProvider
                                            .selectedLandTaluka!['id']!
                                            .isEmpty)
                                    ? ""
                                    : basicFormProvider.selectedLandTaluka![
                                        'name'],
                            landVillage:
                                 (basicFormProvider.selectedLandVillage == null ||
                                        basicFormProvider
                                            .selectedLandVillage!['id']!
                                            .isEmpty)
                                    ? ""
                                    : basicFormProvider.selectedLandVillage![
                                        'name'],
                            landLatitude:
                                basicFormProvider.landLatitudeController.text.isEmpty
                                    ? 0.0
                                    : double.parse(basicFormProvider
                                        .landLatitudeController.text),
                            landLongitude: basicFormProvider
                                    .landLonitudeController.text.isEmpty
                                ? 0.0
                                : double.parse(basicFormProvider.landLonitudeController.text),
                            landAreaInAcres: basicFormProvider.landAreaController.text ?? "",
                            landType: basicFormProvider.rentLeaseOption ?? "",
                            landRateCommercialEscalation: basicFormProvider.landRateontroller.text ?? "",
                            subStationName: basicFormProvider.subStationNameController.text ?? "",
                            subStationDistrict:  (basicFormProvider.selectedsubstationDistrict == null ||
                                        basicFormProvider
                                            .selectedsubstationDistrict!['id']!
                                            .isEmpty)
                                    ? ""
                                    : basicFormProvider.selectedsubstationDistrict![
                                        'name'],
                                        landDistrictID: basicFormProvider.selectedLandDistrict!['id'],
            landTalukaID: basicFormProvider.selectedLandTaluka!['id'] ?? "",
            landVillageID: basicFormProvider.selectedLandVillage!['id'] ?? "",
               substationDistrictID:
                basicFormProvider.selectedsubstationDistrict!['id'] ?? "",
            substationTalukaID:
                basicFormProvider.selectedsubstationTaluka!['id'] ?? "",
            substationVillageID:
                basicFormProvider.selectedsubstationVillage!['id'] ?? "",
                            subStationTaluka:  (basicFormProvider.selectedsubstationTaluka == null ||
                                        basicFormProvider
                                            .selectedsubstationTaluka!['id']!
                                            .isEmpty)
                                    ? ""
                                    : basicFormProvider.selectedsubstationTaluka![
                                        'name'] ?? "",
                            subStationVillage:  (basicFormProvider.selectedsubstationVillage == null ||
                                        basicFormProvider
                                            .selectedsubstationVillage!['id']!
                                            .isEmpty)
                                    ? ""
                                    : basicFormProvider.selectedsubstationVillage![
                                        'name']?? "",
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
                            surveyForms: basicFormProvider.mediaFile != null ? [basicFormProvider.mediaFile!.path] : [],
                            landPictures: basicFormProvider.mediaFiles
                                .where((file) => file != null) // keep only non-null
                                .map((file) => file!.path) // extract paths
                                .toList(),
                            isSurveyapproved: 0,
                            consentAvailable: 0,
                            isSync: 0,
                            selectedLanguage: Provider.of<AppProvider>(context, listen: false).currentLanguage,
                            surveyDate: DateTime.now().millisecondsSinceEpoch,
                            updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
                            surveyStatus: CommonStrings.strPending);
                        await DatabaseHelper.instance.insertSurvey(survey);
                        print("✅ Survey saved locally");
                        print("Survey : ${survey.surveyId}");
                        print("Survey : ${survey.isSurveyapproved}");
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
  final yearMonth = int.parse('${now.year}${now.month.toString().padLeft(2, '0')}');

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
