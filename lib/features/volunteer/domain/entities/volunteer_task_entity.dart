import 'package:equatable/equatable.dart';

class VolunteerTaskEntity extends Equatable {
  final int reportId;
  final String description;
  final double latitude;
  final double longitude;
  final String status;
  final String? cityName;
  final double distanceInMeters;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final List<String> attachedMedia;

  const VolunteerTaskEntity({
    required this.reportId,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.cityName,
    required this.distanceInMeters,
    required this.createdAt,
    this.acceptedAt,
    required this.attachedMedia,
  });

  VolunteerTaskEntity copyWith({
    int? reportId,
    String? description,
    double? latitude,
    double? longitude,
    String? status,
    String? cityName,
    double? distanceInMeters,
    DateTime? createdAt,
    DateTime? acceptedAt,
    List<String>? attachedMedia,
  }) {
    return VolunteerTaskEntity(
      reportId: reportId ?? this.reportId,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      cityName: cityName ?? this.cityName,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      attachedMedia: attachedMedia ?? this.attachedMedia,
    );
  }

  @override
  List<Object?> get props => [
        reportId,
        description,
        latitude,
        longitude,
        status,
        cityName,
        distanceInMeters,
        createdAt,
        acceptedAt,
        attachedMedia,  
      ];
}
