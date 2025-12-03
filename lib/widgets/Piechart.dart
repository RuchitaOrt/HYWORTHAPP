import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:provider/provider.dart';
import '../Provider/app_provider.dart';

class SurveyProgressChart extends StatefulWidget {
  final int totalSurveys;
  final int approvedLands;
  final int consentForms;
  final int pendingSurvey;

  const SurveyProgressChart({
    super.key,
    required this.totalSurveys,
    required this.approvedLands,
    required this.consentForms,
    required this.pendingSurvey,
  });

  @override
  State<SurveyProgressChart> createState() => _SurveyProgressChartState();
}

class _SurveyProgressChartState extends State<SurveyProgressChart> {
  String? _highlight; // which circle is highlighted

  @override
  Widget build(BuildContext context) {
    double approvedPercent =
        widget.totalSurveys > 0 ? widget.approvedLands / widget.totalSurveys : 0.0;
    double consentPercent =
        widget.totalSurveys > 0 ? widget.consentForms / widget.totalSurveys : 0.0;
    double pendingPercent =
        widget.totalSurveys > 0 ? widget.pendingSurvey / widget.totalSurveys : 0.0;

    return Card(
      color: CommonColors.white,
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                // Chart
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildCircle(
                          label: "total",
                          value: 1,
                          size: 150,
                          color: Colors.blue,
                        ),
                        _buildCircle(
                          label: "approved",
                          value: approvedPercent,
                          size: 110,
                          color: Colors.green,
                        ),
                        _buildCircle(
                          label: "consent",
                          value: consentPercent,
                          size: 70,
                          color: Colors.orange,
                        ),
                        // If you want, you can add pending as well
                        // _buildCircle(
                        //   label: "pending",
                        //   value: pendingPercent,
                        //   size: 30,
                        //   color: Colors.red,
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Legend
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegend(t(context, "total_surveys"), widget.totalSurveys, Colors.blue),
                      _buildLegend(t(context, "completed"), widget.approvedLands, Colors.green),
                      _buildLegend(t(context, "consent_forms"), widget.consentForms, Colors.orange),
                      // _buildLegend(t(context, "pending"), widget.pendingSurvey, Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds one circle with tap interaction
  Widget _buildCircle({
    required String label,
    required double value,
    required double size,
    required Color color,
  }) {
    final bool isActive = _highlight == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _highlight = _highlight == label ? null : label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isActive && label != "total" ? size + 15 : size,
        height: isActive && label != "total" ? size + 15 : size,
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: 10,
          color: color,
          backgroundColor: color.withOpacity(0.2),
        ),
      ),
    );
  }

  /// Builds legend item with colored dot + label + value
  Widget _buildLegend(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          Text("$value"),
        ],
      ),
    );
  }
}
