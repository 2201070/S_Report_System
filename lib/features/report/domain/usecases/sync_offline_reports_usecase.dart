import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/report/data/models/sync_response_model.dart';
import 'package:s_report_system/features/report/domain/repositories/i_report_repository.dart';

class SyncOfflineReportsUseCase {
  final IReportRepository repository;

  SyncOfflineReportsUseCase(this.repository);

  Future<Either<Failure, SyncResponseModel>> call() async {
    return await repository.syncOfflineReports();
  }
}
