import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/volunteer_profile_model.dart';

abstract class VolunteerProfileRepository {
  Future<Either<Failure, VolunteerProfileModel>> getVolunteerProfile();
}
