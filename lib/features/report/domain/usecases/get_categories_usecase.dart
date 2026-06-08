import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/report/data/models/report_category_model.dart';
import 'package:s_report_system/features/report/domain/repositories/i_report_repository.dart';

class GetCategoriesUseCase {
  final IReportRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<ReportCategoryModel>>> call() async {
    return await repository.getCategories();
  }
}
