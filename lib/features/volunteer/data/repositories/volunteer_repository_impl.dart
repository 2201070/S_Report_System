import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/volunteer/data/datasources/volunteer_remote_data_source.dart';
import 'package:s_report_system/features/volunteer/data/models/volunteer_history_model.dart';
import 'package:s_report_system/features/volunteer/domain/entities/volunteer_task_entity.dart';
import 'package:s_report_system/features/volunteer/domain/repositories/i_volunteer_repository.dart';

class VolunteerRepositoryImpl implements IVolunteerRepository {
  final VolunteerRemoteDataSource remoteDataSource;

  VolunteerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<VolunteerTaskEntity>>> getNearbyMissions(
      {required double lat, required double lng, int cityId = 1}) async {
    try {
      final result = await remoteDataSource.getNearbyMissions(
          lat: lat, lng: lng, cityId: cityId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acceptMission(int id) async {
    try {
      await remoteDataSource.acceptMission(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeMission(int id) async {
    try {
      await remoteDataSource.completeMission(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelMission(int id) async {
    try {
      await remoteDataSource.cancelMission(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VolunteerTaskEntity?>> getCurrentMission() async {
    try {
      final result = await remoteDataSource.getCurrentMission();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VolunteerHistoryModel>>> getVolunteerHistory() async {
    try {
      final result = await remoteDataSource.getVolunteerHistory();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
