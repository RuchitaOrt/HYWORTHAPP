import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/extentions.dart';
import 'package:hyworth_land_survey/widgets/TextWithAsterisk.dart';

class SearchableDropdown extends StatelessWidget {
  final String hintText;
  final Future<List<Map<String, String>>> Function(String filter, LoadProps? loadProps) asyncItems;
  final List<String> filterKeys; // keys to search in
  final String compareKey; // key to compare for selection
  final String Function(Map<String, String>) displayString; // text to show in dropdown
  final ValueChanged<Map<String, String>?>? onChanged;
  final BorderRadius borderRadius;
  final BorderSide enableBorder;
  final BorderSide focusedBorder;
  final String title;
  final bool isMandatory;
  final Map<String, String>? selectedItem; 

  const SearchableDropdown({

    super.key,
    required this.hintText,
    required this.asyncItems,
    required this.filterKeys,
    required this.compareKey,
    required this.displayString,
    this.isMandatory=false,
    required this.title,
    this.onChanged,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.enableBorder = const BorderSide(color: CommonColors.background, width: 1),
    this.focusedBorder = const BorderSide(color: CommonColors.blue, width: 1), this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          8.0.heightBox,
         TextWithAsterisk(text: title,isAstrick:isMandatory,),
          8.0.heightBox,
        Container(
          height: 40,
          child: GestureDetector(
            onTap: ()
            {
              FocusScope.of(context).unfocus();
            },
            child: DropdownSearch<Map<String, String>>(
              selectedItem: selectedItem,
              items: asyncItems,
              compareFn: (a, b) => a[compareKey] == b[compareKey],
              itemAsString: displayString,
              onChanged: onChanged,
              popupProps: PopupProps.menu(
                
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  
                  decoration: InputDecoration(
                     hintStyle: CommonStyles.textFieldHint,
                errorStyle: CommonStyles.textFieldHint,
                    border: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
                    focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
                    enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
                    disabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
                    errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
                    filled: true,
                    fillColor: CommonColors.white,
                    isDense: true,
                    
                    hintText: "Search $title",
                    labelStyle: CommonStyles.textFieldHint,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                itemBuilder: (context, item, isSelected, isFiltered) {
                  return ListTile(
                    dense: true,
                    title: Text(displayString(item),style:  CommonStyles.textFieldHeading,),
                    selected: isSelected,
                  );
                },
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: hintText,
                   hintStyle: CommonStyles.textFieldHint,
                errorStyle: CommonStyles.textFieldHint,
                  border: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
                  focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
                  enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
                  disabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
                  errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: enableBorder),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
                  filled: true,
                  fillColor: CommonColors.white,
                  isDense: true,
                  suffixIconColor: CommonColors.blue,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          ),
        ),
         8.0.heightBox,
      ],
    );
  }
}
