class SyncResponseModel {
  final int successCount;
  final int failureCount;
  final List<FailedReportInfo> failedReports;

  SyncResponseModel({
    required this.successCount,
    required this.failureCount,
    required this.failedReports,
  });

  factory SyncResponseModel.fromJson(Map<String, dynamic> json) {
    return SyncResponseModel(
      successCount: json['successCount'] ?? 0,
      failureCount: json['failureCount'] ?? 0,
      failedReports: (json['failedReports'] as List<dynamic>?)
              ?.map((e) => FailedReportInfo.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FailedReportInfo {
  final String? description;
  final String? error;
  final String? date;

  FailedReportInfo({
    this.description,
    this.error,
    this.date,
  });

  factory FailedReportInfo.fromJson(Map<String, dynamic> json) {
    return FailedReportInfo(
      description: json['description'],
      error: json['error'],
      date: json['date'],
    );
  }
}
