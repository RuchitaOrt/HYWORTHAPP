
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/BasicDetailsForm.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/MediaForm.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/OtherDetail.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/SubStaionDetailForm.dart';

class StepForm extends StatelessWidget {
  final int currentStep;

  const StepForm({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 1:
        return BasicDetailsForm();
      case 2:
        return SubStaionDetailForm();
      case 3:
        return OtherDetail();
      case 4:
        return MediaForm();
      
      default:
        return const SizedBox();
    }
  }
}

