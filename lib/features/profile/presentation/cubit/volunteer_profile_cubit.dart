import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_volunteer_profile_usecase.dart';
import '../../data/models/volunteer_profile_model.dart';

// --- States ---
abstract class VolunteerProfileState extends Equatable {
  const VolunteerProfileState();
  @override
  List<Object> get props => [];
}

class VolunteerProfileInitial extends VolunteerProfileState {}
class VolunteerProfileLoading extends VolunteerProfileState {}

class VolunteerProfileSuccess extends VolunteerProfileState {
  final VolunteerProfileModel profile;
  const VolunteerProfileSuccess(this.profile);
  @override
  List<Object> get props => [profile];
}

class VolunteerProfileError extends VolunteerProfileState {
  final String message;
  const VolunteerProfileError(this.message);
  @override
  List<Object> get props => [message];
}

// --- Cubit ---
class VolunteerProfileCubit extends Cubit<VolunteerProfileState> {
  final GetVolunteerProfileUseCase getVolunteerProfileUseCase;

  VolunteerProfileCubit({required this.getVolunteerProfileUseCase}) : super(VolunteerProfileInitial());

  Future<void> fetchProfile() async {
    emit(VolunteerProfileLoading());
    
    final result = await getVolunteerProfileUseCase();
    
    result.fold(
      (failure) => emit(VolunteerProfileError(failure.errorMessage)), 
      (profile) => emit(VolunteerProfileSuccess(profile)),
    );
  }
}
