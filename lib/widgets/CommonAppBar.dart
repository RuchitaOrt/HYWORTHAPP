import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/login_screen.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/Utils/SurveySyncValidation.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonimages.dart';
import 'package:hyworth_land_survey/Utils/internetConnection.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:provider/provider.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isbackVisible;
  final PreferredSizeWidget? bottom;
  final bool isCloseIconVisible;
  final bool islogout;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.isbackVisible = true,
    this.bottom,
    this.isCloseIconVisible = false,
    this.islogout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CommonColors.white,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          isbackVisible
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: CommonColors.blacklight),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : Container(),

          // Title and optional stepTitle
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w800, // ExtraBold
                      color: CommonColors.blackshade,
                      fontSize: 22,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
  print("SYNC ALL CLICKED");
        var status1 =
                          await ConnectionDetector.checkInternetConnection();
                          if(status1)
                          {



                            showConfirmDialog(routeGlobalKey.currentContext!, "SYNC ",
                        "Are You Sure want to sync survey all pending survey on Server ? ",
                        () async {
                          Navigator.pop(context);
                          final provider = context.read<AppProvider>();
final basicFormProvider = context.read<BasicFormProvider>();

final pendingList =
    List.from(provider.pendingsurveys.where((e) => e.isReadyForSync()));

final total = pendingList.length;
int current = 0;
updateSyncNotification(
  current: 0,
  total: pendingList.length,
  surveyId: "",
  started: true,
);
for (final item in pendingList) {
  current++;

  updateSyncNotification(
    current: current,
    total: total,
    surveyId: item.surveyId!,
  );

  final survey = prepareSurveyModel(item);
  bool success = false;

  try {
    if (item.serverSynced == 1) {
      success = await basicFormProvider.updateMultipleLandSurvey(
        survey,
        item.id!,
      );
    } else {
      success = await basicFormProvider.submitMultipleLandSurvey(survey);
    }

    if (success) {
      await DatabaseHelper.instance.markSurveySynced(item.surveyId!);

      // ✅ show completed state for THIS survey
      updateSyncNotification(
        current: current,
        total: total,
        surveyId: item.surveyId!,
      );
    } else {
      throw Exception("API returned false");
    }
  } catch (e) {
    // ❌ failure shown immediately
    updateSyncNotification(
      current: current,
      total: total,
      surveyId: item.surveyId!,
      error: true,
    );
  }
}


// 🔁 Reload ONCE
await provider.loadSPendingurveys();
await provider.loadSurveys();
await provider.loadConsentSurveys();
await provider.refreshDashboard();

// ✅ FINAL notification
updateSyncNotification(
  current: total,
  total: total,
  surveyId: "",
  completed: true,
);


//                                                   final provider = context.read<AppProvider>();
//   final basicFormProvider = context.read<BasicFormProvider>();

//   final pendingList =
//       List.from(provider.pendingsurveys.where((e) => e.isReadyForSync()));

//   final total = pendingList.length;
//   int current = 0;

//   for (final item in pendingList) {
//     current++;
// print("SYNC ALL CLICKED ${current}");
//     updateSyncNotification(
//       current: current,
//       total: total,
//       surveyId: item.surveyId!,
//     );

//     final survey = prepareSurveyModel(item);

//     try {
//       if (item.serverSynced == 1) {
//         print("ALREADY ON SERVER");
//         await basicFormProvider.updateMultipleLandSurvey(
//           survey,
//           item.id!,
//         ).then((onValue)
//         async {
//           await provider.loadSPendingurveys();
//       await provider.loadSurveys();
//       await provider.loadConsentSurveys();
//       await provider.refreshDashboard();
//         });
//       } else {
//           print("UPLoadeing NEW ON SERVER");
//         await basicFormProvider.submitMultipleLandSurvey(survey).then((onValue)
//         async {
//           await provider.loadSPendingurveys();
//       await provider.loadSurveys();
//       await provider.loadConsentSurveys();
//       await provider.refreshDashboard();
//         });
//       }

//       // reload local data AFTER each success
      
//     } catch (e) {
//       updateSyncNotification(
//         current: current,
//         total: total,
//         surveyId: item.surveyId!,
//         error: true,
//       );
//     }
//   }

  // FINAL notification
  // updateSyncNotification(
  //   current: total,
  //   total: total,
  //   surveyId: "",
  //   completed: true,
  // );
                    });

                          }
                          else{
                             showToast("No internet connection please check coneection to sync on server");
                          }

},


            child: Icon(
              Icons.sync,
              color: CommonColors.blue,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          isCloseIconVisible
              ? GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: SvgPicture.asset(
                    CommonImagePath.close,
                    height: 24,
                    width: 24,
                  ),
                )
              : Container(),
          islogout
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap a button
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(t(context, 'logout')), // optional title
                          content: Text(t(context,
                              'are_you_sure_logout')), // optional content
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                  t(context, 'cancel')), // Use localization
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //  Navigator.of(context)
                                //                                           .push(
                                //                                     createSlideFromBottomRoute(
                                //                                       LoginScreen(),
                                //                                     ),
                                //                                   );
                                Navigator.push(
                                  routeGlobalKey.currentContext!,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginScreen()), // Open Search Screen
                                );
                              },
                              child: Text(
                                  t(context, 'logout')), // Use localization
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.logout,
                    color: CommonColors.blue,
                  ),
                )
              : Container(),
        ],
      ),

      bottom: bottom, // ✅ Forward to AppBar
    );
  }
