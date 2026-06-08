import 'package:equatable/equatable.dart';
import 'package:s_report_system/features/volunteer/data/models/volunteer_history_model.dart';

abstract class VolunteerHistoryState extends Equatable {
  const VolunteerHistoryState();
  @override
  List<Object?> get props => [];
}

class VolunteerHistoryInitial extends VolunteerHistoryState {
  const VolunteerHistoryInitial();
}

class VolunteerHistoryLoading extends VolunteerHistoryState {
  const VolunteerHistoryLoading();
}

class VolunteerHistorySuccess extends VolunteerHistoryState {
  final List<VolunteerHistoryModel> missions;
  const VolunteerHistorySuccess({required this.missions});

  @override
  List<Object?> get props => [missions];
}

class VolunteerHistoryError extends VolunteerHistoryState {
  final String message;
  const VolunteerHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
