import 'package:equatable/equatable.dart';
import 'package:s_report_system/features/leaderboard/domain/entities/volunteer_rank.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<VolunteerRank> volunteers;

  const LeaderboardLoaded({required this.volunteers});

  @override
  List<Object?> get props => [volunteers];
}

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
