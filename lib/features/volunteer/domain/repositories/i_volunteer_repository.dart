import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/volunteer/data/models/volunteer_history_model.dart';
import 'package:s_report_system/features/volunteer/domain/entities/volunteer_task_entity.dart';

abstract class IVolunteerRepository {
  Future<Either<Failure, List<VolunteerTaskEntity>>> getNearbyMissions(
      {required double lat, required double lng, int cityId});
  Future<Either<Failure, void>> acceptMission(int id);
  Future<Either<Failure, void>> completeMission(int id);
  Future<Either<Failure, void>> cancelMission(int id);
  Future<Either<Failure, VolunteerTaskEntity?>> getCurrentMission();
  Future<Either<Failure, List<VolunteerHistoryModel>>> getVolunteerHistory();
}
