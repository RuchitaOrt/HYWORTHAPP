import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyworth_land_survey/Provider/Basic_form_provider.dart';
import 'package:hyworth_land_survey/Screens/LocationHelper.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonstrings.dart';
import 'package:hyworth_land_survey/Utils/sizeConfig.dart';
import 'package:hyworth_land_survey/widgets/CustomDropdownField.dart';
import 'package:hyworth_land_survey/widgets/SearchableDropdown.dart';
import 'package:hyworth_land_survey/widgets/custom_text_field_widget.dart';
import 'package:provider/provider.dart';

class SubStaionDetailForm extends StatefulWidget {
  const SubStaionDetailForm({Key? key}) : super(key: key);

  @override
  State<SubStaionDetailForm> createState() => _SubStaionDetailFormState();
}

class _SubStaionDetailFormState extends State<SubStaionDetailForm> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      askLocationConfirmation(context, "Substation");
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
          t(context, 'substation_detail'),
          style: CommonStyles.tsblackHeading,
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 1),
        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'substation_name_val'),
          hintText: t(context, 'substation_name_hint'),
          onChange: (val) {},
          textEditingController: basicFormProvider.subStationNameController,
          autovalidateMode: AutovalidateMode.disabled,
        ),
        SearchableDropdown(
          title: t(context, 'substation_district'),
          hintText: t(context, "substation_district_hint"),
           asyncItems: (filter, loadProps) async {
            final districtList = await basicFormProvider.fetchDistrict();

            // Convert to Map<String, String>
            final stateMaps = districtList.map((d) {
              return {
                'id': (d.id).toString(),
                'district_name': d.districtName ?? "",
              };
            }).toList();

            if (filter.isEmpty) return stateMaps;

            final lowerFilter = filter.toLowerCase();

            return stateMaps.where((d) {
              final idString = d['id']!;
              final nameString = d['district_name']!.toLowerCase();

              return idString.contains(lowerFilter) ||
                  nameString.contains(lowerFilter);
            }).toList();
          },
            selectedItem: (basicFormProvider.selectedsubstationDistrict != null &&
                 basicFormProvider.selectedsubstationDistrict!['id']!.isNotEmpty)
      ? basicFormProvider.selectedsubstationDistrict
      : null,
          filterKeys: ['id', 'district_name'],
          compareKey: 'id',
          displayString: (item) => "${item['district_name']}",
          onChanged: (value) {
            print("Selected District: $value");
            basicFormProvider.selectedsubstationDistrict = {
              'id': "${value!['id']}",
              'district_name': "${value!['district_name']}",
            };
          },
        ),
// Taluka dropdown
        SearchableDropdown(
          title: t(context, 'substation_taluka'),
          hintText: t(context, "substation_taluka_hint"),
          asyncItems: (filter, loadProps) async {
            final stateList = await basicFormProvider.fetchTaluka();

            // Convert to Map<String, String>
            final stateMaps = stateList.map((d) {
              return {
                'id': (d.id ?? 0).toString(),
                'taluka_name': d.talukaName ?? "",
              };
            }).toList();

            if (filter.isEmpty) return stateMaps;

            final lowerFilter = filter.toLowerCase();

            return stateMaps.where((d) {
              final idString = d['id']!;
              final nameString = d['taluka_name']!.toLowerCase();

              return idString.contains(lowerFilter) ||
                  nameString.contains(lowerFilter);
            }).toList();
          },
          filterKeys: ['id', 'taluka_name'],
          compareKey: 'id',
          displayString: (item) => "${item['taluka_name']}",
          selectedItem: (basicFormProvider.selectedsubstationTaluka != null &&
                 basicFormProvider.selectedsubstationTaluka!['id']!.isNotEmpty)
      ? basicFormProvider.selectedsubstationTaluka
      : null,
          onChanged: (value) {
            print("Selected Taluka: $value");
            basicFormProvider.selectedsubstationTaluka = {
              'id': "${value!['id']}",
              'taluka_name': "${value!['taluka_name']}",
            };
          },
        ),

