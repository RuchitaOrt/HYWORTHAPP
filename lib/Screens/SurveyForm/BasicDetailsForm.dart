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
import 'package:hyworth_land_survey/widgets/TextWithAsterisk.dart';
import 'package:hyworth_land_survey/widgets/custom_text_field_widget.dart';
import 'package:provider/provider.dart';

class BasicDetailsForm extends StatefulWidget {
  const BasicDetailsForm({Key? key}) : super(key: key);

  @override
  State<BasicDetailsForm> createState() => _BasicDetailsFormState();
}

class _BasicDetailsFormState extends State<BasicDetailsForm> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      askLocationConfirmation(context, "Basic");
    });
  }
String stateCode="";
String districtCode="";
  @override
  Widget build(BuildContext context) {
    final basicFormProvider = Provider.of<BasicFormProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.blockSizeVertical * 0.5),

        /// Section Heading
        Text(
          t(context, 'sub_basic_detail'),
          style: CommonStyles.tsblackHeading,
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 1),

        /// Land Details Fields
        // CustomTextFieldWidget(
        //   isMandatory: true,
        //   title: t(context, 'land_state'),
        //   hintText: t(context, 'land_state_hint'),
        //   onChange: (val) {},
        //   textEditingController: basicFormProvider.landStateController,
        //   autovalidateMode: AutovalidateMode.disabled,
        //   validator: basicFormProvider.validateState,
        // ),

        SearchableDropdown(
          title: t(context, 'land_state'),
          hintText: t(context, "land_state_hint"),
          selectedItem: (basicFormProvider.selectedLandState != null &&
                  basicFormProvider.selectedLandState!['id']!.isNotEmpty)
              ? basicFormProvider.selectedLandState
              : null, // null = show hint
          asyncItems: (filter, loadProps) async {
            final stateList = await basicFormProvider.fetchStates();

            // Convert to Map<String, String>
            final stateMaps = stateList.map((d) {
              return {
                'id': (d.id ?? 0).toString(),
                'name': d.name ?? "",
                "statecode":d.stateCode ?? ""
                
              };
            }).toList();
print("State");
print(stateMaps.length);
            if (filter.isEmpty) return stateMaps;

            final lowerFilter = filter.toLowerCase();

            return stateMaps.where((d) {
              final idString = d['id']!;
              final nameString = d['name']!.toLowerCase();

              return idString.contains(lowerFilter) ||
                  nameString.contains(lowerFilter);
            }).toList();
          },
           
          filterKeys: ['id', 'name'],
          compareKey: 'id',
          displayString: (item) => "${item['name']}",
          onChanged: (value) {
            print("Selected State: $value");
            basicFormProvider.selectedLandState = {
              'id': "${value!['id']}",
              'name': "${value['name']}",
               "statecode":"${value['statecode']}",
            };
print("Selected Statre: $value");
            stateCode=value['statecode'].toString();
            print("Selected Statre: ${value['statecode'].toString()}");

          },
        ),

        SearchableDropdown(
          title: t(context, 'land_district'),
          hintText: t(context, "select_district"),
          asyncItems: (filter, loadProps) async {
            final districtList = await basicFormProvider.fetchDistrict(stateCode: stateCode);

            // Convert to Map<String, String>
            final stateMaps = districtList.map((d) {
              return {
                'id': (d.id).toString(),
                'district_name': d.districtName ?? "",
                'districtcode':d.districtCode ??""
              };
            }).toList();
 print("District");
print(stateMaps.length);
            if (filter.isEmpty) return stateMaps;

            final lowerFilter = filter.toLowerCase();

            return stateMaps.where((d) {
              final idString = d['id']!;
              final nameString = d['district_name']!.toLowerCase();

              return idString.contains(lowerFilter) ||
                  nameString.contains(lowerFilter);
            }).toList();
            
          },
          
          filterKeys: ['id', 'district_name'],
          selectedItem: (basicFormProvider.selectedLandDistrict != null &&
                  basicFormProvider.selectedLandDistrict!['id']!.isNotEmpty)
              ? basicFormProvider.selectedLandDistrict
              : null,
          compareKey: 'id',
          displayString: (item) => "${item['district_name']}",
          onChanged: (value) {
            print("Selected district_name: $value");
            basicFormProvider.selectedLandDistrict = {
              'id': "${value!['id']}",
              'district_name': "${value!['district_name']}",
              'districtcode':"${value!['districtcode']}",
            };

             districtCode=value['districtcode'].toString();
             print("districtCode selected ${districtCode}");
          },
        ),
