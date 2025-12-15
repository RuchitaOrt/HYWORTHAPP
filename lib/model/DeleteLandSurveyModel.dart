class DeleteLandSurveyModel {
  final bool success;
  final String message;
  final int? deletedSurveyId;

  DeleteLandSurveyModel({
    required this.success,
    required this.message,
    required this.deletedSurveyId,
  });

  factory DeleteLandSurveyModel.fromJson(Map<String, dynamic> json) {
    return DeleteLandSurveyModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      deletedSurveyId: json['deleted_survey_id'], // null-safe
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "deleted_survey_id": deletedSurveyId,
    };
  }
}
