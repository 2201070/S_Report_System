import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/features/history/presentation/cubit/history_state.dart';
import 'package:s_report_system/features/report/domain/usecases/get_my_reports_usecase.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetMyReportsUseCase getMyReportsUseCase;

  HistoryCubit({required this.getMyReportsUseCase}) : super(const HistoryInitial()) {
    getMyReports();
  }

  Future<void> getMyReports() async {
    emit(const HistoryLoading());
    final result = await getMyReportsUseCase();
    result.fold(
      (failure) => emit(HistoryError(message: failure.errorMessage)),
      (reports) => emit(HistorySuccess(reports: reports)),
    );
  }

  void refresh() => getMyReports();
}
