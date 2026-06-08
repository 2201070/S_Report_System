import 'package:dartz/dartz.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/features/report/data/models/my_reports_model.dart';
import 'package:s_report_system/features/report/data/models/report_category_model.dart';
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/data/models/report_response_model.dart';
import 'package:s_report_system/features/report/data/models/report_details_model.dart';
import 'package:s_report_system/features/report/data/models/sync_response_model.dart';

abstract class IReportRepository {
  Future<Either<Failure, ReportResponseModel>> createReport(CreateReportModel report);
  Future<Either<Failure, List<MyReportsModel>>> getMyReports();
  Future<Either<Failure, ReportDetailsModel>> getReportDetails(int id); 
  Future<Either<Failure, List<ReportCategoryModel>>> getCategories();
  Future<Either<Failure, String>> cancelReport(int id);
  Future<Either<Failure, SyncResponseModel>> syncOfflineReports();
}