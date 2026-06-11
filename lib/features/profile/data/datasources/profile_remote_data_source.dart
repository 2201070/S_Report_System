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

  @override
  Future<UserProfileModel> getUserProfile() async {
    final response = await dio.get('${ApiConstants.baseUrl}/User', options: ApiConstants.authOptions());
    return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> data) async {
    await dio.put(
      '${ApiConstants.baseUrl}/User/UserData',
      data: data,
      options: ApiConstants.authOptions(),
    );
        return await getUserProfile();
  }
}