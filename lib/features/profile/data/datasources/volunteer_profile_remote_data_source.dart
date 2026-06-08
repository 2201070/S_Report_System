import 'package:dio/dio.dart';
import 'package:s_report_system/core/api/api_constants.dart';
import 'package:s_report_system/core/error/exceptions.dart'; // تأكد من استيراد ملف الـ exceptions
import '../models/volunteer_profile_model.dart';

abstract class VolunteerProfileRemoteDataSource {
  Future<VolunteerProfileModel> getVolunteerProfile();
}

class VolunteerProfileRemoteDataSourceImpl implements VolunteerProfileRemoteDataSource {
  final Dio dio; 

  VolunteerProfileRemoteDataSourceImpl({required this.dio});

  // دالة مساعدة لمعالجة أخطاء السيرفر بذكاء
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
  Future<VolunteerProfileModel> getVolunteerProfile() async {
    try {
      // الـ Interceptor يضيف التوكن تلقائياً، لذلك تم إزالة options
      final response = await dio.get('${ApiConstants.baseUrl}/Volunteer/profile');
      
      if (response.statusCode == 200) {
        return VolunteerProfileModel.fromJson(response.data);
      }
      throw ServerException(message: 'Failed to load volunteer profile: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}