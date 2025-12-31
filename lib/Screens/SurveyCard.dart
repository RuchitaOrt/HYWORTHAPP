import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/AddConsentForm.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/SurveyDetailForm.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/Utils/SurveySyncValidation.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/internetConnection.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';
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

  // getMedia(surveyID) async {
  //   print("BEFORE");
  //   print(surveyListing[index].consentForms);
  //   // final mediaList = await DatabaseHelper.instance.getSurveyMedia(surveyID);
 
  //   // final consentForms =
  //   //     mediaList.where((m) => m.mediaType == 'consent').toList();
  //   // print(consentForms.length);
  //   // for(int i=0;i<consentForms.length;i++)
  //   // {
  //   //   print(consentForms[i].localPath);
  //   // }
  //   // surveyListing[index].consentForms = consentForms;
    

     
    
  // }

  @override
  Widget build(BuildContext context) {
    final lang =
        Provider.of<AppProvider>(context, listen: false).currentLanguage;

// If your status is already translated (like 'लंबित'), get the key
    final statusKey = getStatusKeyFromText(status, lang);
    // getMedia(surveyListing[index].surveyId);
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
                // surveyListing[index].consentAvailable == 1
                //     ? Text(
                //         "${surveyListing[index].consentForms!.length.toString()} Consent Uploaded",
                //         style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w600,
                //             color: getStatusColor(statusKey)),
                //       )
                //     :

                Row(
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
                      // status=="1"?"pending":
                      // status=="2"?"Awaiting Approval":
                      // status=="3"?"Approved":status=="4"?"Rejected":"pending",
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
                    ? MoreOptionsMenu(
                        selectedIndex: selectedIndex,
                        status: status,
                        surveyListing: surveyListing[index],
                        consentRequired: 1,
                      )
                    // GestureDetector(
                    //     onTap: () {
                    //       _openExpandedView(
                    //         context,
                    //         surveyListing[index]
                    //             .consentForms
                    //             .map((path) => File(path.localPath))
                    //             .toList(),
                    //       );
                    //     },
                    //     child: Icon(
                    //       Icons.remove_red_eye,
                    //       color: CommonColors.blue,
                    //     ))
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
            // Text("CONSENT COUNT ${surveyListing[index].consentForms.length}"),
            FutureBuilder<List<SurveyMediaModel>>(
  future: DatabaseHelper.instance.getSurveyMedia(
    surveyListing[index].surveyId!,
  ),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const SizedBox();

    final consentList =
        snapshot.data!.where((m) => m.mediaType == 'consent').toList();

    if (consentList.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("TOTAL CONSENT ${consentList.length}"),
        UploadConsentWidget(
          uploadconsent: true,
          surveyListing: surveyListing[index],
        ),
      ],
    );
  },
)

            // surveyListing[index].consentAvailable == 1
            //     ? Container()
            //     : surveyListing[index].surveyStatus == CommonStrings.strRequired
            //         ?
            // surveyListing[index].consentForms.isNotEmpty
            //     ? Column(
            //         children: [
            //           UploadConsentWidget(
            //             uploadconsent: true,
            //             surveyListing: surveyListing[index],
            //           )
            //         ],
            //       )
            //     : Container()
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
  final int consentRequired;

  const MoreOptionsMenu(
      {super.key,
      required this.status,
      required this.surveyListing,
      required this.selectedIndex,
      this.consentRequired = 0});

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

    final uploadConsent =
        LanguageStrings.languages[lang]?['upload_consent'] ?? 'Upload Consent';

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
      items: widget.consentRequired == 1
          ? [
              PopupMenuItem(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => ConsentFormScreen(
                              SurveyID: widget.surveyListing!.surveyId!,
                            )),
                  );
                },
                child: Text(uploadConsent),
              ),
            ]
          : [
              PopupMenuItem(
                onTap: () {
     
                  Future.delayed(Duration.zero, () async {
                    final result = await Navigator.of(context).push(
                      createSlideFromBottomRoute(
                        SurveyDetailForm(
                          isEdit: 1,
                          surveyListing: widget.surveyListing,
                        ),
                      ),
                    );
               
                    if (result != null) {
               
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
                  final provider =
                      Provider.of<AppProvider>(context, listen: false);
                  var status1 =
                      await ConnectionDetector.checkInternetConnection();
                  if (widget.surveyListing!.serverSynced == 1 && status1) {
                    showConfirmDialog(routeGlobalKey.currentContext!, "DELETE",
                        "Are You Sure want to delete survey from server and Local ? ",
                        () async {
                      provider.deleteLandList(
                          widget.surveyListing!.surveyId!.toString());
                      await DatabaseHelper.instance
                          .deleteSurvey(widget.surveyListing!.id!);
                      await DatabaseHelper.instance.deleteAllSurveyMedia(
                          widget.surveyListing!.surveyId!);
                      provider.loadSPendingurveys();
                      provider.loadSurveys();
                      provider.loadConsentSurveys();
                      provider.refreshDashboard();
                    });
                  } else {
                    showConfirmDialog(routeGlobalKey.currentContext!, "DELETE",
                        "Are You Sure want to delete survey from Local DB ? ",
                        () async {
                      await DatabaseHelper.instance
                          .deleteSurvey(widget.surveyListing!.id!);
                      await DatabaseHelper.instance.deleteAllSurveyMedia(
                          widget.surveyListing!.surveyId!);
                      provider.loadSPendingurveys();
                      provider.loadSurveys();
                      provider.loadConsentSurveys();
                      provider.refreshDashboard();
                    });
                  }
                },
                child: Text(deleteLabel),
              ),
              if (widget.surveyListing!.isReadyForSync() &&
                  widget.surveyListing!.surveyStatus == "pending")
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(Duration.zero, () async {
                      final context0 = routeGlobalKey.currentContext!;

                      var status1 =
                          await ConnectionDetector.checkInternetConnection();
                      final basicFormProvider = Provider.of<BasicFormProvider>(
                          context0,
                          listen: false);
                      final provider =
                          Provider.of<AppProvider>(context0, listen: false);

                      if (!status1) {
                        showToast("No Internet Connection");
                        return;
                      }

                      // 🔄 SHOW LOADER
                      showLoader(context0, text: "Syncing survey...");

                      try {
                        if (widget.surveyListing!.serverSynced == 1) {
                          await basicFormProvider.updateMultipleLandSurvey(
                            widget.surveyListing!,
                            widget.surveyListing!.id!,
                          );
                        } else {
                          await basicFormProvider.submitMultipleLandSurvey(
                            widget.surveyListing!,
                          );
                        }

                        await provider.loadSPendingurveys();
                        await provider.loadSurveys();
                        await provider.loadConsentSurveys();
                        await provider.refreshDashboard();
                      } catch (e) {
                        showToast("Sync failed");
                      } finally {
                        // ❌ CLOSE LOADER
                        Navigator.pop(context0);
                      }
                    });
                  },
                  child: Text(syncNow),
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

  void showLoader(BuildContext context, {String text = "Syncing..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(text)),
          ],
        ),
      ),
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
  List<SurveyMediaModel> selectedFiles = [];

  String _getMediaType(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(ext)) return 'image';
    if (ext == 'pdf') return 'pdf';
    return 'file';
  }
Future<void> _pickFiles() async {
  final storageGranted = await Permission.storage.request().isGranted ||
      await Permission.photos.request().isGranted;

  if (!storageGranted) {
    showToast("Storage permission denied");
    return;
  }

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  );

  if (result == null) return;

  // 🔹 Convert picked files → SurveyMediaModel
  final newMedia = result.paths
      .where((p) => p != null)
      .map(
        (p) => SurveyMediaModel(
          surveyLocalId: widget.surveyListing.surveyId!,
          serverMediaId: "",
          isdeleted: 0,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          mediaType: 'consent', // 🔥 ALWAYS consent here
          localPath: p!,
          isSynced: 0,
        ),
      )
      .toList();

  // 🔹 Update UI immediately
  setState(() {
    selectedFiles.addAll(newMedia);
  });

  // 🔹 Persist ONLY in survey_media table
  await DatabaseHelper.instance.insertSurveyMediaList(
    surveyLocalId: widget.surveyListing.surveyId!,
    landPictures: [],
    surveyForms: [],
    consentForms: newMedia,
  );

  // 🔹 Open preview
  _openExpandedView();
}

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
//           selectedFiles.addAll(
//             result.paths.where((p) => p != null).map(
//                   (p) => SurveyMediaModel(
//                     surveyLocalId:
//                         widget.surveyListing.surveyId!.toString(), // local DB id
//                     serverMediaId: "",
//                     isdeleted: 0,
//                     createdAt: 0,
//                     mediaType: _getMediaType(p!),
//                     localPath: p,
//                     isSynced: 0,
//                   ),
//                 ),
//           );

