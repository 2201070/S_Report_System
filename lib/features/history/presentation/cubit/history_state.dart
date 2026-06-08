import 'package:equatable/equatable.dart';
import 'package:s_report_system/features/report/data/models/my_reports_model.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistorySuccess extends HistoryState {
  final List<MyReportsModel> reports;
  const HistorySuccess({required this.reports});

  @override
  List<Object?> get props => [reports];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
