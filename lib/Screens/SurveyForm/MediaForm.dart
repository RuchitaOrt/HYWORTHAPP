import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/sizeConfig.dart';
import 'package:hyworth_land_survey/widgets/TextWithAsterisk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MediaForm extends StatefulWidget {
  const MediaForm({Key? key}) : super(key: key);

  @override
  State<MediaForm> createState() => _MediaFormState();
}

class _MediaFormState extends State<MediaForm> {

  // Future<void> pickImage(int index, BasicFormProvider basicFormProvider) async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     basicFormProvider.setMediaFile(index, File(picked.path),basicFormProvider.surverID!);
  //   }
  // }
Future<void> pickImage(
  int index,
  BasicFormProvider basicFormProvider,
) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked == null) return;

  basicFormProvider.setMediaFile(
    index,
    File(picked.path),
    "", // 👈 NO !
  );
}

  void removeImage(int index, BasicFormProvider basicFormProvider) {
    basicFormProvider.removeMediaFile(index);
  }

  @override
  Widget build(BuildContext context) {
    final basicFormProvider = Provider.of<BasicFormProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t(context, "land_images"), // localized
          style: CommonStyles.tsblackHeading,
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
       GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: 7,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 0.85,
  ),
  itemBuilder: (context, index) {
    final file = index < basicFormProvider.OtherLandmediaFiles.length
        ? basicFormProvider.OtherLandmediaFiles[index]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: TextWithAsterisk(
            text: "${t(context, "land_images")} ${index + 1}",
            isAstrick: true,
          ),
        ),
        GestureDetector(
          onTap: () => pickImage(index, basicFormProvider),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            color: file != null
                ? CommonColors.white
                : CommonColors.blue.withOpacity(0.5),
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
                    child: file != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                             File(file.localPath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: CommonColors.blue,
                              size: 30,
                            ),
                          ),
                  ),
                  if (file != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () =>
                        
                        basicFormProvider.surverID==null?basicFormProvider.removeMediaFile(index): basicFormProvider.removeImageLandImages(index, basicFormProvider,basicFormProvider.surverID!,basicFormProvider.OtherLandmediaFiles[index]!.serverMediaId.toString(),File(basicFormProvider.OtherLandmediaFiles[index]!.localPath)),
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

      ],
    );
  }
}

// import 'dart:io';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
// import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
// import 'package:hyworth_land_survey/Utils/commoncolors.dart';
// import 'package:hyworth_land_survey/Utils/sizeConfig.dart';
// import 'package:hyworth_land_survey/widgets/TextWithAsterisk.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class MediaForm extends StatefulWidget {
//   const MediaForm({Key? key}) : super(key: key);

//   @override
//   State<MediaForm> createState() => _MediaFormState();
// }

// class _MediaFormState extends State<MediaForm> {
//   final List<String> labels = [
//     "Image 1",
//     "Image 2",
//     "Image 3",
//     "Image 4",
//     "Image 5",
//     "Image 6",
//     "Image 7",
//   ];

//   Future<void> pickImage(int index, BasicFormProvider basicFormProvider) async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       // setState(() {
//       //   basicFormProvider.mediaFiles[index] = File(picked.path);
//       // });
//       basicFormProvider.setMediaFile(index, File(picked.path));
//     }
//   }

//   void removeImage(int index, BasicFormProvider basicFormProvider) {
//     // setState(() {
//     //   basicFormProvider.mediaFiles[index] = null;
//     // });
//     basicFormProvider.removeMediaFile(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final basicFormProvider = Provider.of<BasicFormProvider>(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Land Images", style: CommonStyles.tsblackHeading),
//         SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: basicFormProvider.mediaFiles.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             childAspectRatio: 1,
//           ),
//           itemBuilder: (context, index) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.only(left: 4, bottom: 6),
//                     child: TextWithAsterisk(
//                       text: labels[index],
//                     )),
//                 GestureDetector(
//                   onTap: () => pickImage(index, basicFormProvider),
//                   child: DottedBorder(
//                     borderType: BorderType.RRect,
//                     radius: const Radius.circular(8),
//                     color: basicFormProvider.mediaFiles[index] != null
//                         ? CommonColors.white
//                         : CommonColors.blue.withOpacity(0.5),
//                     strokeWidth: 1,
//                     dashPattern: [8, 2],
//                     child: Container(
//                       height: 160,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Stack(
//                         children: [
//                           Positioned.fill(
//                             child: basicFormProvider.mediaFiles[index] != null
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Image.file(
//                                       basicFormProvider.mediaFiles[index]!,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   )
//                                 : Center(
//                                     child: Icon(
//                                       Icons.camera_alt_outlined,
//                                       color: CommonColors.blue,
//                                       size: 30,
//                                     ),
//                                   ),
//                           ),
//                           if (basicFormProvider.mediaFiles[index] != null)
//                             Positioned(
//                               top: 8,
//                               right: 8,
//                               child: GestureDetector(
//                                 onTap: () =>
//                                     removeImage(index, basicFormProvider),
//                                 child: const CircleAvatar(
//                                   backgroundColor: CommonColors.grey75,
//                                   radius: 12,
//                                   child: Icon(Icons.close,
//                                       color: Colors.white, size: 14),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
