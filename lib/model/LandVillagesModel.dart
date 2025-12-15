class LandVillagesModel {
  final bool status;
  final String message;
  final List<VillageData> data;
  final Pagination? pagination;

  LandVillagesModel({
    required this.status,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory LandVillagesModel.fromJson(Map<String, dynamic>? json) {
    return LandVillagesModel(
      status: json?["status"] ?? false,
      message: json?["message"] ?? "",
      data: (json?["data"] as List<dynamic>?)
              ?.map((e) => VillageData.fromJson(e))
              .toList() ??
          [],
      pagination: json?["pagination"] != null
          ? Pagination.fromJson(json?["pagination"])
          : null,
    );
  }
}

class VillageData {
  final int id;
  final String districtCode;
  final String districtName;
  final String talukaCode;
  final String talukaName;
  final String villageCode;
  final String villageName;
  final String stateCode;
  final String stateName;

  VillageData({
    required this.id,
    required this.districtCode,
    required this.districtName,
    required this.talukaCode,
    required this.talukaName,
    required this.villageCode,
    required this.villageName,
    required this.stateCode,
    required this.stateName,
  });

  factory VillageData.fromJson(Map<String, dynamic>? json) {
    return VillageData(
      id: json?["id"] ?? 0,
      districtCode: json?["district_code"] ?? "",
      districtName: json?["district_name"] ?? "",
      talukaCode: json?["taluka_code"] ?? "",
      talukaName: json?["taluka_name"] ?? "",
      villageCode: json?["village_code"] ?? "",
      villageName: json?["village_name"] ?? "",
      stateCode: json?["state_code"] ?? "",
      stateName: json?["state_name"] ?? "",
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
