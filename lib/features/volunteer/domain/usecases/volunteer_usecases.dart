import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/volunteer/data/models/volunteer_history_model.dart';
import 'package:s_report_system/features/volunteer/domain/entities/volunteer_task_entity.dart';
import 'package:s_report_system/features/volunteer/domain/repositories/i_volunteer_repository.dart';

class GetNearbyMissionsUseCase {
  final IVolunteerRepository repository;
  GetNearbyMissionsUseCase(this.repository);
  Future<Either<Failure, List<VolunteerTaskEntity>>> call(
          {required double lat, required double lng, int cityId = 1}) =>
      repository.getNearbyMissions(lat: lat, lng: lng, cityId: cityId);
}

class AcceptMissionUseCase {
  final IVolunteerRepository repository;
  AcceptMissionUseCase(this.repository);
  Future<Either<Failure, void>> call(int id) => repository.acceptMission(id);
}

class CompleteMissionUseCase {
  final IVolunteerRepository repository;
  CompleteMissionUseCase(this.repository);
  Future<Either<Failure, void>> call(int id) => repository.completeMission(id);
}

class CancelMissionUseCase {
  final IVolunteerRepository repository;
  CancelMissionUseCase(this.repository);
  Future<Either<Failure, void>> call(int id) => repository.cancelMission(id);
}

class GetCurrentMissionUseCase {
  final IVolunteerRepository repository;
  GetCurrentMissionUseCase(this.repository);
  Future<Either<Failure, VolunteerTaskEntity?>> call() =>
      repository.getCurrentMission();
}

class GetVolunteerHistoryUseCase {
  final IVolunteerRepository repository;
  GetVolunteerHistoryUseCase(this.repository);
  Future<Either<Failure, List<VolunteerHistoryModel>>> call() =>
      repository.getVolunteerHistory();
}
