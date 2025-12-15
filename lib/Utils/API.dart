// import 'package:dio/dio.dart';
// import 'package:hyworth_land_survey/Utils/SPManager.dart';

// class LandSurveyApi {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: "https://hyworth.onerooftechnologiesllp.com",
//       connectTimeout: Duration(seconds: 20),
//       receiveTimeout: Duration(seconds: 20),
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/json",
//       },
//     ),
//   );

//   Future<void> fetchLandList() async {
//     String? token = await SPManager().getAuthToken();

//     if (token == null) {
//       print("No token found");
//       return;
//     }

//     final Map<String, dynamic> body = {
//       "page": 1,
//       "limit": 10,
//       "search": "Rampura",
//       "state_id": 8,
//       "include_media": true
//     };

//     try {
//       Response response = await _dio.post(
//         "/land-survey/list",
//         data: body,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",  // 🔥 EXACTLY LIKE POSTMAN
//           },
//         ),
//       );

//       print("SUCCESS: ${response.data}");
//     } on DioException catch (e) {
//       print("DIO ERROR: ${e.response?.statusCode}");
//       print("MESSAGE: ${e.response?.data}");
//     } catch (e) {
//       print("Unexpected error: $e");
//     }
//   }

// }