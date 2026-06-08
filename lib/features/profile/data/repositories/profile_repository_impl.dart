import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:s_report_system/core/error/exceptions.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:s_report_system/features/profile/data/models/user_profile_model.dart';
import 'package:s_report_system/features/profile/domain/repositories/i_profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfileModel>> getUserProfile() async {
    try {
      final profile = await remoteDataSource.getUserProfile();
      return Right(profile);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? 'An unexpected error occurred.'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final profile = await remoteDataSource.updateUserProfile(data);
      return Right(profile);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? 'An unexpected error occurred.'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}