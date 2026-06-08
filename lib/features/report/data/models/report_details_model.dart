import 'package:equatable/equatable.dart';

class ReportDetailsModel extends Equatable {
  final int reportId;
  final String description;
  final String date;
  final double latitude;
  final double longitude;
  final String priority;
  final String reportType;
  final String reportState;
  final bool isValid;
  final String recommendations;
  final double confidenceScore;
  final String reporterName;
  final int reporterId;
  final int cityId;
  final String teamName;
  final List<String> attachedMedia;

  const ReportDetailsModel({
    required this.reportId,
    required this.description,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.priority,
    required this.reportType,
    required this.reportState,
    required this.isValid,
    required this.recommendations,
    required this.confidenceScore,
    required this.reporterName,
    required this.reporterId,
    required this.cityId,
    required this.teamName,
    required this.attachedMedia,
  });

  factory ReportDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> extractedMediaUrls = [];
    if (json['attachedMedia'] != null && json['attachedMedia'] is List) {
      for (var item in json['attachedMedia']) {
        if (item is Map && item['fileURL'] != null) {
          extractedMediaUrls.add(item['fileURL'].toString());
        }
      }
    }

    return ReportDetailsModel(
      reportId: (json['reportId'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      priority: json['priority']?.toString() ?? '',
      reportType: json['reportType']?.toString() ?? '',
      reportState: json['reportState']?.toString() ?? json['state']?.toString() ?? '',
      isValid: json['isValid'] == true, 
      recommendations: json['recommendations']?.toString() ?? '',
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      reporterName: json['reporterName']?.toString() ?? '',
      reporterId: (json['reporterId'] as num?)?.toInt() ?? 0,
      cityId: (json['cityId'] as num?)?.toInt() ?? 0,
      teamName: json['teamName']?.toString() ?? '',
      attachedMedia: extractedMediaUrls,
    );
  }

  @override
  List<Object?> get props => [
        reportId,
        description,
        date,
        latitude,
        longitude,
        priority,
        reportType,
        reportState,
        isValid,
        recommendations,
        confidenceScore,
        reporterName,
        reporterId,
        cityId,
        teamName,
        attachedMedia,
      ];
}