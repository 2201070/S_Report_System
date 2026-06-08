import 'package:equatable/equatable.dart';

class VolunteerProfileModel extends Equatable {
  final String name;
  final String? avatar;
  final int totalPoints;
  final int completedMissionsCount;
  final List<String> earnedAchievements;

  const VolunteerProfileModel({
    required this.name,
    this.avatar,
    required this.totalPoints,
    required this.completedMissionsCount,
    required this.earnedAchievements,
  });

  factory VolunteerProfileModel.fromJson(Map<String, dynamic> json) {
    return VolunteerProfileModel(
      name: json['name']?.toString() ?? 'Hero Volunteer',
      avatar: json['avatar']?.toString(),
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      completedMissionsCount: (json['completedMissionsCount'] as num?)?.toInt() ?? 0,
      earnedAchievements: (json['earnedAchievements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [name, avatar, totalPoints, completedMissionsCount, earnedAchievements];
}
