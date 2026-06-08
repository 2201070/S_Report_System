import 'package:s_report_system/features/leaderboard/domain/entities/volunteer_rank.dart';

class LeaderboardModel extends VolunteerRank {
  const LeaderboardModel({
    required super.rank,
    required super.name,
    required super.totalPoints,
    required super.avatarUrl,
    required super.nationalId,
    required super.volunteer,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      name: json['name']?.toString() ?? 'Unknown',
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatar']?.toString() ?? '',
      rank: 0, 
      nationalId: '', 
      volunteer: true, 
    );
  }
}