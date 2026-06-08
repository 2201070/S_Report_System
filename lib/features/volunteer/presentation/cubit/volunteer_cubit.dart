import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/volunteer_task_entity.dart';
import '../../domain/usecases/volunteer_usecases.dart';
import 'volunteer_state.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';

class VolunteerCubit extends Cubit<VolunteerState> {
  final GetNearbyMissionsUseCase getNearbyMissionsUseCase;
  final AcceptMissionUseCase acceptMissionUseCase;
  final CompleteMissionUseCase completeMissionUseCase;
  final CancelMissionUseCase cancelMissionUseCase;
  final GetCurrentMissionUseCase getCurrentMissionUseCase;

  VolunteerCubit({
    required this.getNearbyMissionsUseCase,
    required this.acceptMissionUseCase,
    required this.completeMissionUseCase,
    required this.cancelMissionUseCase,
    required this.getCurrentMissionUseCase,
  }) : super(const VolunteerState());

  void toggleVolunteerMode(bool value) {
    emit(state.copyWith(isOnline: value));
  }

  void changeBottomNav(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      if (failure.errorMessage.contains('409') || failure.errorMessage.contains('Conflict')) {
        return 'عذراً، هذه المهمة غير متاحة حالياً. (Task no longer available)';
      }
      return 'حدث خطأ في الخادم. الرجاء المحاولة مرة أخرى. (Server error, please try again)';
    }
    return 'حدث خطأ غير متوقع. (Unexpected error)';
  }

  Future<void> getNearbyMissions({
    required double lat, 
    required double lng, 
    required int cityId
  }) async {
    debugPrint('CUBIT_DEBUG: getNearbyMissions triggered');
    debugPrint('CUBIT_DEBUG: Calling API with Lat: $lat, Lng: $lng, CityId: $cityId');
    debugPrint('FINAL_CHECK: API Call Initiated');
    emit(state.copyWith(status: VolunteerStatus.loading));
    
    final result = await getNearbyMissionsUseCase(lat: lat, lng: lng, cityId: cityId);
    
    result.fold(
      (failure) {
        debugPrint('CUBIT_DEBUG: API Error -> $failure');
        debugPrint('VolunteerCubit: Error fetching nearby missions - ${failure.errorMessage}');
        emit(state.copyWith(
          status: VolunteerStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (missions) {
        debugPrint('CUBIT_DEBUG: API Success -> Received ${missions.length} missions');
        final acceptedIds = state.myMissions.map((m) => m.reportId).toSet();
        final filteredMissions = missions.where((m) => !acceptedIds.contains(m.reportId) && (m.status == 'Pending' || m.status == 'assigned')).toList();

        debugPrint('VolunteerCubit: Fetched ${filteredMissions.length} nearby missions after filtering');
        emit(state.copyWith(
          status: VolunteerStatus.loaded,
          missions: filteredMissions,
        ));
      },
    );
  }

  Future<void> getCurrentMission() async {
    emit(state.copyWith(status: VolunteerStatus.loading));
    final result = await getCurrentMissionUseCase();
    result.fold(
      (failure) {
        debugPrint('VolunteerCubit: Error fetching current mission - ${failure.errorMessage}');
        emit(state.copyWith(
          status: VolunteerStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (mission) {
        debugPrint('VolunteerCubit: Current mission fetched: ${mission?.reportId}');
        // التعديل: إدراج المهمة الحالية في قائمة myMissions لضمان ظهورها في الـ Dashboard
        emit(state.copyWith(
          status: VolunteerStatus.loaded,
          currentMission: mission,
          myMissions: mission != null ? [mission] : [], 
        ));
      },
    );
  }

  Future<void> acceptMission(int id) async {
    // Optimistic Update
    final previousMissions = List<VolunteerTaskEntity>.from(state.missions);
    final previousMyMissions = List<VolunteerTaskEntity>.from(state.myMissions);
    final previousCurrentMission = state.currentMission;
    
    VolunteerTaskEntity? acceptedMission;
    
    final updatedMissions = state.missions.where((m) {
      if (m.reportId == id) {
        acceptedMission = m.copyWith(status: 'Accepted', acceptedAt: DateTime.now());
        return false;
      }
      return true;
    }).toList();

    final updatedMyMissions = List<VolunteerTaskEntity>.from(state.myMissions);
    if (acceptedMission != null) {
      updatedMyMissions.add(acceptedMission!);
    }

    emit(state.copyWith(
      status: VolunteerStatus.actionLoading,
      missions: updatedMissions,
      myMissions: updatedMyMissions,
      currentMission: acceptedMission,
    ));

    try {
      final result = await acceptMissionUseCase(id);
      result.fold(
        (failure) {
          debugPrint('VolunteerCubit: Failed to accept mission $id - ${failure.errorMessage}');
          // Revert to backup
          emit(state.copyWith(
            status: VolunteerStatus.error,
            missions: previousMissions,
            myMissions: previousMyMissions,
            currentMission: previousCurrentMission,
            errorMessage: _mapFailureToMessage(failure),
          ));
        },
        (_) {
          debugPrint('VolunteerCubit: Successfully accepted mission $id');
          emit(state.copyWith(
            status: VolunteerStatus.taskAcceptedSuccess,
          ));
          emit(state.copyWith(
            status: VolunteerStatus.loaded,
          ));
        },
      );
    } on DioException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection Timeout - Please try again';
      } else if (e.response?.statusCode == 409) {
        errorMessage = 'This mission was just accepted by another volunteer.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No Internet Connection';
      }
      
      emit(state.copyWith(
        status: VolunteerStatus.error,
        missions: previousMissions,
        myMissions: previousMyMissions,
        currentMission: previousCurrentMission,
        errorMessage: errorMessage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VolunteerStatus.error,
        missions: previousMissions,
        myMissions: previousMyMissions,
        currentMission: previousCurrentMission,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> completeMission(int id) async {
    emit(state.copyWith(status: VolunteerStatus.actionLoading));
    
    try {
      final result = await completeMissionUseCase(id);
      result.fold(
        (failure) {
          debugPrint('VolunteerCubit: Failed to complete mission $id - ${failure.errorMessage}');
          emit(state.copyWith(
            status: VolunteerStatus.error,
            errorMessage: _mapFailureToMessage(failure),
          ));
        },
        (_) {
          final updatedMyMissions = state.myMissions.where((m) => m.reportId != id).toList();
          final newPoints = state.totalPoints + 50;

          emit(state.copyWith(
            status: VolunteerStatus.taskCompletedSuccess,
            myMissions: updatedMyMissions,
            totalPoints: newPoints,
            currentMission: null,
          ));
          emit(state.copyWith(
            status: VolunteerStatus.loaded,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: VolunteerStatus.error,
        errorMessage: 'An error occurred while completing the mission.',
      ));
    }
  }

  Future<void> declineMission(int id, {
    required double lat, 
    required double lng, 
    required int cityId
  }) async {
    emit(state.copyWith(status: VolunteerStatus.actionLoading));
    
    final result = await cancelMissionUseCase(id);
    result.fold(
      (failure) {
        debugPrint('VolunteerCubit: Failed to decline mission $id - ${failure.errorMessage}');
        emit(state.copyWith(
          status: VolunteerStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (_) {
        debugPrint('VolunteerCubit: Successfully declined mission $id');
        final updatedMyMissions = state.myMissions.where((m) => m.reportId != id).toList();
        emit(state.copyWith(
          status: VolunteerStatus.taskDeclinedSuccess,
          myMissions: updatedMyMissions,
          currentMission: null,
        ));
        
        getNearbyMissions(lat: lat, lng: lng, cityId: cityId);
      },
    );
  }
}