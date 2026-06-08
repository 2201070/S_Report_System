import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/profile/data/models/user_profile_model.dart';
import 'package:s_report_system/features/profile/domain/repositories/i_profile_repository.dart';

class UpdateProfileUseCase {
  final IProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileModel>> call(Map<String, dynamic> data) async {
    return await repository.updateUserProfile(data);
  }
}