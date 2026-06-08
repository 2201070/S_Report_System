import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/report/data/models/my_reports_model.dart';
import 'package:s_report_system/features/report/domain/repositories/i_report_repository.dart';

class GetMyReportsUseCase {
  final IReportRepository repository;
  GetMyReportsUseCase(this.repository);

  Future<Either<Failure, List<MyReportsModel>>> call() async {
    return await repository.getMyReports();
  }
}
