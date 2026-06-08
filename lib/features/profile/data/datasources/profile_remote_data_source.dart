import 'package:dio/dio.dart';
import 'package:s_report_system/core/api/api_constants.dart'; 
import 'package:s_report_system/core/error/exceptions.dart';
import 'package:s_report_system/features/profile/data/models/user_profile_model.dart';
abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSourceImpl({required this.dio});

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
  Future<UserProfileModel> getUserProfile() async {
    try {
      // الـ Interceptor يضيف التوكن تلقائياً
      final response = await dio.get('${ApiConstants.baseUrl}/User');
      
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(message: 'Failed to load profile: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> data) async {
    try {
      // الـ Interceptor يضيف التوكن تلقائياً
      final response = await dio.put(
        '${ApiConstants.baseUrl}/User/UserData',
        data: data,
      );
      
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(message: 'Failed to update profile: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
/*abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/User', 
        options: ApiConstants.authOptions(), 
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(message: 'Failed to load profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?.toString() ?? e.message ?? 'Connection Error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}*/