import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/profile/data/models/user_profile_model.dart';

abstract class IProfileRepository {
  Future<Either<Failure, UserProfileModel>> getUserProfile();
  Future<Either<Failure, UserProfileModel>> updateUserProfile(Map<String, dynamic> data);
}