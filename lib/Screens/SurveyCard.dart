import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/SurveyDetailForm.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonstrings.dart';
import 'package:hyworth_land_survey/Utils/sizeConfig.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SurveyCard extends StatelessWidget {
  final List<SurveyModel> surveyListing;
  final int index;
  final String status;
  final bool uploadconsent;
  final int selectedIndex;

  const SurveyCard(
      {super.key,
      required this.status,
      this.uploadconsent = false,
      required this.surveyListing,
      required this.index,
      required this.selectedIndex});

  static Color getStatusColor(String statusKey) {
    switch (statusKey.toLowerCase()) {
      case 'completed':
        return CommonColors.lightGreen;
      case 'approved':
        return CommonColors.lightGreen;
      case 'pending':
        return CommonColors.error600Color;
      case 'rejected':
        return CommonColors.error600Color;
      default:
        return CommonColors.grey75;
    }
  }

  // optional: convert translated text back to key if needed
  static String getStatusKeyFromText(String statusText, String lang) {
    final map = LanguageStrings.languages[lang] ?? {};
    // reverse lookup
    final entry = map.entries.firstWhere(
        (e) => e.value.toLowerCase() == statusText.toLowerCase(),
        orElse: () => const MapEntry('pending', 'Pending'));
    return entry.key;
  }

  @override
  Widget build(BuildContext context) {
    final lang =
        Provider.of<AppProvider>(context, listen: false).currentLanguage;

// If your status is already translated (like 'लंबित'), get the key
    final statusKey = getStatusKeyFromText(status, lang);

    return Card(
      color: CommonColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Status + More Menu)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   children: [
                //     Container(
                //       width: 12,
                //       height: 12,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: getStatusColor(statusKey),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 8,
                //     ),
                //     Text(
                //       status,
                //       style: TextStyle(
                //           fontSize: 12,
                //           fontWeight: FontWeight.w600,
                //           color: getStatusColor(statusKey)),
                //     ),
                //   ],
                // ),

                surveyListing[index].consentAvailable == 1
                    ? Text(
                        "${surveyListing[index].consentForms!.length.toString()} Consent Uploaded",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: getStatusColor(statusKey)),
                      )
                    : Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getStatusColor(statusKey),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            status,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: getStatusColor(statusKey)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                surveyListing[index].consentAvailable == 1
                    ? GestureDetector(
                        onTap: () {
                          _openExpandedView(
                            context,
                            surveyListing[index]
                                .consentForms!
                                .map((path) => File(path))
                                .toList(),
                          );
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: CommonColors.blue,
                        ))
                    : MoreOptionsMenu(
                        selectedIndex: selectedIndex,
                        status: status,
                        surveyListing: surveyListing[index],
                      ),
              ],
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 8),
            // Survey ID & Operator
            Row(
              children: [
                Expanded(
                    child: _buildInfo(
                        t(context, "survey_id"),
                        //  DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(surveyListing[index].surveyDate!))
                        surveyListing[index].surveyId!)),

                SizedBox(width: 12), // spacing between the two
                Expanded(
                    child: _buildInfo(t(context, "land_village_district"),
                        "${surveyListing[index].landVillage!} ${surveyListing[index].landDistrict}")),
              ],
            ),
            const SizedBox(height: 8),

// Land Location & Contact
            Row(
              children: [
                Expanded(
                    child: _buildInfo(t(context, "land_area"),
                        surveyListing[index].landAreaInAcres!)),
                SizedBox(width: 12),
                Expanded(
                    child: _buildInfo(t(context, "substation_name"),
                        surveyListing[index].subStationName!)),
              ],
            ),
            const SizedBox(height: 8),