// Village dropdown
SearchableDropdown(
  title: t(context, 'substation_village'),
  hintText: t(context, "substation_village_hint"),

  selectedItem: (basicFormProvider.selectedsubstationVillage != null &&
          basicFormProvider.selectedsubstationVillage!['id']!.isNotEmpty)
      ? basicFormProvider.selectedsubstationVillage
      : null,

asyncItems: (filter, loadProps) async {
  final rows = await basicFormProvider.searchVillage(filter);
        print("Village");
print(rows.length);
  return rows.map<Map<String, String>>((e) {
    return {
      'id': e['id'].toString(),
      'village_name': (e['village_name'] ?? "").toString(),
    };
  }).toList();

  
},

  filterKeys: ['id', 'village_name'],
  compareKey: 'id',
  displayString: (item) => item['village_name'] ?? "",

  onChanged: (value) {
    basicFormProvider.selectedsubstationVillage = {
      'id': value!['id']!,
      'village_name': value['village_name']!,
    };
  },
),
      //   SearchableDropdown(
      //     title: t(context, 'substation_village'),
      //     hintText: t(context, "substation_village_hint"),
      //       asyncItems: (filter, loadProps) async {
      //       final stateList = await basicFormProvider.fet();

      //       // Convert to Map<String, String>
      //       final stateMaps = stateList.map((d) {
      //         return {
      //           'id': (d.id ?? 0).toString(),
      //           'village_name': d.villageName ?? "",
      //         };
      //       }).toList();

      //       if (filter.isEmpty) return stateMaps;

      //       final lowerFilter = filter.toLowerCase();

      //       return stateMaps.where((d) {
      //         final idString = d['id']!;
      //         final nameString = d['village_name']!.toLowerCase();

      //         return idString.contains(lowerFilter) ||
      //             nameString.contains(lowerFilter);
      //       }).toList();
      //     },
      //     filterKeys: ['id', 'village_name'],
      //     compareKey: 'id',
      //     displayString: (item) => "${item['village_name']}",
      //     selectedItem: (basicFormProvider.selectedsubstationVillage != null &&
      //            basicFormProvider.selectedsubstationVillage!['id']!.isNotEmpty)
      // ? basicFormProvider.selectedsubstationVillage
      // : null,
      //     onChanged: (value) {
      //       print("Selected Village: $value");
      //       basicFormProvider.selectedsubstationVillage = {
      //         'id': "${value!['id']}",
      //         'name': "${value['village_name']}",
      //       };
      //     },
      //   ),

// CustomTextFieldWidget(
//   isMandatory: true,
//   title: t(context, 'substation_district'),
//   hintText: t(context, 'substation_district_hint'),
//   onChange: (val) {},
//   textEditingController: basicFormProvider.subStationDistrictController,
//   autovalidateMode: AutovalidateMode.disabled,
//   validator: basicFormProvider.validateState,
// ),

// CustomTextFieldWidget(
//   isMandatory: true,
//   title: t(context, 'substation_taluka'),
//   hintText: t(context, 'substation_taluka_hint'),
//   onChange: (val) {},
//   textEditingController: basicFormProvider.subStationTalukaController,
//   autovalidateMode: AutovalidateMode.disabled,
//   validator: basicFormProvider.validateState,
// ),

// CustomTextFieldWidget(
//   isMandatory: true,
//   title: t(context, 'substation_village'),
//   hintText: t(context, 'substation_village_hint'),
//   onChange: (val) {},
//   textEditingController: basicFormProvider.subStationVillageController,
//   autovalidateMode: AutovalidateMode.disabled,
//   validator: basicFormProvider.validateState,
// ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'substation_lat'),
          hintText: t(context, 'substation_lat_hint'),
          onChange: (val) {},
          textEditingController: basicFormProvider.subStationLatitudeController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,6}')),
          ],
          suffixIcon: GestureDetector(
              onTap: () {
                askLocationConfirmation(context, "Substation");
              },
              child: Icon(
                Icons.location_on,
                color: CommonColors.blue,
                size: 20,
              )),
          textInputType: TextInputType.numberWithOptions(decimal: true),
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'substation_long'),
          hintText: t(context, 'substation_long_hint'),
          onChange: (val) {},
          textEditingController:
              basicFormProvider.subStationLongitudeController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,6}')),
          ],
          suffixIcon: GestureDetector(
              onTap: () {
                askLocationConfirmation(context, "Substation");
              },
              child: Icon(
                Icons.location_on,
                color: CommonColors.blue,
                size: 20,
              )),
          textInputType: TextInputType.numberWithOptions(decimal: true),
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'substation_incharge_contact'),
          hintText: t(context, 'substation_incharge_contact_hint'),
          onChange: (val) {},
          maxCharacterLength: 10,
          isMaxCharacterHintVisible: false,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textEditingController:
              basicFormProvider.subStationInchargeContactController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'substation_incharge_name'),
          hintText: t(context, 'substation_incharge_name_hint'),
          onChange: (val) {},
          textEditingController:
              basicFormProvider.subStationInchargeNameController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'operator_name'),
          hintText: t(context, 'operator_name_hint'),
          onChange: (val) {},
          textEditingController:
              basicFormProvider.subStationOperatorNameController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'operator_contact'),
          hintText: t(context, 'operator_contact_hint'),
          onChange: (val) {},
          maxCharacterLength: 10,
          isMaxCharacterHintVisible: false,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textEditingController:
              basicFormProvider.subStationOperatorContactController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'substation_voltage_level'),
          hintText: t(context, 'substation_voltage_level_hint'),
          onChange: (val) {},
          textEditingController:
              basicFormProvider.subStationVoltageLevelController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'substation_capacity'),
          hintText: t(context, 'substation_capacity_hint'),
          onChange: (val) {},
          textEditingController: basicFormProvider.subStationCapacityController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'distance'),
          hintText: t(context, 'distance_hint'),
          onChange: (val) {},
          textEditingController:
              basicFormProvider.subStationDistancebtwLandController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),

        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'plot_distance'),
          hintText: t(context, 'plot_distance_hint'),
          onChange: (val) {},
          textEditingController:
              basicFormProvider.subStationDistancebtwPlotController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),
      ],
    );
  }
}
