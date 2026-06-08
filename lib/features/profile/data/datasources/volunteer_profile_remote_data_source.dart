import 'package:dio/dio.dart';
import '../models/volunteer_profile_model.dart';
// تأكد إن مسار الاستيراد ده صح عندك أو اعمله Import بنفسك
import 'package:s_report_system/core/api/api_constants.dart'; 

abstract class VolunteerProfileRemoteDataSource {
  Future<VolunteerProfileModel> getVolunteerProfile();
}

class VolunteerProfileRemoteDataSourceImpl implements VolunteerProfileRemoteDataSource {
  final Dio dio; 

  VolunteerProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<VolunteerProfileModel> getVolunteerProfile() async {
    final response = await dio.get(
      '/Volunteer/profile',
      options: ApiConstants.authOptions(), 
    );
    
    if (response.statusCode == 200) {
      return VolunteerProfileModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load volunteer profile');
    }
  }
}