// Land Location & Contact
            surveyListing[index].consentAvailable == 1
                ? Container()
                : Row(
                    children: [
                      Expanded(
                          child: _buildInfo(
                              t(context, "land_type"),
                              surveyListing[index].landType == null
                                  ? ""
                                  : surveyListing[index].landType!)),
                      SizedBox(width: 12),
                      Expanded(
                          child: _buildInfo(
                              t(context, "commercial"),
                              surveyListing[index]
                                  .landRateCommercialEscalation!)),
                    ],
                  ),
            const SizedBox(height: 8),
            surveyListing[index].consentAvailable == 1
                ? Container()
                : Row(
                    children: [
                      Expanded(
                          child: _buildInfo(t(context, "capacity"),
                              surveyListing[index].subStationCapacity!)),
                      //             Expanded(child: _buildInfo("LandForm",   (surveyListing[index].surveyForms != null && surveyListing[index].surveyForms!.isNotEmpty)
                      // ? surveyListing[index].surveyForms![0]
                      // : "",)),
                    ],
                  ),
            surveyListing[index].consentAvailable == 1
                ? Container()
                : surveyListing[index].surveyStatus == CommonStrings.strRequired
                    ? Column(
                        children: [
                          UploadConsentWidget(
                            uploadconsent: true,
                            surveyListing: surveyListing[index],
                          )
                        ],
                      )
                    : Container()
          ],
        ),
      ),
    );
  }

  void _openFile(File file) {
    OpenFilex.open(file.path);
  }

  void _openExpandedView(BuildContext context, selectedFiles) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "All Uploaded Files",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: selectedFiles.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];
                        final ext = file.path.split('.').last.toLowerCase();
                        final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () => _openFile(file),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: isImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child:
                                            Image.file(file, fit: BoxFit.cover),
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.picture_as_pdf,
                                                color: Colors.red, size: 40),
                                            SizedBox(height: 4),
                                            Text(
                                              'PDF',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12,
              color: CommonColors.blacklight,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 2),
        Text(value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              
              fontWeight: FontWeight.bold,
              color: CommonColors.blackshade,
            )),
      ],
    );
  }
}

class MoreOptionsMenu extends StatefulWidget {
  final String status;
  final SurveyModel? surveyListing;
  final int selectedIndex;

  const MoreOptionsMenu({
    super.key,
    required this.status,
    required this.surveyListing,
    required this.selectedIndex,
  });

  @override
  State<MoreOptionsMenu> createState() => _MoreOptionsMenuState();
}

class _MoreOptionsMenuState extends State<MoreOptionsMenu> {
  final GlobalKey _iconKey = GlobalKey();

  void _showCustomMenu() {
    final RenderBox renderBox =
        _iconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Get translation labels safely BEFORE onTap
    final lang =
        Provider.of<AppProvider>(context, listen: false).currentLanguage;
    final editLabel = LanguageStrings.languages[lang]?['edit'] ?? 'Edit';
    final deleteLabel = LanguageStrings.languages[lang]?['delete'] ?? 'Delete';
    final syncNow = LanguageStrings.languages[lang]?['syncNow'] ?? 'Sync Now';

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        0,
      ),
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem(
          onTap: () {
//             Future.delayed(Duration.zero, () async {
//               final result = await Navigator.of(context).push(
//                 createSlideFromBottomRoute(
//                   SurveyDetailForm(
//                     isEdit: 1,
//                     surveyListing: widget.surveyListing,
//                   ),
//                 ),
//               );
//               if (result == true) {
//                 final provider =
//                     Provider.of<AppProvider>(context, listen: false);
//                 provider.loadSPendingurveys();
//                 provider.refreshDashboard();
//                 if (result != null && result is SurveyModel) {
//   // Update survey in provider
//   // context.read<AppProvider>().updateSurvey(result);
// }
//               }
//             });
            Future.delayed(Duration.zero, () async {
              final result = await Navigator.of(context).push(
                createSlideFromBottomRoute(
                  SurveyDetailForm(
                    isEdit: 1,
                    surveyListing: widget.surveyListing,
                  ),
                ),
              );
              print("BACK");
              if (result != null) {
                print("BACK");
                // ⚡ update provider
                final provider =
                    Provider.of<AppProvider>(context, listen: false);
                provider.loadSPendingurveys();
                provider.refreshDashboard();

                Navigator.of(context).push(
                  createSlideFromBottomRoute(
                    Maintabscreen(
                      selectedIndex: widget.selectedIndex,
                    ),
                  ),
                );
              }
            });
          },
          child: Text(editLabel),
        ),
        PopupMenuItem(
          onTap: () async {
            await DatabaseHelper.instance
                .deleteSurvey(widget.surveyListing!.id!);
            final provider = Provider.of<AppProvider>(context, listen: false);
            provider.loadSPendingurveys();
            provider.loadSurveys();
            provider.loadConsentSurveys();
            provider.refreshDashboard();
          },
          child: Text(deleteLabel),
        ),
        // PopupMenuItem(
        //   onTap: () async {},
        //   child: Text(syncNow),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _iconKey,
      onTap: _showCustomMenu,
      child: const Icon(Icons.more_vert, color: CommonColors.blue),
    );
  }
}

