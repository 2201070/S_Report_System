import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_report_system/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:s_report_system/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase; 

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase, 
  }) : super(const ProfileInitial()) {
    getProfile();
  }

  Future<void> getProfile() async {
    emit(const ProfileLoading());

    final result = await getProfileUseCase();

    result.fold(
      (failure) => emit(ProfileError(message: failure.errorMessage)),
      (user) => emit(ProfileSuccess(user: user)),
    );
  }

  void refresh() => getProfile();

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
  }) async {
    emit(const ProfileLoading());
    
    final data = {
      "firstName": firstName,
      "secondName": lastName,
      "homeAddress": address,
      "email": email,
      "phone": phone,
      "cityId": 29 
    };
    
    final result = await updateProfileUseCase(data); 
    
    result.fold(
      (failure) => emit(ProfileError(message: failure.errorMessage)),
      (user) async {
        emit(const ProfileUpdateSuccess()); 
        await getProfile();
      },
    );
  }
}