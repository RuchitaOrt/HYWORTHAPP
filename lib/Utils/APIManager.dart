import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hyworth_land_survey/Utils/AppEror.dart';
import 'package:hyworth_land_survey/Utils/SPManager.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/model/LandDistrictModel.dart';
import 'package:hyworth_land_survey/model/LandStateModel.dart';
import 'package:hyworth_land_survey/model/LandSuveryListModel.dart';
import 'package:hyworth_land_survey/model/LandTalukaModel.dart';
import 'package:hyworth_land_survey/model/LandVillagesModel.dart';
import 'package:hyworth_land_survey/model/SignInResponse.dart';
import 'package:provider/provider.dart';

enum API {
  signIn,
  getList,

  getById,
  landsurveylist,

  landsurveycreate,
  landsurveydelete,
  approvalStatusList,
  landsurveyupdate,
  
  states,
  districts,
  talukas,
  villages
}

enum HTTPMethod { GET, POST, PUT, DELETE }

typedef successCallback = void Function(dynamic response);
typedef progressCallback = void Function(int progress);
typedef failureCallback = void Function(AppError error);

class APIManager {
  static Duration? timeout;
  static String? token;
  static String? baseURL;
  static String? apiVersion;
  var taskId;

  APIManager._privateConstructor();
  static final APIManager _instance = APIManager._privateConstructor();

  factory APIManager() {
    return _instance;
  }

  var url;
  void loadConfiguration(String configString) {
    Map config = jsonDecode(configString);
    var env = config['environment'];
    baseURL = config[env]['hostUrl'];
    apiVersion = config['version'];
    timeout = Duration(seconds: config[env]['timeout']);
    print('load config' + configString);
  }

  void setToken(String value) {
    token = value;
  }

  String apiBaseURL() {
    return baseURL!;
  }

  Future<String> apiEndPoint(API api) async {
    var apiPathString = "";

    switch (api) {
      case API.signIn:
        apiPathString = "/api/sign-in";
        break;
      case API.landsurveycreate:
        apiPathString = "/land-survey/create";
        break;
      case API.getById:
        apiPathString = "/land-survey/getById";
        break;
      case API.landsurveylist:
        apiPathString = "/land-survey/list";
        break;
      case API.landsurveydelete:
        apiPathString = "/land-survey/delete";
        break;
      case API.approvalStatusList:
        apiPathString = "/land-survey/approvalStatusList";
        break;
      case API.landsurveyupdate:
        apiPathString = "/land-survey/update";
        break;
      case API.states:
        apiPathString = "/land-survey/states";
        break;
         case API.villages:
        apiPathString = "/land-survey/villages";
        break;
         case API.talukas:
        apiPathString = "/land-survey/talukas";
        break;
         case API.districts:
        apiPathString = "/land-survey/districts";
        break;
      default:
        apiPathString = "/Login";
    }
    print(apiBaseURL());

    return this.apiBaseURL() + apiPathString;
  }

  HTTPMethod apiHTTPMethod(API api) {
    HTTPMethod method;
    switch (api) {
      case API.getList:
        method = HTTPMethod.GET;
        break;

      default:
        method = HTTPMethod.POST;
    }
    return method;
  }

  String classNameForAPI(API api) {
    String className;
    switch (api) {
      case API.signIn:
        className = "LoginResponse";
        break;

      case API.landsurveycreate:
        className = "LandSurveyCreatedModel";
        break;
      case API.landsurveydelete:
        className = "DeleteLandSurveyModel";
        break;

      case API.landsurveyupdate:
        className = "LandSurveyUpdatedModel";
        break;

      case API.landsurveylist:
        className = "SurveyResponse";
        break;

      case API.approvalStatusList:
        className = "LoginResponse";
        break;
      case API.getById:
        className = "LandSurveyByIdModel";
        break;
      case API.states:
        className = "LandStateModel";
        break;
      case API.districts:
        className = "LandDistrictModel";
        break;
      case API.talukas:
        className = "LandTalukaModel";
        break;
      case API.villages:
        className = "LandVillagesModel";
        break;
      default:
        className = 'CommonResponse';
    }
    return className;
  }

