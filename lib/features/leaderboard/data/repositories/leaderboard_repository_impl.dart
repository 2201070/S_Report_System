import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/exceptions.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/leaderboard/data/datasources/leaderboard_remote_data_source.dart';
import 'package:s_report_system/features/leaderboard/domain/entities/volunteer_rank.dart';
import 'package:s_report_system/features/leaderboard/domain/repositories/i_leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements ILeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;

  LeaderboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<VolunteerRank>>> getLeaderboard() async {
    try {
      final list = await remoteDataSource.getLeaderboard();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? "No Message in ServerException"));
    } catch (e) {
      return Left(ServerFailure(errorMessage: "RAW_DEBUG -> ${e.toString()}"));
    }
  }
}