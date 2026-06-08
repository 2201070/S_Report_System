class AchievementBadgeModel {
  final int id;
  final String name;
  final bool unlocked;
  final String icon;

  const AchievementBadgeModel({
    required this.id,
    required this.name,
    required this.unlocked,
    required this.icon,
  });

  static const List<AchievementBadgeModel> dummyBadges = [
    AchievementBadgeModel(id: 1, name: 'First Mission', unlocked: true, icon: '🎯'),
    AchievementBadgeModel(id: 2, name: 'Helper', unlocked: true, icon: '🤝'),
    AchievementBadgeModel(id: 3, name: 'Guardian', unlocked: true, icon: '🛡️'),
    AchievementBadgeModel(id: 4, name: 'Hero', unlocked: false, icon: '🦸'),
    AchievementBadgeModel(id: 5, name: 'Legend', unlocked: false, icon: '👑'),
  ];
}
