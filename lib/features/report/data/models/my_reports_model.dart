import 'package:equatable/equatable.dart';

class MyReportsModel extends Equatable {
  final int id;
  final String description;
  final String date;
  final double latitude;
  final double longitude;
  final String reportType;
  final String reportState;
  final List<String> attachedMedia;

  const MyReportsModel({
    required this.id,
    required this.description,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.reportType,
    required this.reportState,
    required this.attachedMedia,
  });

  String get localizedState {
    switch (reportState.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'inprogress':
      case 'in_progress':
      case 'in progress':
        return 'قيد التنفيذ';
      case 'resolved':
        return 'تم الحل';
      case 'rejected':
        return 'مرفوض';
      default:
        return reportState;
    }
  }

  String? get firstMediaUrl =>
      attachedMedia.isNotEmpty ? attachedMedia.first : null;

  factory MyReportsModel.fromJson(Map<String, dynamic> json) {
    List<String> extractedMediaUrls = [];
    if (json['attachedMedia'] != null && json['attachedMedia'] is List) {
      for (var item in json['attachedMedia']) {
        if (item is Map && item['fileURL'] != null) {
          extractedMediaUrls.add(item['fileURL'].toString());
        }
      }
    }

    return MyReportsModel(
      id: (json['reportId'] as num?)?.toInt() ?? 0,        
      description: json['description']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      reportType: json['reportType']?.toString() ?? '',
      reportState: json['state']?.toString() ?? '',      
      attachedMedia: extractedMediaUrls,                  
    );
  }

  @override
  List<Object?> get props =>
      [id, description, date, latitude, longitude, reportType, reportState, attachedMedia];
}