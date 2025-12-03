import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonstrings.dart';
import 'package:hyworth_land_survey/Utils/sizeConfig.dart';
import 'package:hyworth_land_survey/widgets/TextWithAsterisk.dart';

import 'package:hyworth_land_survey/widgets/custom_text_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OtherDetail extends StatefulWidget {
  const OtherDetail({Key? key}) : super(key: key);

  @override
  State<OtherDetail> createState() => _OtherDetailFormState();
}

class _OtherDetailFormState extends State<OtherDetail> {

Future<void> pickImage(BasicFormProvider provider) async {
  // use image_picker or file_picker
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    provider.setImage(File(pickedFile.path));
  }
}

  void removeImage(int index,BasicFormProvider basicFormprovider) {
    setState(() {
      basicFormprovider.mediaFiles[index] = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    final basicFormProvider = Provider.of<BasicFormProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
        Text(
          t(context, "other_detail"),
          // CommonStrings.strOtherDetail,
          style: CommonStyles.tsblackHeading,
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 1),
       CustomTextFieldWidget(
  isMandatory: true,
  title: t(context, 'evacuation'),
  hintText: t(context, 'evacuation_hint'),
  onChange: (val) {},
  textEditingController: basicFormProvider.otherEvacuationController,
  autovalidateMode: AutovalidateMode.disabled,
),

CustomTextFieldWidget(
  isMandatory: true,
  title: t(context, 'type_of_soil'),
  hintText: t(context, 'type_of_soil_hint'),
  onChange: (val) {},
  textEditingController: basicFormProvider.typeofSoilController,
  autovalidateMode: AutovalidateMode.disabled,
  validator: basicFormProvider.validateState,
),

CustomTextFieldWidget(
  isMandatory: true,
  title: t(context, 'wind_zone'),
  hintText: t(context, 'wind_zone_hint'),
  onChange: (val) {},
  textEditingController: basicFormProvider.windZoneController,
  autovalidateMode: AutovalidateMode.disabled,
  validator: basicFormProvider.validateState,
),

CustomTextFieldWidget(
  isMandatory: true,
  title: t(context, 'ground_water_rainfall_type'),
  hintText: t(context, 'ground_water_rainfall_type'),
  onChange: (val) {},
  textEditingController: basicFormProvider.groundWaterController,
  autovalidateMode: AutovalidateMode.disabled,
  validator: basicFormProvider.validateState,
),

CustomTextFieldWidget(
  isMandatory: true,
  title: t(context, 'nearest_highway'),
  hintText: t(context, 'nearest_highway_hint'),
  onChange: (val) {},
  textEditingController: basicFormProvider.nearestHighwayController,
  autovalidateMode: AutovalidateMode.disabled,
  validator: basicFormProvider.validateState,
),

SizedBox(height: 10),
TextWithAsterisk(
  text: t(context, 'land_form_image'), // Add this key in your LanguageStrings
  isAstrick: true,
),
SizedBox(height: 10),
GestureDetector(
  onTap: () => pickImage(basicFormProvider),
  child: DottedBorder(
    borderType: BorderType.RRect,
    radius: const Radius.circular(8),
    color: CommonColors.blue.withOpacity(0.5),
    strokeWidth: 1,
    dashPattern: [8, 2],
    child: Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: basicFormProvider.mediaFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      basicFormProvider.mediaFile!,
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
          if (basicFormProvider.mediaFile != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => basicFormProvider.removeImage(),
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
  }

  
}
