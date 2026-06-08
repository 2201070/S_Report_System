import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

part 'create_report_model.g.dart';

@HiveType(typeId: 0)
class CreateReportModel extends HiveObject {
  @HiveField(0)
  final String description;
  @HiveField(1)
  final double latitude;
  @HiveField(2)
  final double longitude;
  @HiveField(3)
  final String reportType;
  @HiveField(4)
  final int cityId;
  @HiveField(5)
  final List<String> imageFiles;
  @HiveField(6)
  final String? voiceFile;

  CreateReportModel({
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.reportType,
    required this.cityId,
    required this.imageFiles,
    this.voiceFile,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      'Description': description,
      'Latitude': latitude,
      'Longitude': longitude,
      'ReportType': reportType,
      'CityId': cityId,
    };

    if (imageFiles.isNotEmpty) {
      final List<MultipartFile> imageMultipartFiles = [];
      for (String path in imageFiles) {
        if (path.isNotEmpty) {
          imageMultipartFiles.add(
            await MultipartFile.fromFile(path, filename: path.split('/').last),
          );
        }
      }
      data['ImageFiles'] = imageMultipartFiles;
    }

    if (voiceFile != null && voiceFile!.isNotEmpty) {
      data['VoiceFile'] = await MultipartFile.fromFile(
        voiceFile!,
        filename: voiceFile!.split('/').last,
      );
    }

    return FormData.fromMap(data);
  }
}