  dynamic parseResponse(String className, var json) {
    dynamic responseObj;

    if (className == 'LoginResponse') {
      responseObj = LoginResponse.fromJson(json);
    } 
     if (className == 'LandStateModel') {
      responseObj = LandStateModel.fromJson(json);
    }  if (className == 'LandDistrictModel') {
      responseObj = LandDistrictModel.fromJson(json);
    } 
     if (className == 'LandTalukaModel') {
      responseObj = LandTalukaModel.fromJson(json);
    }  if (className == 'LandVillagesModel') {
      responseObj = LandVillagesModel.fromJson(json);
    }
     
      if (className == 'SurveyResponse') {
      responseObj = SurveyResponse.fromJson(json);
    }

    return responseObj;
  }
 Future<void> apiRequestWithoutContext( API api,
      successCallback onSuccess, failureCallback onFailure,
      {dynamic parameter,
      dynamic params,
      dynamic path,
      dynamic jsonval}) async {
    var jsonResponse;
    http.Response? response;
    Map<String, String> headers = {};
    String? token = await SPManager().getAuthToken();
    print("token: ${token}");
    print("token: coming");
    // var body = (parameter != null ? json.encode(parameter) : jsonval);
    // String body = json.encode(jsonval);
    var body = jsonval is String ? jsonval : json.encode(jsonval);
    print("body");
     print(api);
    print("bodu" + body);
    url = await this.apiEndPoint(api);
    if (path != null) {
      url = url + path;
      print(url);
    }

    if (token != null && token.isNotEmpty) {
      headers = {
      "Accept": "*/*",
  "Content-Type": "application/json",
  "Authorization": "Bearer $token",
      };
      print("header is $headers");
    } else {
      headers = {
        "Accept": 'application/json',
        // "x-api-key": "IjMgJzUSIikuLi1yYAFiMTMuKyQiNWQfZ2s0MiQzeHl2YGAyN",
        "Content-Type": "application/json",
      };
      // }
    }
    print('URL is $url');

    print("body is $body");

    print("header is $headers");

    try {
      if (this.apiHTTPMethod(api) == HTTPMethod.POST) {
        response =
            await http.post(Uri.parse(url), body: body, headers: headers);
        // .timeout(timeout!);
        print(response.body);
      } else if (this.apiHTTPMethod(api) == HTTPMethod.GET) {
        //   print(url);
        response =
            await http.get(Uri.parse(url), headers: headers).timeout(timeout!);
        // log('response of get');
        //print(response.body);
      } else if (this.apiHTTPMethod(api) == HTTPMethod.PUT) {
        print('body is -' + body);
        response = await http
            .put(
              Uri.parse(url),
              body: body,
              headers: headers,
            )
            .timeout(timeout!);
      } else if (this.apiHTTPMethod(api) == HTTPMethod.DELETE) {
        response = await http
            .delete(Uri.parse(url), headers: headers)
            .timeout(timeout!);
      }

      //TODO : Handle 201 status code as well
      print('API is ${api}');
      print('Resp is ${response!.statusCode}');

      if (response.statusCode == 200) {
        //logout appi response is not json

        jsonResponse = json.decode(response.body);

        if (jsonResponse["status"] == true ||
            jsonResponse["status"] == "success") {
          onSuccess(
              this.parseResponse(this.classNameForAPI(api), jsonResponse));
        } else {
          print("status");
          print("api $api");
          String message = jsonResponse['message'] ?? 'Unknown Error';
        }
      } else if (response.statusCode == 401) {
        // unAthorizedTokenErrorDialog(context,
        //     message: "Session expired. Please login again.");
      } else {
        var appError = this.parseError(response);

        onFailure(appError);
      }
    } catch (error) {
      // executed for errors of all types other than Exception
      var appError = FetchDataError(error.toString());
      // FLog.error(
      //     text:
      //         'Time : ${Utility().calculateTime(startTime)} Caller : ${programInfo.callerFunctionName} Error : ${appError.toString()}');
      onFailure(appError);
    }
  }
//  Future<Map<String, dynamic>> apiRequestWithoutContext(API api,
//     {dynamic jsonval, dynamic path}) async {
//   final url = await apiEndPoint(api) + (path ?? "");
//   String? token = await SPManager().getAuthToken();

//   final headers = {
//     "Accept": "application/json",
//     "Content-Type": "application/json",
//     if (token != null && token.isNotEmpty) "Authorization": "Bearer $token"
//   };

//   final body = jsonval is String ? jsonval : json.encode(jsonval);

//   http.Response response;

//   if (apiHTTPMethod(api) == HTTPMethod.POST) {
//     response = await http.post(Uri.parse(url), headers: headers, body: body);
//   } else {
//     response = await http.get(Uri.parse(url), headers: headers);
//   }

//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   } else {
//     throw Exception("HTTP ${response.statusCode}: ${response.body}");
//   }
// }

// Future<void> apiRequestDio(
//   BuildContext context,
//   API api, {
//   Map<String, dynamic>? jsonBody,
//   String? path,
//   required Function(dynamic) onSuccess,
//   required Function(dynamic) onFailure,
// }) async {
//   try {
//     // Get token
//     String? token = await SPManager().getAuthToken();
//     print("TOKEN: $token");

//     // Base URL
//     String url = await apiEndPoint(api);
//     if (path != null) url = "$url$path";

//     print("URL → $url");
//     print("BODY → $jsonBody");

//     // Configure Dio
//     Dio dio = Dio(
//       BaseOptions(
//         baseUrl: "",
//         connectTimeout: const Duration(seconds: 15),
//         receiveTimeout: const Duration(seconds: 15),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",

//           // TRY ALL POSSIBLE TOKEN FORMATS
//           // Uncomment the one that works with your backend ↓↓↓

//           // 1. Standard Bearer (most common)
//           "Authorization": "Bearer $token",

//           // 2. Or raw token (if backend expects without Bearer)
//           // "Authorization": token,

//           // 3. Or token in custom header
//           // "token": token,

//           // 4. Or x-access-token style
//           // "x-access-token": token,
//         },
//       ),
//     );

//     Response response = await dio.post(url, data: jsonBody);

//     print("STATUS: ${response.statusCode}");
//     print("RESPONSE: ${response.data}");

//     // Success (200)
//     if (response.statusCode == 200) {
//       final data = response.data;

//       if (data["status"] == true || data["status"] == "success") {
//         onSuccess(data);
//       } else {
//         onFailure(data["message"] ?? "Unknown error");
//       }
//       return;
//     }

//     // Unauthorized
//     if (response.statusCode == 401) {
//       unAthorizedTokenErrorDialog(
//         context,
//         message: "Session expired. Please login again.",
//       );
//       return;
//     }

//     onFailure("Error ${response.statusCode}");
//   } catch (e) {
//     print("DIO ERROR → $e");
//     onFailure(e.toString());
//   }
// }

