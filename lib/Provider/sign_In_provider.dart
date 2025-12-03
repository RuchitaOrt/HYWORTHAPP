import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Utils/APIManager.dart';
import 'package:hyworth_land_survey/Utils/SPManager.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/Utils/internetConnection.dart';
import 'package:hyworth_land_survey/Utils/regex_helper.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:hyworth_land_survey/model/SignInResponse.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';
import 'package:provider/provider.dart';

class SignInProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RegexHelper _regexHelper = RegexHelper();
  bool _isPasswordObscured = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isFormValid {
    return (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty
        //  &&
        // selectedLanguage != null
        )
        ;
  }

  void addListeners() {
    emailController.addListener(notifyListeners);
    passwordController.addListener(notifyListeners);
  }

  // Getter for formKey
  GlobalKey<FormState> get formKey => _formKey;
  bool get isPasswordObscured => _isPasswordObscured;
  String? selectedChip;
  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  String? validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!_regexHelper.isEmailIdValid(value)) {
      return 'Enter a valid Email ID';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    // if (!RegExp(
    //         r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
    //     .hasMatch(value)) {
    //   return 'Password must include At least 8 characters long, uppercase, lowercase, a digit, and a special character';
    // }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value != passwordController.text) {
      return 'Confirm Password should match your new password';
    }
    return null;
  }

  bool _isChecked = false;

  bool get isChecked => _isChecked;

  void toggleCheckbox(bool? value) {
    _isChecked = value ?? false;
    notifyListeners(); // Notify listeners when the state changes
  }

  // Method to validate form
  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  String? _selectedLanguage;

  String? get selectedLanguage => _selectedLanguage;

  set selectedLanguage(String? val) {
    _selectedLanguage = val;
    notifyListeners();
  }

  String _currentVersion = ''; // default

  String get currentVersion => _currentVersion;

  void changeVersion(String lang) {
    _currentVersion = lang;
    notifyListeners();
  }

  Map<String, dynamic> createRequestBody() {
    return {
      "email": emailController.text,
      "password": passwordController.text,
    };
  }

  createSignIn() async {
    var status1 = await ConnectionDetector.checkInternetConnection();

    if (status1) {
      dynamic jsonbody = createRequestBody();
      print(jsonbody);

      APIManager().apiRequest(routeGlobalKey.currentContext!, API.signIn,
          (response) async {
        LoginResponse resp = response;

        if (resp.status == true) {
          showToast(resp.message);
          SPManager().setAuthToken(resp.token);
          final surveyProvider = Provider.of<AppProvider>(
              routeGlobalKey.currentContext!,
              listen: false);
          await surveyProvider.loadSPendingurveys();
          await surveyProvider.loadCompletedSurveys();
          await surveyProvider.loadSurveys();
          final result =
              await Navigator.of(routeGlobalKey.currentContext!).push(
            createSlideFromBottomRoute(
              Maintabscreen(),
            ),
          );
        }
      }, (error) {
        print('ERR msg is $error');

        showToast("Server Not Responding");
      }, jsonval: jsonbody);
    } else {
      /// Navigator.of(_keyLoader.currentContext).pop();
      showToast("Please check internet connection");
    }
  }
}
