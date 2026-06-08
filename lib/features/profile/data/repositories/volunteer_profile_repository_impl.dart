import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/volunteer_profile_repository.dart';
import '../datasources/volunteer_profile_remote_data_source.dart';
import '../models/volunteer_profile_model.dart';

class VolunteerProfileRepositoryImpl implements VolunteerProfileRepository {
  final VolunteerProfileRemoteDataSource remoteDataSource;

  VolunteerProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, VolunteerProfileModel>> getVolunteerProfile() async {
    try {
      final profile = await remoteDataSource.getVolunteerProfile();
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString())); 
    }
  }
}
