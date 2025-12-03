import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';

enum TimeFilter { thisWeek, thisMonth, thisYear, all }

Future<TimeFilter?> showTimeFilterDialogSingle(
  BuildContext context, {
  required TimeFilter? initialSelection,
}) async {
  TimeFilter? selectedFilter = initialSelection;

  return showDialog<TimeFilter>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Filter"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: TimeFilter.values.map((filter) {
                String title;
                switch (filter) {
                  case TimeFilter.thisWeek:
                    title = "This Week";
                    break;
                  case TimeFilter.thisMonth:
                    title = "This Month";
                    break;
                  case TimeFilter.thisYear:
                    title = "This Year";
                    break;
                  case TimeFilter.all:
                    title = "All";
                    break;
                }

                return RadioListTile<TimeFilter>(
                  title: Text(title),
                  value: filter,
                  activeColor: CommonColors.blue,
                  groupValue: selectedFilter,
                  onChanged: (val) {
                    setState(() {
                      selectedFilter = val;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.trailing, // checkbox/radio on right
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: Text("Cancel",style: TextStyle(color: CommonColors.blue),),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, selectedFilter),
                child: Text("Apply",style: TextStyle(color: CommonColors.blue),),
              ),
            ],
          );
        },
      );
    },
  );
}