SurveyModel prepareSurveyModel(SurveyModel pending) {
  List<SurveyMediaModel> landPictures = pending.landPictures
      .where((file) => file != null)
      .map((file) => SurveyMediaModel(
            surveyLocalId: pending.surveyId!,
            mediaType: 'land',
            serverMediaId: "",
            createdAt: 0,
            isdeleted: 0,
            localPath: file!.localPath,
            isSynced: 0,
          ))
      .toList();

  List<SurveyMediaModel> surveyForms = pending.surveyForms != null
      ? pending.surveyForms!
          .map((file) => SurveyMediaModel(
                surveyLocalId: pending.surveyId!,
                mediaType: 'survey',
                serverMediaId: file.serverMediaId,
                createdAt: 0,
                isdeleted: 0,
                localPath: file.localPath,
                isSynced: 0,
              ))
          .toList()
      : [];

  return SurveyModel(
    surveyId: pending.surveyId,
    userId: "1",
    landStateID: pending.landStateID ?? "",
    landState: pending.landState ?? "",
    landDistrict: pending.landDistrict ?? "",
    landDistrictID: pending.landDistrictID ?? "",
    landTaluka: pending.landTaluka ?? "",
    landTalukaID: pending.landTalukaID ?? "",
    landVillage: pending.landVillage ?? "",
    landVillageID: pending.landVillageID ?? "",
    landLatitude: double.tryParse(pending.landLatitude.toString()) ?? 0.0,
    landLongitude: double.tryParse(pending.landLongitude.toString()) ?? 0.0,
    landAreaInAcres: pending.landAreaInAcres,
    landType: pending.landType ?? "",
    landRateCommercialEscalation: pending.landRateCommercialEscalation,
    subStationName: pending.subStationName,
    subStationDistrict: pending.subStationDistrict ?? "",
    subStationTaluka: pending.subStationTaluka ?? "",
    subStationVillage: pending.subStationVillage ?? "",
    substationDistrictID: pending.substationDistrictID ?? "",
    substationTalukaID: pending.substationTalukaID ?? "",
    substationVillageID: pending.substationVillageID ?? "",
    subStationLatitude: double.tryParse(pending.subStationLatitude.toString()) ?? 0.0,
    subStationLongitude: double.tryParse(pending.subStationLongitude.toString()) ?? 0.0,
    inchargeName: pending.inchargeName,
    subStationInchargeContact: pending.subStationInchargeContact,
    operatorName: pending.operatorName,
    operatorContact: pending.operatorContact,
    subStationVoltageLevel: pending.subStationVoltageLevel,
    subStationCapacity: pending.subStationCapacity,
    distanceSubStationToLand: pending.distanceSubStationToLand,
    plotDistanceFromMainRoad: pending.plotDistanceFromMainRoad,
    evacuationLevel: pending.evacuationLevel,
    windZone: pending.windZone,
    groundWaterRainFall: pending.groundWaterRainFall,
    soilType: pending.soilType,
    nearestHighway: pending.nearestHighway,
    landPictures: landPictures,
    surveyForms: surveyForms,
    consentForms: [],

    isSurveyapproved: pending.isSurveyapproved,
    consentAvailable: pending.consentAvailable,
    isSync: pending.isSync,
    serverSynced: pending.serverSynced,
    needSynced: pending.needSynced,
    selectedLanguage: pending.selectedLanguage,
    surveyDate: DateTime.now().millisecondsSinceEpoch,
    updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
    surveyStatus: "Pending",
  );
}
void updateSyncNotification({
  required int current,
  required int total,
  required String surveyId,
  bool error = false,
  bool completed = false,
  bool started = false,
}) {
  final percent = total == 0 ? 0 : ((current / total) * 100).toInt();

  String title;
  String body;

  if (started) {
    title = "Survey Sync Started";
    body = "Preparing to sync $total surveys";
  } else if (completed) {
    title = "Sync Completed";
    body = "All $total surveys synced successfully";
  } else if (error) {
    title = "Survey Sync Failed";
    body = "❌ Survey ID: $surveyId";
  } else {
    title = "Syncing Surveys";
    body =
        "🔄 Survey $current of $total\n🆔 ID: $surveyId\n📊 $percent% completed";
  }

  flutterLocalNotificationsPlugin.show(
    1001, // SAME ID → updates existing notification
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'sync_channel',
        'Survey Sync',
        channelDescription: 'Shows survey sync progress',
        importance: Importance.high, // 🔥 visible from top
        priority: Priority.high,
        ongoing: !completed,
        autoCancel: completed,
        showProgress: !completed,
        maxProgress: 100,
        progress: percent,
        onlyAlertOnce: true, // 🔑 no vibration spam
      ),
    ),
  );
}

// void updateSyncNotification({
//   required int current,
//   required int total,
//   required String surveyId,
//   bool error = false,
//   bool completed = false,
// }) {
//   final percent = ((current / total) * 100).toInt();
// print("updateSyncNotification");
//   flutterLocalNotificationsPlugin.show(
//     1001, // same ID → updates same notification
//     completed
//         ? "Sync Complete"
//         : error
//             ? "Sync Failed"
//             : "Syncing Surveys",
//     completed
//         ? "All $total surveys synced"
//         : error
//             ? "Survey $surveyId failed"
//             : "Survey $current / $total ($percent%)\n$surveyId",
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         'sync_channel',
//         'Survey Sync',
//         importance: Importance.low,
//         ongoing: !completed,
//         showProgress: !completed,
//         maxProgress: 100,
//         progress: percent,
//       ),
//     ),
//   );
// }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