class UploadConsentWidget extends StatefulWidget {
  final bool uploadconsent;
  final SurveyModel surveyListing;
  const UploadConsentWidget(
      {super.key, required this.uploadconsent, required this.surveyListing});

  @override
  State<UploadConsentWidget> createState() => _UploadConsentWidgetState();
}

class _UploadConsentWidgetState extends State<UploadConsentWidget> {
  List<File> selectedFiles = [];

  Future<void> _pickFiles() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.photos.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          selectedFiles.addAll(result.paths.map((p) => File(p!)));
        });
      }
      _openExpandedView();
    } else {
      print("Permission denied");
    }
  }

  void _openFile(File file) {
    OpenFilex.open(file.path);
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  void _openExpandedView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "All Uploaded Files",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: selectedFiles.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];
                        final ext = file.path.split('.').last.toLowerCase();
                        final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () => _openFile(file),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: isImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child:
                                            Image.file(file, fit: BoxFit.cover),
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.picture_as_pdf,
                                                color: Colors.red, size: 40),
                                            SizedBox(height: 4),
                                            Text(
                                              'PDF',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.black54),
                                onPressed: () {
                                  // 🔹 update both parent and modal UI
                                  setState(() {
                                    selectedFiles.removeAt(index);
                                  });
                                  setModalState(() {});
                                },
                                splashRadius: 18,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4), // no insets here
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CommonColors.bluishGreenMoreGreen,
                            disabledBackgroundColor: CommonColors.greyButton,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            SurveyModel survey = SurveyModel(
                              surveyId:
                                  widget.surveyListing!.surveyId.toString() ??
                                      "", // never null
                              userId: "1",
                              landState: widget.surveyListing.landState ?? "",
                              landDistrict:
                                  widget.surveyListing.landDistrict ?? "",
                              landTaluka: widget.surveyListing.landTaluka ?? "",
                              landVillage:
                                  widget.surveyListing.landVillage ?? "",
                              landLatitude: double.parse(widget
                                  .surveyListing!.landLatitude!
                                  .toString()),
                              landLongitude: double.parse(widget
                                  .surveyListing.landLongitude
                                  .toString()),
                              landAreaInAcres:
                                  widget.surveyListing.landAreaInAcres ?? "",
                              landType: widget.surveyListing.landType ?? "",
                              landRateCommercialEscalation: widget.surveyListing
                                      .landRateCommercialEscalation ??
                                  "",
                              subStationName:
                                  widget.surveyListing.subStationName ?? "",
                              subStationDistrict:
                                  widget.surveyListing.subStationDistrict ?? "",
                              subStationTaluka:
                                  widget.surveyListing.subStationTaluka ?? "",
                              subStationVillage:
                                  widget.surveyListing.subStationVillage ?? "",
                              subStationLatitude: double.parse(widget
                                  .surveyListing.subStationLatitude
                                  .toString()),
                              subStationLongitude: double.parse(widget
                                  .surveyListing.subStationLongitude
                                  .toString()),
                              inchargeName:
                                  widget.surveyListing.inchargeName ?? "",
                              subStationInchargeContact: widget.surveyListing
                                      .subStationInchargeContact ??
                                  "",
                              operatorName:
                                  widget.surveyListing.operatorName ?? "",
                              operatorContact:
                                  widget.surveyListing.operatorContact ?? "",
                              subStationVoltageLevel:
                                  widget.surveyListing.subStationVoltageLevel ??
                                      "",
                              subStationCapacity:
                                  widget.surveyListing.subStationCapacity ?? "",
                              distanceSubStationToLand: widget
                                      .surveyListing.distanceSubStationToLand ??
                                  "",
                              plotDistanceFromMainRoad: widget
                                      .surveyListing.plotDistanceFromMainRoad ??
                                  "",
                              evacuationLevel:
                                  widget.surveyListing.evacuationLevel ?? "",
                              windZone: widget.surveyListing.windZone ?? "",
                              groundWaterRainFall:
                                  widget.surveyListing.groundWaterRainFall ??
                                      "",
                              soilType: widget.surveyListing.soilType ?? "",
                              nearestHighway:
                                  widget.surveyListing.nearestHighway ?? "",
                              surveyForms:
                                  widget.surveyListing.surveyForms!.isNotEmpty
                                      ? widget.surveyListing.surveyForms
                                      : [],
                              landPictures:
                                  widget.surveyListing.landPictures!.isNotEmpty
                                      ? widget.surveyListing.landPictures!
                                      : [],
                              isSurveyapproved: 0,
                              consentAvailable: 1,
                              isSync: 0,
                              selectedLanguage: Provider.of<AppProvider>(
                                      context,
                                      listen: false)
                                  .currentLanguage,
                              surveyDate: widget.surveyListing!.surveyDate,
                              updatedsurveyDate:
                                  DateTime.now().millisecondsSinceEpoch,
                              surveyStatus: CommonStrings.strRequired,
                              consentForms: selectedFiles
                                  .where((file) =>
                                      file != null) // keep only non-null
                                  .map((file) => file!.path) // extract paths
                                  .toList(),
                            );
                            print(
                                "Survey : ${widget.surveyListing!.id.toString()}");

                            final updatedRows = await DatabaseHelper.instance
                                .updateSurvey(
                                    survey, widget.surveyListing!.id!);
                            print("Survey : ${survey.surveyId}");
                            print("Survey : ${survey.isSurveyapproved}");
                            if (updatedRows > 0) {
                              print("✅ Survey updated successfully");
                            } else {
                              print("⚠️ No survey found to update");
                            }
                            context.read<AppProvider>().loadSurveys();
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "Upload",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

