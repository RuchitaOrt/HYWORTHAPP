import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/widgets/CommonAppBar.dart';
import 'package:hyworth_land_survey/widgets/GetversionFile.dart';
import 'package:hyworth_land_survey/widgets/SearchableDropdown.dart';
import 'package:hyworth_land_survey/widgets/TextWithAsterisk.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class ConsentFormScreen extends StatefulWidget {
  @override
  State<ConsentFormScreen> createState() => _ConsentFormScreenState();
}

class _ConsentFormScreenState extends State<ConsentFormScreen> {
  List<File> selectedFiles = [];

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
                if(surveyid=="")
                {
showSnackBar(context,"Select Suvery Id against which consent form to be added");
                }
                else{
final db = await DatabaseHelper.instance.database; // get your Database instance

List<Map<String, dynamic>> result = await db.query(
  'surveys',
  columns: ['consentForms'],
  where: 'surveyId = ?',
  whereArgs: [surveyid],
);

Map<String, dynamic>? existingRow;
if (result.isNotEmpty) {
  existingRow = result.first; // get the first row
} else {
  existingRow = null; // no row found
}

List<String> existingFiles = [];
if (existingRow != null && existingRow['consentForms'] != null) {
  existingFiles = List<String>.from(jsonDecode(existingRow['consentForms']));
}
// Get paths of new files
List<String> newFiles = selectedFiles
    .where((file) => file != null)
    .map((file) => file!.path)
    .toList();

// Merge existing + new (avoid duplicates)
Set<String> allFiles = {...existingFiles, ...newFiles};
String pathsJson = jsonEncode(allFiles.toList());
int count = await DatabaseHelper.instance.updateRaw(
  'UPDATE surveys SET consentForms = ? WHERE surveyId = ?',
  [pathsJson, surveyid],
);

if (count > 0) {
  print('Update successful! $count row(s) updated.');
} else {
  print('Update failed or no row found with surveyId=$surveyid.');
  showSnackBar(context,"Suvery Id Not Found in database");
}

Navigator.pop(context,true);
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
        child: Column(
          children: [
            SearchableDropdown(
              title: t(context, "survey_no"),
              hintText: t(context, "select_survey_no"),
              asyncItems: (filter, loadProps) async {
                final data = await DatabaseHelper.instance.getAllSurveys();
                final surveyMaps = data
                    .map((e) => {
                          'id': e.surveyId.toString(),
                          'lat': e.landLatitude.toString(),
                          'long': e.landLongitude.toString(),
                          'area': e.landVillage.toString(),
                        })
                    .toList();

                if (filter.isEmpty) return surveyMaps;

                return surveyMaps
                    .where((e) =>
                        e['id']!.contains(filter) ||
                        e['lat']!.contains(filter) ||
                        e['long']!.contains(filter) ||
                        e['area']!.contains(filter))
                    .toList();
              },
              filterKeys: ['id', 'lat', 'long', 'area'],
              compareKey: 'id',
              displayString: (item) =>
                  "Survey No: ${item['id']},Lat:${item['lat']},Long: ${item['long']}, Area: ${item['area']}",
              onChanged: (value) {
                print("Selected: $value");
                surveyid = "${value!['id']}";
                print("${value!['id']}");
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
                final isPdf = file.path.toLowerCase().endsWith('.pdf');

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
                        _openFile(file);
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
                                          file,
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
          selectedFiles.addAll(result.paths.map((p) => File(p!)));
        });
      }
    } else {
      print("Permission denied");
    }
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }
}
