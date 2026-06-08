class LeaderboardUserModel {
  final int rank;
  final String name;
  final int points;
  final String avatar;
  final String trend;

  const LeaderboardUserModel({
    required this.rank,
    required this.name,
    required this.points,
    required this.avatar,
    required this.trend,
  });

  static const List<LeaderboardUserModel> dummyData = [
    LeaderboardUserModel(rank: 1, name: 'Sarah Ahmed', points: 5420, avatar: '👸', trend: '+120'),
    LeaderboardUserModel(rank: 2, name: 'Mohamed Ali', points: 4890, avatar: '🧑', trend: '+95'),
    LeaderboardUserModel(rank: 3, name: 'Fatima Hassan', points: 4650, avatar: '👩', trend: '+88'),
    LeaderboardUserModel(rank: 4, name: 'Omar Khaled', points: 3920, avatar: '👨', trend: '+76'),
    LeaderboardUserModel(rank: 5, name: 'Nour Mahmoud', points: 3580, avatar: '👧', trend: '+65'),
    LeaderboardUserModel(rank: 6, name: 'Ahmed Youssef', points: 3240, avatar: '🧔', trend: '+54'),
    LeaderboardUserModel(rank: 7, name: 'Layla Ibrahim', points: 2950, avatar: '👩🦱', trend: '+48'),
    LeaderboardUserModel(rank: 8, name: 'Karim Said', points: 2730, avatar: '👨🦱', trend: '+42'),
  ];
}