//   void _openExpandedView() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.85,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "All Uploaded Files",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(8),
//                 itemCount: selectedFiles.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                   childAspectRatio: 0.7,
//                 ),
//                 itemBuilder: (context, index) {
//                   final file = selectedFiles[index];
//                   final ext = file.path.split('.').last.toLowerCase();
//                   final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

//                   return Stack(
//                     children: [
//                       GestureDetector(
//                         onTap: () => _openFile(file),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.grey.shade200,
//                           ),
//                           child: isImage
//                               ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.file(file, fit: BoxFit.cover),
//                                 )
//                               : Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: const [
//                                       Icon(Icons.picture_as_pdf,
//                                           color: Colors.red, size: 40),
//                                       SizedBox(height: 4),
//                                       Text(
//                                         'PDF',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.red),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                         ),
//                       ),
//                       Positioned(
//                         top: -4,
//                         right: -4,
//                         child: IconButton(
//                           icon: const Icon(Icons.cancel, color: Colors.black54),
//                           onPressed: () => _removeFile(index),
//                           splashRadius: 18,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
// Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children:  [
//               Padding(
//                               padding:  EdgeInsets.only(
//                                   bottom: 4), // no insets here
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:  CommonColors.bluishGreenMoreGreen
//                                       ,

//                                   disabledBackgroundColor:
//                                       CommonColors.greyButton,
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 8),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 onPressed: ()
//                                 async {
//                                                 SurveyModel survey = SurveyModel(
//                             surveyId: widget.surveyListing!.surveyId.toString() ??
//                                 "", // never null
//                             userId: "1",
//                             landState: widget.surveyListing.landState ??
//                                 "",
//                             landDistrict:
//                                 widget.surveyListing.landDistrict ??
//                                     "",
//                             landTaluka: widget.surveyListing.landTaluka ??
//                                 "",
//                             landVillage:
//                                widget.surveyListing.landVillage ??
//                                     "",
//                             landLatitude:
//                                 double.parse(widget.surveyListing!.landLatitude!.toString()),
//                             landLongitude:
//                                 double.parse(widget.surveyListing.landLongitude.toString()),
//                             landAreaInAcres:
//                                widget.surveyListing.landAreaInAcres ?? "",
//                             landType: widget.surveyListing.landType ?? "",
//                             landRateCommercialEscalation:
//                                 widget.surveyListing.landRateCommercialEscalation ?? "",
//                             subStationName:
//                                 widget.surveyListing.subStationName ?? "",
//                             subStationDistrict:widget.surveyListing.subStationDistrict ?? "",
//                             subStationTaluka:widget.surveyListing.subStationTaluka ?? "",
//                             subStationVillage: widget.surveyListing.subStationVillage?? "",
//                             subStationLatitude:double.parse(widget.surveyListing.subStationLatitude.toString()),
//                             subStationLongitude: double.parse(widget.surveyListing.subStationLongitude.toString()),
//                             inchargeName: widget.surveyListing.inchargeName ?? "",
//                             subStationInchargeContact:widget.surveyListing.subStationInchargeContact ?? "",
//                             operatorName:widget.surveyListing.operatorName ?? "",
//                             operatorContact:widget.surveyListing.operatorContact ?? "",
//                             subStationVoltageLevel:widget.surveyListing.subStationVoltageLevel ?? "",
//                             subStationCapacity: widget.surveyListing.subStationCapacity ?? "",
//                             distanceSubStationToLand:widget.surveyListing.distanceSubStationToLand ?? "",
//                             plotDistanceFromMainRoad: widget.surveyListing.plotDistanceFromMainRoad ?? "",
//                             evacuationLevel:widget.surveyListing.evacuationLevel ?? "",
//                             windZone: widget.surveyListing.windZone ?? "",
//                             groundWaterRainFall:widget.surveyListing.groundWaterRainFall ?? "",
//                             soilType:widget.surveyListing.soilType ?? "",
//                             nearestHighway:widget.surveyListing.nearestHighway ?? "",
//                             surveyForms: widget.surveyListing.surveyForms!.isNotEmpty ? widget.surveyListing.surveyForms : [],
//                             landPictures:widget.surveyListing.landPictures!.isNotEmpty?widget.surveyListing.landPictures!:[],
//                             isSurveyapproved: 0,
//                             consentAvailable: 1,
//                             isSync: 0,
//                             selectedLanguage: Provider.of<AppProvider>(context, listen: false).currentLanguage,
//                             surveyDate: widget.surveyListing!.surveyDate,
//                             updatedsurveyDate: DateTime.now().millisecondsSinceEpoch,
//                             surveyStatus: CommonStrings.strRequired,
//                             consentForms: selectedFiles
//                 .where((file) => file != null) // keep only non-null
//                 .map((file) => file!.path) // extract paths
//                 .toList(),
//                             );
//                         print(
//                             "Survey : ${widget.surveyListing!.id.toString()}");

