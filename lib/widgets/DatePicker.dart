
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';

Future<void> showCattleDatePicker({
  required BuildContext context,
  required TextEditingController controller,
}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: CommonColors.blue,
          colorScheme: ColorScheme.light(primary: CommonColors.blue),
          datePickerTheme: const DatePickerThemeData(
           
            
           
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    // Delay to ensure dialog closes smoothly before updating text
    await Future.delayed(const Duration(milliseconds: 100));
    controller.text = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
  }
}
Future<void> showCattleTimePicker({
  required BuildContext context,
  required TextEditingController controller,
}) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            hourMinuteTextColor: CommonColors.blue,
            dayPeriodTextColor: CommonColors.blue,
            dialHandColor: CommonColors.blue,
            entryModeIconColor: CommonColors.blue,
            hourMinuteColor: CommonColors.blue.withOpacity(0.1),
            helpTextStyle: TextStyle(color: CommonColors.blue),
          ),
          colorScheme: ColorScheme.light(primary: CommonColors.blue),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    final hour = picked.hourOfPeriod.toString().padLeft(2, '0');
    final minute = picked.minute.toString().padLeft(2, '0');
    final period = picked.period == DayPeriod.am ? "AM" : "PM";
    controller.text = "$hour:$minute $period";
  }
}