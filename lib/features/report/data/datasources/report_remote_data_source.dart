import 'package:dio/dio.dart';
import 'package:s_report_system/core/api/api_constants.dart';
import 'package:s_report_system/core/error/exceptions.dart';
import 'package:s_report_system/features/report/data/models/my_reports_model.dart';
import 'package:s_report_system/features/report/data/models/report_category_model.dart';
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/features/report/data/models/report_response_model.dart';
import 'package:s_report_system/features/report/data/models/report_details_model.dart'; 
import 'package:s_report_system/features/report/data/models/sync_response_model.dart';

abstract class ReportRemoteDataSource {
  Future<ReportResponseModel> createReport(CreateReportModel report);
  Future<List<MyReportsModel>> getMyReports();
  Future<ReportDetailsModel> getReportDetails(int id);
  Future<List<ReportCategoryModel>> getCategories();
  Future<String> cancelReport(int id);
  Future<SyncResponseModel> syncOfflineReports(List<Map<String, dynamic>> reports);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio dio;

  ReportRemoteDataSourceImpl({required this.dio});

  ServerException _handleError(DioException e) {
    String errorMsg = "";
    if (e.response?.data != null) {
      if (e.response!.data is Map && e.response!.data['message'] != null) {
        errorMsg = e.response!.data['message'].toString();
      } else {
        errorMsg = e.response!.data.toString();
      }
    }
    if (errorMsg.trim().isEmpty) {
      errorMsg = e.message ?? "Connection Error: Please check your internet or server status.";
    }
    return ServerException(message: errorMsg);
  }

  @override
  Future<ReportResponseModel> createReport(CreateReportModel report) async {
    try {
      final formData = await report.toFormData();
      final response = await dio.post(
        '${ApiConstants.baseUrl}/Report',
        data: formData,
        // نحدد فقط نوع البيانات هنا لأنها تحتوي على ملفات وصور مرفقة
        options: Options(contentType: 'multipart/form-data'), 
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is String) {
          return ReportResponseModel.fromJson({"message": response.data});
        }
        return ReportResponseModel.fromJson(response.data);
      }
      throw const ServerException(message: 'Failed to create report');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MyReportsModel>> getMyReports() async {
    try {
      // الـ Interceptor يحقن التوكن تلقائياً هنا
      final response = await dio.get('${ApiConstants.baseUrl}/Report/MyReports');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((e) => MyReportsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(message: 'Failed to load reports: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ReportDetailsModel> getReportDetails(int id) async {
    try {
      // الـ Interceptor يحقن التوكن تلقائياً هنا لحل مشكلة الـ 403
      final response = await dio.get('${ApiConstants.baseUrl}/Report/ReportDetails/$id');
      
      if (response.statusCode == 200) {
        return ReportDetailsModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(message: 'Failed to load report details: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ReportCategoryModel>> getCategories() async {
    try {
      final response = await dio.get('${ApiConstants.baseUrl}/Report/Categories');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((e) => ReportCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(message: 'Failed to load categories: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> cancelReport(int id) async {
    try {
      final response = await dio.put('${ApiConstants.baseUrl}/Report/$id/cancel');
      
      if (response.statusCode == 200) {
        return response.data.toString();
      }
      throw const ServerException(message: 'Failed to cancel report');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SyncResponseModel> syncOfflineReports(List<Map<String, dynamic>> reports) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/Report/SynOfflineReports',
        data: reports,
      );
      return SyncResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}