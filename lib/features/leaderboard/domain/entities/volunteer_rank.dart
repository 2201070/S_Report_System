import 'package:equatable/equatable.dart';

class VolunteerRank extends Equatable {
  final int rank;
  final String name;
  final int totalPoints;
  final String avatarUrl;
  final String nationalId;
  final bool volunteer;

  const VolunteerRank({
    required this.rank,
    required this.name,
    required this.totalPoints,
    required this.avatarUrl,
    required this.nationalId,
    required this.volunteer,
  });

  @override
  List<Object?> get props =>
      [rank, name, totalPoints, avatarUrl, nationalId, volunteer];
}