//                         final updatedRows = await DatabaseHelper.instance
//                             .updateSurvey(survey, widget.surveyListing!.id!);
//                         print("Survey : ${survey.surveyId}");
//                         print("Survey : ${survey.isSurveyapproved}");
//                         if (updatedRows > 0) {
//                           print("✅ Survey updated successfully");
//                         } else {
//                           print("⚠️ No survey found to update");
//                         }
//                          Navigator.pop(context, true);
//                                 },
//                                 child: Text(
//                                   "Upload",
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//             ],
//           ),
//           ],
//         ),
//       ),
//     );
//   }

// Example: while loading DB files, push URLs into selectedFiles
  void loadDbFiles() {
    if (widget.surveyListing.consentForms != null) {
      setState(() {
        selectedFiles.addAll(
          widget.surveyListing.consentForms!
              .map((path) => File(path)) // convert String → File
              .toList(),
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDbFiles();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.uploadconsent) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Compact Horizontal Preview
        if (selectedFiles.isNotEmpty)
          SizedBox(
              height: 80,
              child: Row(
                children: [
                  // 🔹 Files Scroll List
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];

                        // Check if this is a local file or DB file (string url)
                        final isLocalFile = file is File;
                        final String path =
                            isLocalFile ? file.path : file.toString();
                        final ext = path.split('.').last.toLowerCase();
                        final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () => _openFile(file),
                              child: Container(
                                width: 80,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: isImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: isLocalFile
                                            ? Image.file(file,
                                                fit: BoxFit.cover)
                                            : Image.network(path,
                                                fit: BoxFit.cover),
                                      )
                                    : const Icon(Icons.picture_as_pdf,
                                        color: Colors.red, size: 40),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.black54),
                                onPressed: () => _removeFile(index),
                                splashRadius: 18,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // 🔹 Static Expand Button
                  GestureDetector(
                    onTap: _openExpandedView,
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.expand,
                          color: CommonColors.bluishGreenMoreGreen, size: 30),
                    ),
                  ),
                ],
              )),

        const Divider(),
        // Text("${widget.surveyListing.consentForms!.length.toString()}"),
        GestureDetector(
          onTap: _pickFiles,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.upload, color: CommonColors.bluishGreenMoreGreen),
              SizedBox(width: 6),
              Text(
                "Upload Consent",
                style: TextStyle(color: CommonColors.bluishGreenMoreGreen),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// class UploadConsentWidget extends StatefulWidget {
//   final bool uploadconsent;
//   const UploadConsentWidget({super.key, required this.uploadconsent});

//   @override
//   State<UploadConsentWidget> createState() => _UploadConsentWidgetState();
// }

// class _UploadConsentWidgetState extends State<UploadConsentWidget> {
//   List<File> selectedFiles = [];

//   Future<void> _pickFiles() async {
//     if (await Permission.storage.request().isGranted ||
//         await Permission.photos.request().isGranted) {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//       );

//       if (result != null) {
//         setState(() {
//           selectedFiles.addAll(result.paths.map((p) => File(p!)));
//         });
//       }
//     } else {
//       print("Permission denied");
//     }
//   }

//   void _openFile(File file) {
//     OpenFilex.open(file.path);
//   }

//   void _removeFile(int index) {
//     setState(() {
//       selectedFiles.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!widget.uploadconsent) return Container();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Divider(),
//         GestureDetector(
//           onTap: _pickFiles,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.upload, color: Colors.blue),
//               SizedBox(width: 6),
//               Text(
//                 "Upload Consent",
//                 style: TextStyle(color: Colors.blue),
//               )
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         if (selectedFiles.isNotEmpty)
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: selectedFiles.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//               childAspectRatio: 0.7,
//             ),
//             itemBuilder: (context, index) {
//               final file = selectedFiles[index];
//               final ext = file.path.split('.').last.toLowerCase();
//               final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

//               return Stack(
//                 children: [
//                   GestureDetector(
//                     onTap: () => _openFile(file),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey.shade200,
//                       ),
//                       child: isImage
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.file(
//                                 file,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: const [
//                                   Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     'PDF',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.red),
//                                   )
//                                 ],
//                               ),
//                             ),
//                     ),
//                   ),
//                   // Remove button
//                   Positioned(
//                     top: -4,
//                     right: -4,
//                     child: IconButton(
//                       icon: const Icon(Icons.cancel, color: Colors.black54),
//                       onPressed: () => _removeFile(index),
//                       splashRadius: 18,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//       ],
//     );
//   }
// }

// class UploadConsentWidget extends StatefulWidget {
//   final bool uploadconsent;
//   const UploadConsentWidget({super.key, required this.uploadconsent});

//   @override
//   State<UploadConsentWidget> createState() => _UploadConsentWidgetState();
// }

// class _UploadConsentWidgetState extends State<UploadConsentWidget> {
//   List<File> selectedFiles = [];

// Future<void> _pickFiles() async {
//   // Request both storage & media permissions depending on Android version
//   if (await Permission.storage.request().isGranted ||
//       await Permission.photos.request().isGranted) {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedFiles = result.paths.map((p) => File(p!)).toList();
//       });
//     }
//   } else {
//     print("Permission denied");
//   }
// }
//   void _openFile(File file) {
//     OpenFilex.open(file.path); // Opens in default viewer
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!widget.uploadconsent) return Container();

//     return Column(
//       children: [
//         const Divider(),
//         GestureDetector(
//           onTap: _pickFiles,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.upload, color: Colors.blue),
//               const SizedBox(width: 6),
//               Text(
//                 "Upload Consent",
//                 style: const TextStyle(color: Colors.blue),
//               )
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         // Show list of uploaded files
//         if (selectedFiles.isNotEmpty)
//           Column(
//             children: selectedFiles.map((file) {
//               final ext = file.path.split('.').last.toLowerCase();
//               final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
//               return ListTile(
//                 leading: isImage
//                     ? Image.file(file, width: 40, height: 40, fit: BoxFit.cover)
//                     : const Icon(Icons.picture_as_pdf, color: Colors.red),
//                 title: Text(file.path.split('/').last),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.visibility, color: Colors.green),
//                   onPressed: () => _openFile(file),
//                 ),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }
// }
