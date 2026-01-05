import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:hyworth_land_survey/widgets/CommonAppBar.dart';
import 'package:hyworth_land_survey/widgets/GetversionFile.dart';
import 'package:hyworth_land_survey/widgets/SearchableDropdown.dart';
import 'package:hyworth_land_survey/widgets/TextWithAsterisk.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ConsentFormScreen extends StatefulWidget {
  final String? SurveyID;

  const ConsentFormScreen({super.key, this.SurveyID});
  @override
  State<ConsentFormScreen> createState() => _ConsentFormScreenState();
}

class _ConsentFormScreenState extends State<ConsentFormScreen> {
  List<SurveyMediaModel> selectedFiles = [];

  final FocusNode _focusNode = FocusNode();

  final BorderSide enableBorder = BorderSide(
    color: CommonColors.background,
    // color: CraftColors.neutral20Color,
    width: 1.0,
  );

  final BorderRadius borderRadius = const BorderRadius.all(
    Radius.circular(8),
  );

  final BorderSide focusedBorder = const BorderSide(
    color: CommonColors.blue,
    width: 1.0,
  );
  void _openFile(File file) {
    OpenFilex.open(file.path);
  }

  String surveyid = "";
  late TextEditingController _surveyIdController;
Map<String, String>? _selectedSurvey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    surveyid = widget.SurveyID!;

  if (widget.SurveyID != null) {
    _loadPreselectedSurvey(widget.SurveyID!);
  }
    // _surveyIdController = TextEditingController(
    //   text: surveyid,
    // );
    // Future.microtask(() => getData());
  }