//           widget.surveyListing.consentForms != selectedFiles;
// print("selectedFiles${selectedFiles.length}");
   
//         });

        

//         await DatabaseHelper.instance.insertSurveyMediaList(
//           surveyLocalId: widget.surveyListing.surveyId!.toString(),

//           landPictures: [], //landPictures,

//           surveyForms: [], //surveyForms,

//           consentForms: selectedFiles, // not available at creation time
//         );
        
//         final List<String> consentPaths =
//             selectedFiles.map((file) => file.localPath).toList();

//         final String pathsJson = jsonEncode(consentPaths);

//         final rows = await DatabaseHelper.instance.updateConsentFormBySurveyId(
//           surveyId: widget.surveyListing.surveyId!.toString(),
//           consentFormsJson: pathsJson,
//         );
// final provider = context.read<AppProvider>();
// await provider.refreshConsentForSurvey(widget.surveyListing.surveyId!.toString());
//         if (rows > 0) {
//           print("✅ Consent form updated");
//         }
// //           await DatabaseHelper.instance.updateSurveyConsentForm(consentForm: selectedFiles,
// //           surveyId: widget.surveyListing.id!.toString(),
// // );
//       }
//       _openExpandedView();
//     } else {
//       print("Permission denied");
//     }
//   }

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
                        // final file = selectedFiles[index];
                        // final ext = file.localPath.split('.').last.toLowerCase();
                        // final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
                        final media = selectedFiles[index];
                        final ext =
                            media.localPath.split('.').last.toLowerCase();
                        final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
                        final file = File(media.localPath);
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
                            final basicFormProvider =
                                Provider.of<BasicFormProvider>(context,
                                    listen: false);
                      
                            basicFormProvider.uploadConsentLandSurvey(
                                selectedFiles, widget.surveyListing.surveyId!);
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

  // void loadDbFiles() {
  //   final dbFiles = widget.surveyListing.consentForms;

  //   if (dbFiles != null && dbFiles.isNotEmpty) {
  //     setState(() {
  //       selectedFiles.addAll(dbFiles);
  //     });
  //   }
  // }
Future<void> loadDbFiles() async {
  final media = await DatabaseHelper.instance
      .getSurveyMedia(widget.surveyListing.surveyId!);

  final consent = media.where((m) => m.mediaType == 'consent').toList();

  setState(() {
    selectedFiles = consent;
  });
}

  // void loadDbFiles() {
  //   if (widget.surveyListing.consentForms != null) {
  //     setState(() {
  //       selectedFiles.addAll(
  //         widget.surveyListing.consentForms!
  //             .map((path) => File(path.localPath)) // convert String → File
  //             .toList(),
  //       );
  //     });
  //   }
  // }

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
                        // final file = selectedFiles[index];

                        // // Check if this is a local file or DB file (string url)
                        // final isLocalFile = file is File;
                        // final String path =
                        //     isLocalFile ? file.path : file.toString();
                        // final ext = path.split('.').last.toLowerCase();
                        // final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
                        final media = selectedFiles[index];
                        final path = media.localPath;

                        final ext = path.split('.').last.toLowerCase();
                        final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

                        final file = File(path);
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
                                        child: isImage
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
