import 'package:dartz/dartz.dart';

import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/profile/data/models/user_profile_model.dart';
import 'package:s_report_system/features/profile/domain/repositories/i_profile_repository.dart';

class GetProfileUseCase {
  final IProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileModel>> call() async {
    return await repository.getUserProfile();
  }
}
