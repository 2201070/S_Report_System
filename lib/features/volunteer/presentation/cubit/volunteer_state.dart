import 'package:equatable/equatable.dart';
import '../../domain/entities/volunteer_task_entity.dart';

enum VolunteerStatus { initial, loading, loaded, actionLoading, taskAcceptedSuccess, taskCompletedSuccess, taskDeclinedSuccess, error }

class VolunteerState extends Equatable {
  final VolunteerStatus status;
  final List<VolunteerTaskEntity> missions;
  final VolunteerTaskEntity? currentMission;
  final String? errorMessage;
  final bool isOnline;
  final List<VolunteerTaskEntity> myMissions;
  final int currentIndex;
  final int totalPoints;

  const VolunteerState({
    this.status = VolunteerStatus.initial,
    this.missions = const [],
    this.currentMission,
    this.errorMessage,
    this.isOnline = true,
    this.myMissions = const [],
    this.currentIndex = 0,
    this.totalPoints = 0,
  });

  VolunteerState copyWith({
    VolunteerStatus? status,
    List<VolunteerTaskEntity>? missions,
    VolunteerTaskEntity? currentMission,
    String? errorMessage,
    bool? isOnline,
    List<VolunteerTaskEntity>? myMissions,
    int? currentIndex,
    int? totalPoints,
  }) {
    return VolunteerState(
      status: status ?? this.status,
      missions: missions ?? this.missions,
      currentMission: currentMission ?? this.currentMission,
      errorMessage: errorMessage ?? this.errorMessage,
      isOnline: isOnline ?? this.isOnline,
      myMissions: myMissions ?? this.myMissions,
      currentIndex: currentIndex ?? this.currentIndex,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  @override
  List<Object?> get props => [status, missions, currentMission, errorMessage, isOnline, myMissions, currentIndex, totalPoints];
}
