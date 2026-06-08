import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/features/volunteer/domain/usecases/volunteer_usecases.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_history_state.dart';

class VolunteerHistoryCubit extends Cubit<VolunteerHistoryState> {
  final GetVolunteerHistoryUseCase getVolunteerHistoryUseCase;

  VolunteerHistoryCubit({required this.getVolunteerHistoryUseCase})
      : super(const VolunteerHistoryInitial()) {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    emit(const VolunteerHistoryLoading());
    final result = await getVolunteerHistoryUseCase();
    result.fold(
      (failure) => emit(VolunteerHistoryError(message: failure.errorMessage)),
      (missions) => emit(VolunteerHistorySuccess(missions: missions)),
    );
  }

  void refresh() => fetchHistory();
}
