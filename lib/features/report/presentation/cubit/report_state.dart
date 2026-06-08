import 'package:equatable/equatable.dart';
import 'package:s_report_system/features/report/data/models/report_response_model.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

/// The initial idle state before any action is taken.
class ReportInitial extends ReportState {
  const ReportInitial();
}

/// Emitted while the form data is being built and uploaded.
class ReportLoading extends ReportState {
  const ReportLoading();
}

/// Emitted when the API confirms the report was created successfully.
class ReportSuccess extends ReportState {
  final ReportResponseModel response;

  const ReportSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

/// Emitted when the API call or validation fails. Contains a human-readable message.
class ReportError extends ReportState {
  final String message;

  const ReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
