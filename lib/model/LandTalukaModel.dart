class LandTalukaModel {
  final bool status;
  final String message;
  final List<TalukaData> data;
  final Pagination? pagination;

  LandTalukaModel({
    required this.status,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory LandTalukaModel.fromJson(Map<String, dynamic>? json) {
    return LandTalukaModel(
      status: json?["status"] ?? false,
      message: json?["message"] ?? "",
      data: (json?["data"] as List<dynamic>?)
              ?.map((e) => TalukaData.fromJson(e))
              .toList() ??
          [],
      pagination: json?["pagination"] != null
          ? Pagination.fromJson(json?["pagination"])
          : null,
    );
  }
}

class TalukaData {
  final int id;
  final String stateCode;
  final String stateName;
  final String districtCode;
  final String districtName;
  final String talukaCode;
  final String talukaName;

  TalukaData({
    required this.id,
    required this.stateCode,
    required this.stateName,
    required this.districtCode,
    required this.districtName,
    required this.talukaCode,
    required this.talukaName,
  });

  factory TalukaData.fromJson(Map<String, dynamic>? json) {
    return TalukaData(
      id: json?["id"] ?? 0,
      stateCode: json?["state_code"] ?? "",
      stateName: json?["state_name"] ?? "",
      districtCode: json?["district_code"] ?? "",
      districtName: json?["district_name"] ?? "",
      talukaCode: json?["taluka_code"] ?? "",
      talukaName: json?["taluka_name"] ?? "",
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic>? json) {
    return Pagination(
      total: json?["total"] ?? 0,
      page: json?["page"] ?? 0,
      limit: json?["limit"] ?? 0,
      totalPages: json?["totalPages"] ?? 0,
    );
  }
}
