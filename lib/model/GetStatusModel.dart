class GetStatusModel {
  final bool? success;
  final String? message;
  final List<ApprovalStatusData>? data;

  GetStatusModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetStatusModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GetStatusModel();

    return GetStatusModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ApprovalStatusData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.map((e) => e.toJson()).toList(),
    };
  }
}

class ApprovalStatusData {
  final int? id;
  final String? approvalStatusName;

  ApprovalStatusData({
    this.id,
    this.approvalStatusName,
  });

  factory ApprovalStatusData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ApprovalStatusData();

    return ApprovalStatusData(
      id: json['id'],
      approvalStatusName: json['approval_status_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "approval_status_name": approvalStatusName,
    };
  }
}
