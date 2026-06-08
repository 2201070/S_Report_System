import '../../domain/entities/volunteer_task_entity.dart';

class MissionModel extends VolunteerTaskEntity {
  static const String placeholderImage = 'https://dummyimage.com/600x400/1e293b/ffffff.png&text=Mission+Image';

  const MissionModel({
    required super.reportId,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.status,
    super.cityName,
    required super.distanceInMeters,
    required super.createdAt,
    super.acceptedAt,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      reportId: json['reportId'] is num ? (json['reportId'] as num).toInt() : int.tryParse(json['reportId']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? 'No Description',
      latitude: json['latitude'] is num ? (json['latitude'] as num).toDouble() : double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: json['longitude'] is num ? (json['longitude'] as num).toDouble() : double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'Unknown',
      cityName: json['cityName']?.toString(),
      distanceInMeters: json['distanceInMeters'] is num ? (json['distanceInMeters'] as num).toDouble() : double.tryParse(json['distanceInMeters']?.toString() ?? '0') ?? 0.0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
    );
  }
}