// Taluka dropdown
        SearchableDropdown(
          title: t(context, 'land_taluka'),
          hintText: t(context, "select_taluka"),
          asyncItems: (filter, loadProps) async {
            final talukaList = await basicFormProvider.fetchTaluka(districtCode:districtCode );

            // Convert to Map<String, String>
            final talukaMaps = talukaList.map((d) {
              return {
                'id': (d.id ).toString(),
                'taluka_name': d.talukaName ?? "",
                'districtcode':d.districtCode ??""
              };
            }).toList();
            print("TALUKA");
print(talukaMaps.length);
            if (filter.isEmpty) return talukaMaps;

            final lowerFilter = filter.toLowerCase();

            return talukaMaps.where((d) {
              final idString = d['id']!;
              final nameString = d['taluka_name']!.toLowerCase();

              return idString.contains(lowerFilter) ||
                  nameString.contains(lowerFilter);
            }).toList();
          },
          filterKeys: ['id', 'taluka_name'],
          selectedItem: (basicFormProvider.selectedLandTaluka != null &&
                  basicFormProvider.selectedLandTaluka!['id']!.isNotEmpty)
              ? basicFormProvider.selectedLandTaluka
              : null,
          compareKey: 'id',
          displayString: (item) => "${item['taluka_name']}",
          onChanged: (value) {
            print("Selected Taluka: $value");
            basicFormProvider.selectedLandTaluka = {
              'id': "${value!['id']}",
              'taluka_name': "${value!['taluka_name']}",
              "districtcode":"${value!['districtcode']}",
            };
             districtCode=value['districtcode'].toString();
             print("districtCode selected ${districtCode}");
          },
        ),

// Village dropdown
SearchableDropdown(
  title: t(context, 'land_village'),
  hintText: t(context, "select_village"),

  selectedItem: (basicFormProvider.selectedLandVillage != null &&
          basicFormProvider.selectedLandVillage!['id']!.isNotEmpty)
      ? basicFormProvider.selectedLandVillage
      : null,

asyncItems: (filter, loadProps) async {
  final rows = await basicFormProvider.searchVillage(filter,districtCode: districtCode);
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
    basicFormProvider.selectedLandVillage = {
      'id': value!['id']!,
      'village_name': value['village_name']!,
    };
  },
),

      
        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'land_lat'),
          hintText: t(context, 'land_lat_hint'),
          onChange: (val) {},
          textEditingController: basicFormProvider.landLatitudeController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,6}')),
          ],
          suffixIcon: GestureDetector(
              onTap: () {
                askLocationConfirmation(context, "Basic");
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
          title: t(context, 'land_long'),
          hintText: t(context, 'land_long_hint'),
          onChange: (val) {},
          textEditingController: basicFormProvider.landLonitudeController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,6}')),
          ],
          suffixIcon: GestureDetector(
              onTap: () {
                askLocationConfirmation(context, "Basic");
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
          title: t(context, 'land_area'),
          hintText: t(context, 'land_area_hint'),
          onChange: (val) {},
          textEditingController: basicFormProvider.landAreaController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),
        // CustomDropdownField(
        //   labelText: t(context, 'land_type_val'),
        //   hintText: t(context, 'land_type_hint'),
        //   value: basicFormProvider.selectedType,
        //   items: ['Rent', 'Lease'],
        //   onChanged: (val) {
        //     basicFormProvider.selectedType = val;
        //   },
        // ),
        SizedBox(
          height: 5,
        ),

        TextWithAsterisk(
          text: t(context, 'land_type_val'),
          isAstrick: false,
        ),
        Row(
          children: [
            Radio<String>(
              visualDensity: VisualDensity.compact,
              activeColor: CommonColors.blue,
              value: "Rent",
              groupValue: basicFormProvider.rentLeaseOption,
              onChanged: (value) {
                if (value != null) basicFormProvider.setRentLeaseOption(value);
              },
            ),
            const Text("Rent"),
            const SizedBox(width: 20),
            Radio<String>(
              visualDensity: VisualDensity.compact,
              activeColor: CommonColors.blue,
              value: "Lease",
              groupValue: basicFormProvider.rentLeaseOption,
              onChanged: (value) {
                if (value != null) basicFormProvider.setRentLeaseOption(value);
              },
            ),
            const Text("Lease"),
          ],
        ),
        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'land_rate'),
          hintText: t(context, 'land_rate_hint'),
          onChange: (val) {},
          textEditingController: basicFormProvider.landRateontroller,
          autovalidateMode: AutovalidateMode.disabled,
          textInputType: TextInputType.number,
          validator: basicFormProvider.validateState,
        ),

        /// Substation Details Section
        SizedBox(height: SizeConfig.blockSizeVertical * 2),
      ],
    );
  }
}
