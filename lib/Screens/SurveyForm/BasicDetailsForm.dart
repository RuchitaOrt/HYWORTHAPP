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
        CustomTextFieldWidget(
          isMandatory: true,
          title: t(context, 'land_state'),
          hintText: t(context, 'land_state_hint'),
          onChange: (val) {},
          textEditingController: basicFormProvider.landStateController,
          autovalidateMode: AutovalidateMode.disabled,
          validator: basicFormProvider.validateState,
        ),
        // CustomTextFieldWidget(
        //   isMandatory: true,
        //   title: t(context, 'land_district'),
        //   hintText: t(context, 'land_district_hint'),
        //   onChange: (val) {},
        //   textEditingController: basicFormProvider.landDistrictController,
        //   autovalidateMode: AutovalidateMode.disabled,
        //   validator: basicFormProvider.validateState,
        // ),
       SearchableDropdown(
  title: t(context, 'land_district'),
  hintText: t(context, "select_district"),
  selectedItem: (basicFormProvider.selectedLandDistrict != null &&
                 basicFormProvider.selectedLandDistrict!['id']!.isNotEmpty)
      ? basicFormProvider.selectedLandDistrict
      : null, // null = show hint
  asyncItems: (filter, loadProps) async {
    final districts = await basicFormProvider.fetchDistricts();
    final districtMaps =
        districts.map((d) => {'id': d.id, 'name': d.name}).toList();

    if (filter.isEmpty) return districtMaps;

    return districtMaps
        .where((d) =>
            d['id']!.contains(filter) ||
            d['name']!.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  },
  filterKeys: ['id', 'name'],
  compareKey: 'id',
  displayString: (item) => "${item['name']}",
  onChanged: (value) {
    print("Selected District: $value");
    basicFormProvider.selectedLandDistrict = {
      'id': "${value!['id']}",
      'name': "${value['name']}",
    };
  },
)
,
// Taluka dropdown
        SearchableDropdown(
          title: t(context, 'land_taluka'),
          hintText: t(context, "select_taluka"),
          asyncItems: (filter, loadProps) async {
            final taluka = await basicFormProvider.fetchTaluka();
            final talukaMaps =
                taluka.map((d) => {'id': d.id, 'name': d.name}).toList();

            if (filter.isEmpty) return talukaMaps;

            return talukaMaps
                .where((d) =>
                    d['id']!.contains(filter) ||
                    d['name']!.toLowerCase().contains(filter.toLowerCase()))
                .toList();
          },
          filterKeys: ['id', 'name'],
          selectedItem: (basicFormProvider.selectedLandTaluka != null &&
                 basicFormProvider.selectedLandTaluka!['id']!.isNotEmpty)
      ? basicFormProvider.selectedLandTaluka
      : null,
          compareKey: 'id',
          displayString: (item) => "${item['name']}",
          onChanged: (value) {
            print("Selected Taluka: $value");
            basicFormProvider.selectedLandTaluka = {
              'id': "${value!['id']}",
              'name': "${value!['name']}",
            };
            
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
            final village = await basicFormProvider.fetchVillage();
            final villageMaps =
                village.map((d) => {'id': d.id, 'name': d.name}).toList();

            if (filter.isEmpty) return villageMaps;

            return villageMaps
                .where((d) =>
                    d['id']!.contains(filter) ||
                    d['name']!.toLowerCase().contains(filter.toLowerCase()))
                .toList();
          },
          filterKeys: ['id', 'name'],
          compareKey: 'id',
          displayString: (item) => "${item['name']}",
          onChanged: (value) {
            
            print("Selected Village: $value");
            basicFormProvider.selectedLandVillage = {
              'id': "${value!['id']}",
              'name': "${value!['name']}",
            };
          },
        ),

        // CustomTextFieldWidget(
        //   isMandatory: true,
        //   title: t(context, 'land_taluka'),
        //   hintText: t(context, 'land_taluka_hint'),
        //   onChange: (val) {},
        //   textEditingController: basicFormProvider.landTalukaController,
        //   autovalidateMode: AutovalidateMode.disabled,
        //   validator: basicFormProvider.validateState,
        // ),
        // CustomTextFieldWidget(
        //   isMandatory: true,
        //   title: t(context, 'land_village'),
        //   hintText: t(context, 'land_village_hint'),
        //   onChange: (val) {},
        //   textEditingController: basicFormProvider.landVillageController,
        //   autovalidateMode: AutovalidateMode.disabled,
        //   validator: basicFormProvider.validateState,
        // ),
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
      SizedBox(height: 5,),
      
        TextWithAsterisk(text:t(context, 'land_type_val'),isAstrick: false,),
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
          validator: basicFormProvider.validateState,
        ),

        /// Substation Details Section
        SizedBox(height: SizeConfig.blockSizeVertical * 2),
      ],
    );
  }
}
