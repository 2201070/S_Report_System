import 'package:hive/hive.dart';

part 'offline_report_model.g.dart';

@HiveType(typeId: 1)
class OfflineReportModel extends HiveObject {
  @HiveField(0)
  final String description;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final String reportType;

  @HiveField(4)
  final List<String> imageFiles;

  @HiveField(5)
  final String voiceFile;

  @HiveField(6)
  final int cityId;

  OfflineReportModel({
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.reportType,
    required this.imageFiles,
    required this.voiceFile,
    required this.cityId,
  });

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "reportType": reportType,
      "imageFiles": imageFiles,
      "voiceFile": voiceFile,
      "cityId": cityId,
    };
  }
}