  Future<void> apiRequest(BuildContext context, API api,
      successCallback onSuccess, failureCallback onFailure,
      {dynamic parameter,
      dynamic params,
      dynamic path,
      dynamic jsonval}) async {
    var jsonResponse;
    http.Response? response;
    Map<String, String> headers = {};
    String? token = await SPManager().getAuthToken();
    print("token: ${token}");
    print("token: coming");
    // var body = (parameter != null ? json.encode(parameter) : jsonval);
    // String body = json.encode(jsonval);
    var body = jsonval is String ? jsonval : json.encode(jsonval);
    print("body");
    print("bodu" + body);
    url = await this.apiEndPoint(api);
    if (path != null) {
      url = url + path;
       print("URL POINTS");
      print(url);
    }

 headers = {
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Cookie":"connect.sid=s%3AgSI19efiEnYhjoolijN26m12riYa2eKZ.S2qS3TfezzGEqC4DGygygzYb0266Ww9ghvFr%2B07ZAnk",
  // "Authorization": token!,
  // "x-access-token":"$token"
    "Authorization":"Bearer $token"
};

// if (token != null && token.isNotEmpty) {
  // headers["Authorization"] = "Bearer $token";
// }

   
    print('URL is $url');

    print("body is $body");

    print("header is $headers");

    try {
      if (this.apiHTTPMethod(api) == HTTPMethod.POST) {
        response =
            await http.post(Uri.parse(url), body: body, headers: headers);
        // .timeout(timeout!);
        print(response.body);

         print("REsponse status is ${response.statusCode}");
      } else if (this.apiHTTPMethod(api) == HTTPMethod.GET) {
        //   print(url);
        response =
            await http.get(Uri.parse(url), headers: headers).timeout(timeout!);
        // log('response of get');
        //print(response.body);
      } else if (this.apiHTTPMethod(api) == HTTPMethod.PUT) {
        print('body is -' + body);
        response = await http
            .put(
              Uri.parse(url),
              body: body,
              headers: headers,
            )
            .timeout(timeout!);
      } else if (this.apiHTTPMethod(api) == HTTPMethod.DELETE) {
        response = await http
            .delete(Uri.parse(url), headers: headers)
            .timeout(timeout!);
      }

      //TODO : Handle 201 status code as well
      print('API is ${api}');
      print('RUCHITA Resp is ${response!.statusCode}');

      if (response.statusCode == 200) {
        //logout appi response is not json
  print('RUCHITA is ${response!.statusCode}');
        jsonResponse = json.decode(response.body);

               print('RUCHITA is ${response!.statusCode}');
          onSuccess(
              this.parseResponse(this.classNameForAPI(api), jsonResponse));
      
      } else if (response.statusCode == 401) {
        unAthorizedTokenErrorDialog(context,
            message: "Session expired. Please login again.");
      } else {
        var appError = this.parseError(response);

        onFailure(appError);
      }
    } catch (error) {
      // executed for errors of all types other than Exception
      var appError = FetchDataError(error.toString());
      // FLog.error(
      //     text:
      //         'Time : ${Utility().calculateTime(startTime)} Caller : ${programInfo.callerFunctionName} Error : ${appError.toString()}');
      onFailure(appError);
    }
  }

  dynamic parseUploadError(String response, int statusCode) {
    var jsonResponse;
    var message;
    if (response != null && response.length > 0) {
      jsonResponse = json.decode(response);
      if (jsonResponse != null && jsonResponse["status_Message"] != null) {
        message = jsonResponse["status_Message"];
      } else {
        message = response;
      }
    }

    switch (statusCode) {
      case 400:
        return BadRequestError(message);
      case 401:
      case 403:
        return UnauthorisedError(message);
      case 500:
        return showToast("server Error");
      default:
        return FetchDataError(
            'Error occured while Communication with Server with StatusCode : ${statusCode}');
    }
  }

  dynamic parseError(http.Response response) {
    var jsonResponse;
    var message;

    if (response.body != null && response.body.toString().length > 0) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse["desc"] != null) {
        message = jsonResponse["desc"];
      } else {
        message = response.body.toString();
      }
    }

    switch (response.statusCode) {
      case 400:
        return BadRequestError(message);
      case 200:
        return MessageError(message);
      case 401:
      case 403:
        return UnauthorisedError(message);
      case 500:
      default:
        return FetchDataError(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
