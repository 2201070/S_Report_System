import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/volunteer_profile_repository.dart';
import '../../data/models/volunteer_profile_model.dart';

class GetVolunteerProfileUseCase {
  final VolunteerProfileRepository repository;

  GetVolunteerProfileUseCase(this.repository);

  Future<Either<Failure, VolunteerProfileModel>> call() async {
    return await repository.getVolunteerProfile();
  }
}
