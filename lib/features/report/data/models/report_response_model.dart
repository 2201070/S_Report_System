class ReportResponseModel {
  final int reportId;
  final String description;
  final String date;
  final double latitude;
  final double longitude;
  final String reportType;
  final String reportState;
  final List<String> attachedMedia;

  ReportResponseModel({
    required this.reportId,
    required this.description,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.reportType,
    required this.reportState,
    required this.attachedMedia,
  });

  factory ReportResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportResponseModel(
      reportId: (json['reportId'] as num?)?.toInt() ?? 0,
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      reportType: json['reportType'] ?? '',
      reportState: json['reportState'] ?? '',
      attachedMedia: List<String>.from(json['attachedMedia'] ?? []),
    );
  }
}
