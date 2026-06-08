import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/report/domain/repositories/i_report_repository.dart';

class CancelReportUseCase {
  final IReportRepository repository;

  CancelReportUseCase(this.repository);

  Future<Either<Failure, String>> call(int id) async {
    return await repository.cancelReport(id);
  }
}
