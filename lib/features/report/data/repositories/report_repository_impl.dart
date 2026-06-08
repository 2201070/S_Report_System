import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:s_report_system/core/error/exceptions.dart';
import 'package:s_report_system/core/error/failures.dart';
import 'package:s_report_system/core/network/network_info.dart';
import 'package:s_report_system/features/report/data/datasources/report_remote_data_source.dart';
import 'package:s_report_system/features/report/data/datasources/report_local_datasource.dart';
import 'package:s_report_system/features/report/data/models/my_reports_model.dart';
import 'package:s_report_system/features/report/data/models/report_category_model.dart';
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/data/models/report_response_model.dart';
import 'package:s_report_system/features/report/data/models/report_details_model.dart'; 
import 'package:s_report_system/features/report/data/models/offline_report_model.dart';
import 'package:s_report_system/features/report/data/models/sync_response_model.dart';
import 'package:s_report_system/features/report/domain/repositories/i_report_repository.dart';

class ReportRepositoryImpl implements IReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final ReportLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ReportResponseModel>> createReport(CreateReportModel report) async {
    if (!await networkInfo.isConnected) {
      try {
        final offlineReport = OfflineReportModel(
          description: report.description,
          latitude: report.latitude,
          longitude: report.longitude,
          reportType: report.reportType,
          imageFiles: report.imageFiles ?? [],
          voiceFile: report.voiceFile ?? "",
          cityId: report.cityId,
        );
        await localDataSource.cacheOfflineReport(offlineReport);
        return Right(ReportResponseModel.fromJson({"message": "تم حفظ البلاغ محلياً وسيتم إرساله عند توفر الإنترنت."}));
      } catch (e) {
        return const Left(CacheFailure(errorMessage: 'Failed to save report offline.'));
      }
    }
    
    try {
      return Right(await remoteDataSource.createReport(report));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SyncResponseModel>> syncOfflineReports() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(errorMessage: 'No internet connection.'));
    }

    try {
      final offlineReports = await localDataSource.getCachedOfflineReports();

      if (offlineReports.isEmpty) {
        return Right(SyncResponseModel(successCount: 0, failureCount: 0, failedReports: []));
      }

      final reportsJson = offlineReports.map((report) => report.toJson()).toList();
      final response = await remoteDataSource.syncOfflineReports(reportsJson);

      if (response.failureCount == 0) {
        await localDataSource.clearCachedOfflineReports();
      }

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? 'Server error during sync'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MyReportsModel>>> getMyReports() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(errorMessage: 'No internet connection.'));
    }
    try {
      return Right(await remoteDataSource.getMyReports());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReportDetailsModel>> getReportDetails(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(errorMessage: 'No internet connection.'));
    }
    try {
      return Right(await remoteDataSource.getReportDetails(id));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReportCategoryModel>>> getCategories() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(errorMessage: 'No internet connection.'));
    }
    try {
      return Right(await remoteDataSource.getCategories());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> cancelReport(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(errorMessage: 'No internet connection.'));
    }
    try {
      final response = await remoteDataSource.cancelReport(id);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}