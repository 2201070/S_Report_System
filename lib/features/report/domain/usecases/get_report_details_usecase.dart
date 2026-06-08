import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/report/data/models/report_details_model.dart'; // ✅ غيرنا دي للموديل الجديد
import 'package:s_report_system/features/report/domain/repositories/i_report_repository.dart';

class GetReportDetailsUseCase {
  final IReportRepository repository;
  
  GetReportDetailsUseCase(this.repository);

  Future<Either<Failure, ReportDetailsModel>> call(int id) async {
    return await repository.getReportDetails(id);
  }
}