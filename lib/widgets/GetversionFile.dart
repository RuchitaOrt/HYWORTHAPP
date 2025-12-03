import 'package:flutter/material.dart';

import 'package:hyworth_land_survey/Provider/sign_In_provider.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

Future<void> getAppVersion(BuildContext context) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final signInProvider = context.read<SignInProvider>();

  String version = packageInfo.version;
  signInProvider.changeVersion(version);

  print("Version: $version");
}
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.blue, // text color
        ),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}
