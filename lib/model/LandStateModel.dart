class LandStateModel {
  final bool? status;
  final String? message;
  final List<StateData>? data;
  final Pagination? pagination;

  LandStateModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory LandStateModel.fromJson(Map<String, dynamic> json) {
    return LandStateModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => StateData.fromJson(e))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class StateData {
  final int? id;
  final String? stateCode;
  final String? name;

  StateData({
    this.id,
    this.stateCode,
    this.name,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      id: json['id'],
      stateCode: json['state_code']?.toString(),
      name: json['name'],
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