Future<void> _loadPreselectedSurvey(String surveyId) async {
  final data =
      await DatabaseHelper.instance.getApprovedAndAwaitingSurveys();

  final match = data.firstWhere(
    (e) => e.surveyId.toString() == surveyId,
    // orElse: () => null,
  );

  if (match != null) {
    setState(() {
      _selectedSurvey = {
        'id': match.surveyId.toString(),
        'lat': match.landLatitude.toString(),
        'long': match.landLongitude.toString(),
        'area': match.landVillage.toString(),
      };

      this.surveyid = surveyId;
    });
  }
}
Future<void> loadDbFiles(String surveyID) async {
  final media = await DatabaseHelper.instance
      .getSurveyMedia(surveyID);

  final consent = media.where((m) => m.mediaType == 'consent').toList();

  setState(() {
    selectedFiles = consent;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: t(context, "add_consent"),
        isCloseIconVisible: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            bottom: 4, left: 50, right: 50), // no insets here
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
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
                // Fetch existing consent forms for this surveyId
                if (surveyid == "") {
                  showSnackBar(context,
                      "Select Suvery Id against which consent form to be added");
                } else {
                  final mediaList =
                      await DatabaseHelper.instance.getSurveyMedia(surveyid);
                  print("EDIT MEDIA FROM DB");
                  print(mediaList.length);

                  final consentFormsMedia =
                      mediaList.where((m) => m.mediaType == 'consent').toList();

                  print("MEDIA LISTING");

                  //CONSENT FORM
                  final existingConsent = consentFormsMedia.map((media) {
                    return SurveyMediaModel(
                      surveyLocalId: surveyid,
                      mediaType: 'consent',
                      serverMediaId: media.serverMediaId,
                      localPath: media.localPath,
                      isSynced: media.isSynced, // keep real state
                      isdeleted: 0,
                      createdAt: media.createdAt,
                    );
                  }).toList();

                  final existingConsentPath =
                      existingConsent.map((e) => e.localPath).toSet();

                  final newConsent = selectedFiles
                      .where((file) =>
                          file != null &&
                          !existingConsentPath.contains(file.localPath))
                      .map((file) => SurveyMediaModel(
                            surveyLocalId: surveyid,
                            mediaType: 'consent',
                            serverMediaId: "",
                            localPath: file!.localPath,
                            isSynced: 0,
                            isdeleted: 0,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                          ))
                      .toList();

                  final consentForm = [
                    ...existingConsent,
                    ...newConsent,
                  ];

                  await DatabaseHelper.instance.insertSurveyMediaList(
                    surveyLocalId: surveyid, // keep as String
                    landPictures: [],
                    surveyForms: [],
                    consentForms: consentForm,
                  );
                  final List<String> consentPaths =
                      selectedFiles.map((file) => file.localPath).toList();

                  final String pathsJson = jsonEncode(consentPaths);

                  final rows =
                      await DatabaseHelper.instance.updateConsentFormBySurveyId(
                    surveyId: surveyid,
                    consentFormsJson: pathsJson,
                  );

                  if (rows > 0) {
                    print("✅ Consent form updated");
                  }

//
                  final provider = context.read<AppProvider>();
                  await provider.refreshConsentForSurvey(surveyid);

                  Navigator.pop(context, true);
                }
              },
              child: Text(
                t(context, "upload_consent_forn"),
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            // surveyid.isNotEmpty
            //     ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           TextWithAsterisk(
            //             text: t(context, "survey_no"),
            //             isAstrick: true,
            //           ),
            //           const SizedBox(height: 6),
            //           TextField(
            //             controller: _surveyIdController,
            //             enabled: false, // 🔒 disable editing
            //             decoration: InputDecoration(
            //               hintText: t(context, "survey_no"),
            //               disabledBorder: OutlineInputBorder(
            //                 borderRadius: borderRadius,
            //                 borderSide: enableBorder,
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     :
                SearchableDropdown(
  title: t(context, "survey_no"),
  hintText: t(context, "select_survey_no"),

  selectedItem: _selectedSurvey, // 🔥 REQUIRED

  asyncItems: (filter, loadProps) async {
    final data =
        await DatabaseHelper.instance.getApprovedAndAwaitingSurveys();

    final surveyMaps = data
        .map((e) => {
              'id': e.surveyId.toString(),
              'lat': e.landLatitude.toString(),
              'long': e.landLongitude.toString(),
              'area': e.landVillage.toString(),
            })
        .toList();

    if (filter.isEmpty) return surveyMaps;

    return surveyMaps.where((e) =>
        e['id']!.contains(filter) ||
        e['lat']!.contains(filter) ||
        e['long']!.contains(filter) ||
        e['area']!.contains(filter)).toList();
  },

  filterKeys: ['id', 'lat', 'long', 'area'],
  compareKey: 'id',

  displayString: (item) =>
      "Survey No: ${item['id']}, Lat:${item['lat']}, Long:${item['long']}, Area:${item['area']}",

  onChanged: (value) {
    setState(() {
      _selectedSurvey = {
        'id': value!['id']!,
        'lat': value['lat']!,
        'long': value['long']!,
        'area': value['area']!,
      };
      surveyid = value['id']!;

      loadDbFiles(surveyid);
    });
  },
),

               
            SizedBox(
              height: 20,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedFiles.length + 1, // +1 for Add File box
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                // Last box -> Add File
                if (index == selectedFiles.length) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 6),
                        child: TextWithAsterisk(
                          text: t(context, "add_file"),
                          isAstrick: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _pickFiles(),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8),
                          color: CommonColors.blue.withOpacity(0.5),
                          strokeWidth: 1,
                          dashPattern: [8, 2],
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: CommonColors.blue,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final file = selectedFiles[index];
                final isPdf = file.localPath.toLowerCase().endsWith('.pdf');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 6),
                      child: TextWithAsterisk(
                        text: "${t(context, "file")} ${index + 1}",
                        isAstrick: true,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _openFile(File(file.localPath!));
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(8),
                        color: CommonColors.blue.withOpacity(0.5),
                        strokeWidth: 1,
                        dashPattern: [8, 2],
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: isPdf
                                    ? const Center(
                                        child: Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(file.localPath),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _removeFile(index),
                                  child: const CircleAvatar(
                                    backgroundColor: CommonColors.grey75,
                                    radius: 12,
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

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
          selectedFiles.addAll(
            result.paths.where((p) => p != null).map(
                  (p) => SurveyMediaModel(
                    surveyLocalId: surveyid, // local DB id
                    serverMediaId: "",
                    isdeleted: 0,
                    createdAt: 0,
                    mediaType: _getMediaType(p!),
                    localPath: p,
                    isSynced: 0,
                  ),
                ),
          );
          // selectedFiles.addAll(result.paths.map((p) => File(p!)));
        });
      }
// final basicFormProvider = Provider.of<BasicFormProvider>(context, listen: false);

//       basicFormProvider.setConsentMediaFile(
//     index,
//     File(picked.path),
//     "", // 👈 NO !
//   );
    } else {
      print("Permission denied");
    }
  }

  String _getMediaType(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(ext)) return 'image';
    if (ext == 'pdf') return 'pdf';
    return 'file';
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }
}
