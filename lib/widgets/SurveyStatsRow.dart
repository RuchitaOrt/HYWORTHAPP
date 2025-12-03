import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:provider/provider.dart';
import '../Provider/app_provider.dart';

class SurveyStatsRow extends StatelessWidget {
  final int totalSurveys;
  final int approvedLands;
  final int consentForms;

  const SurveyStatsRow({
    super.key,
    required this.totalSurveys,
    required this.approvedLands,
    required this.consentForms,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard(
          label: t(context, "total_surveys"),
          value: totalSurveys.toString(),
          color: Colors.blue.shade400,
          icon: Icons.assignment,
        ),
        _buildStatCard(
          label: t(context, "approved_land"),
          value: approvedLands.toString(),
          color: Colors.green.shade400,
          icon: Icons.check_circle,
        ),
        _buildStatCard(
          label: t(context, "consent_forms"),
          value: consentForms.toString(),
          color: Colors.orange.shade400,
          icon: Icons.description,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
