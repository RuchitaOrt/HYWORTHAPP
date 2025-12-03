import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Provider/sign_In_provider.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:hyworth_land_survey/Utils/GlobalLists.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/Utils/UtilityFile.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonstrings.dart';
import 'package:hyworth_land_survey/Utils/sizeConfig.dart';
import 'package:hyworth_land_survey/widgets/CustomDropdownField.dart';
import 'package:hyworth_land_survey/widgets/GetversionFile.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';
import 'package:hyworth_land_survey/widgets/custom_text_field_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const String route = "/login_screen";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInProvider>(
      // create: (_) => SignInProvider(),
      create: (_) {
        final provider = SignInProvider();
        provider.addListeners(); // ✅ Add this
        return provider;
      },
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersion();
    Utility().loadAPIConfig(context);

    
  }
  getVersion()
  async {
await getAppVersion(context);

;
  }
  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<SignInProvider>(context);
   signInProvider.emailController.text="admin@hyworth.com";
   signInProvider.passwordController.text="admin@!23#";
    final BorderRadius borderRadius =
        const BorderRadius.all(Radius.circular(8));
    final BorderSide focusedBorder = const BorderSide(
      width: 1.0,
      color: CommonColors.blue,
    );
    final BorderSide enableBorder = BorderSide(
      width: 1.0,
      color: CommonColors.background,
    );
    String languageCode = "en";
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: signInProvider
                                  .formKey,
        child: Stack(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 45,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Logo_2.png',
                    ),
                    fit: BoxFit.contain),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: SizeConfig.blockSizeVertical * 61,
                  width: SizeConfig.blockSizeHorizontal * 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome",
                                textAlign: TextAlign.left,
                                style: CommonStyles.tsblackHeading,
                              ),
        // Padding(
        //                                 padding: EdgeInsets.only(
        //                                     right: SizeConfig.blockSizeHorizontal * 40,
        //                                     top: 6),
        //                                 child: Divider(
        //                                   thickness: 4,
        //                                   color: CommonColors.blackshade,
        //                                   height: 2,
        //                                 ),
        //                               ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Secure login to access your survey records and manage them with ease",
                                textAlign: TextAlign.left,
                                style: CommonStyles.tsGreyHeading,
                              ),
        
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    bottom: 0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical * 1),
                                      CustomTextFieldWidget(
                                        isMandatory: true,
                                        title: CommonStrings.strEmailID,
                                        hintText: CommonStrings.strEnterEnterID,
                                        onChange: (val) {},
                                        textEditingController:
                                            signInProvider.emailController,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        // validator:
                                        //     signInProvider.validateEmailField,
                                      ),
                                      SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical * 1),
        
                                      RichText(
                                        text: TextSpan(
                                          text: CommonStrings.strPassword,
                                          style: CommonStyles.textFieldHeading,
                                          children: [
                                            TextSpan(
                                              text: ' *',
                                              style: TextStyle(
                                                color: CommonColors.marron,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical * 1),
                                      Container(
                                        height: 40,
                                        child: TextFormField(
                                          cursorColor: CommonColors.blue,
                                          style: CommonStyles.textFieldHeading,
                                          obscureText:
                                              signInProvider.isPasswordObscured,
                                          controller:
                                              signInProvider.passwordController,
                                          // validator:
                                          //     signInProvider.validatePassword,
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          decoration: InputDecoration(
                                            errorMaxLines: 3,
                                            suffixIcon: IconButton(
                                              onPressed: signInProvider
                                                  .togglePasswordVisibility,
                                              icon: Icon(
                                                signInProvider.isPasswordObscured
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: CommonColors.blue,
                                              ),
                                            ),
                                            hintText:
                                                CommonStrings.strEnterPassword,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 16.0),
                                            border: OutlineInputBorder(
                                                borderRadius: borderRadius,
                                                borderSide: enableBorder),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: borderRadius,
                                                borderSide: focusedBorder),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: borderRadius,
                                                borderSide: enableBorder),
                                            filled: true,
                                            fillColor: CommonColors.white,
                                            hintStyle: CommonStyles.textFieldHint,
                                            errorStyle:
                                                CommonStyles.textFieldHint,
                                            counterText: "",
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical * 2),
                                      // CustomDropdownField(
                                      //   labelText: CommonStrings.strLanguage,
                                      //   hintText: CommonStrings.strLanguageHint,
                                      //   value: signInProvider.selectedLanguage,
                                      //   items: ['English', 'Hindi', 'Marathi'],
                                      //   onChanged: (val) {
                                      //     FocusScope.of(context).unfocus();
                                      //     signInProvider.selectedLanguage = val;
        
                                      //     if (val == "English") {
                                      //       languageCode = "en";
                                      //     } else if (val == "Hindi") {
                                      //       languageCode = "hi";
                                      //     } else if (val == "mr") {
                                      //       languageCode = "mr";
                                      //     }
                                      //     final appProvider =
                                      //         Provider.of<AppProvider>(context,
                                      //             listen: false);
                                      //     appProvider
                                      //         .changeLanguage(languageCode);
                                      //   },
                                      // ),
                                      // SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                                    ],
                                  ),
                                ),
                              ),
        
                              // Login button pinned at bottom
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4), // no insets here
                                child: SafeArea(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: signInProvider
                                                .isFormValid
                                            ? CommonColors.bluishGreenMoreGreen
                                            : CommonColors.greyButton,
                                        disabledBackgroundColor:
                                            CommonColors.greyButton,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: signInProvider.isFormValid
                                          ? () async {
                                           String? validationMessage = signInProvider.validateEmailField(signInProvider.emailController.text);
 String? validationPasswordMessage = signInProvider.validatePassword(signInProvider.passwordController.text);
  if (validationMessage != null) {
    showToast(validationMessage);
    return; // stop further processing
  }else if (validationPasswordMessage != null) {
    showToast(validationPasswordMessage);
    return; // stop further processing
  }else{
    signInProvider.createSignIn();
  }
                        //                      if (signInProvider.validateForm()) {
                        //   // Proceed with form submission
                        //    print("Login");
                        //   signInProvider.createSignIn();
                        // } else {
                        //    print("Not valid Login");
                        //   // Form is invalid, show error messages
                        // }
                                              // final surveyProvider =
                                              //     Provider.of<AppProvider>(
                                              //         context,
                                              //         listen: false);
                                              // await surveyProvider.loadSPendingurveys();
                                              // await surveyProvider.loadCompletedSurveys();
                                              //  await surveyProvider.loadSurveys();
                                              // final result =
                                              //     await Navigator.of(context)
                                              //         .push(
                                              //   createSlideFromBottomRoute(
                                              //     Maintabscreen(),
                                              //   ),
                                              // );
                                            }
                                          : null,
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0.5,
                              ),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Forget Your Password ? ",
                                          style: CommonStyles.neutral90w30014
                                              .copyWith(fontSize: 12)),
                                      TextSpan(
                                          text: "Click Here",
                                          style: CommonStyles.blacklightw50016
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: CommonColors
                                                      .bluishGreenMoreGreen)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(child: Text("Version ${signInProvider.currentVersion}")),
                               SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
     
    );
  }
}
