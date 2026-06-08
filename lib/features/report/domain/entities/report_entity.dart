import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String? id;
  final String category;
  final String description;
  final List<String> imagesPaths;
  final String? voicePath;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  const ReportEntity({
    this.id,
    required this.category,
    required this.description,
    required this.imagesPaths,
    this.voicePath,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        description,
        imagesPaths,
        voicePath,
        latitude,
        longitude,
        createdAt,
      ];
}
