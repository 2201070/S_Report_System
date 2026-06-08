import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class VolunteerHistoryModel extends Equatable {
  final int missionId;
  final String title;
  final String description;
  final String completionDate;
  final int earnedPoints;
  final String missionType;

  const VolunteerHistoryModel({
    required this.missionId,
    required this.title,
    required this.description,
    required this.completionDate,
    required this.earnedPoints,
    required this.missionType,
  });

  String get formattedDate {
    try {
      final parsed = DateTime.parse(completionDate);
      return DateFormat('MMM d, yyyy').format(parsed);
    } catch (_) {
      return completionDate;
    }
  }

  factory VolunteerHistoryModel.fromJson(Map<String, dynamic> json) {
    return VolunteerHistoryModel(
      missionId: (json['missionId'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      completionDate: json['completionDate']?.toString() ?? '',
      earnedPoints: (json['earnedPoints'] as num?)?.toInt() ?? 0,
      missionType: json['missionType']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [missionId, title, description, completionDate, earnedPoints, missionType];
}
