import 'package:shared_preferences/shared_preferences.dart';

class SPManager {
  final String authToken = "authToken";
  final String customerID = "customerID";
  final String customerName = "customerName";
  final String customerEmail = "customerEmail";
  final String customerPhoneNumber = "customerPhoneNumber";
  final String classStatus = "classStatus";
  final String courseStatus = "courseStatus";
  final String planStatus = "planStatus";
    final String courseVisible = "courseVisible";
     final String firebaseToken = "firebaseToken";
       final String registrationType = "registrationType";
  

  Future<void> clear() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getKeys();
    for (String key in pref.getKeys()) {
      // if (key == "authToken") {
      pref.remove(key);
      // }
    }
    //pref.clear();
  }

  //set auth token into shared preferences
  Future<void> setAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.authToken, token);
  }

  //get auth token into shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val;
    val = (prefs.getString(this.authToken) ?? "");
    return val;
  }

}
