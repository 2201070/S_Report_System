class VolunteerStatsModel {
  final int level;
  final String title;
  final int currentXp;
  final int targetXp;
  final int hours;
  final int peopleHelped;
  final double rating;

  const VolunteerStatsModel({
    required this.level,
    required this.title,
    required this.currentXp,
    required this.targetXp,
    required this.hours,
    required this.peopleHelped,
    required this.rating,
  });

  static const VolunteerStatsModel dummyData = VolunteerStatsModel(
    level: 5,
    title: 'Guardian',
    currentXp: 850,
    targetXp: 1000,
    hours: 45,
    peopleHelped: 128,
    rating: 4.9,
  );
}
