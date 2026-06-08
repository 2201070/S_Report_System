import 'package:dartz/dartz.dart';

import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/core/usecases/usecase.dart';
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/data/models/report_response_model.dart';
import 'package:s_report_system/features/report/domain/repositories/i_report_repository.dart';

class SubmitReportUseCase implements UseCase<Either<Failure, ReportResponseModel>, CreateReportModel> {
  final IReportRepository repository;

  SubmitReportUseCase(this.repository);

  @override
  Future<Either<Failure, ReportResponseModel>> call(CreateReportModel report) async {
    if (report.description.trim().isEmpty) {
      return Left(LogicFailure.fromMessage('Description cannot be empty.'));
    }
    if (report.imageFiles.isEmpty && report.voiceFile == null) {
      return Left(LogicFailure.fromMessage('At least one image or voice note is required.'));
    }

    return await repository.createReport(report);
  }
}
