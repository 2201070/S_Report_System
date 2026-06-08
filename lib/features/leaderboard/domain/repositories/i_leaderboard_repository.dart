import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/leaderboard/domain/entities/volunteer_rank.dart';

abstract class ILeaderboardRepository {
  Future<Either<Failure, List<VolunteerRank>>> getLeaderboard();
}
