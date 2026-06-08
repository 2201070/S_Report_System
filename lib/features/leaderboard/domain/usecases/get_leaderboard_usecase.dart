import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/leaderboard/domain/entities/volunteer_rank.dart';
import 'package:s_report_system/features/leaderboard/domain/repositories/i_leaderboard_repository.dart';

class GetLeaderboardUseCase {
  final ILeaderboardRepository repository;

  GetLeaderboardUseCase(this.repository);

  Future<Either<Failure, List<VolunteerRank>>> call() async {
    return await repository.getLeaderboard();
  }
}
