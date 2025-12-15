class LandDistrictModel {
  final bool? status;
  final String? message;
  final List<DistrictData>? data;
  final Pagination? pagination;

  LandDistrictModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory LandDistrictModel.fromJson(Map<String, dynamic> json) {
    return LandDistrictModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => DistrictData.fromJson(e))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class DistrictData {
  final int? id;
  final String? stateCode;
  final String? stateName;
  final String? districtCode;
  final String? districtName;

  DistrictData({
    this.id,
    this.stateCode,
    this.stateName,
    this.districtCode,
    this.districtName, String? name,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) {
    return DistrictData(
      id: json['id'],
      stateCode: json['state_code']?.toString(),
      stateName: json['state_name'],
      districtCode: json['district_code']?.toString(),
      districtName: json['district_name'],
    );
  }
}

class Pagination {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}
