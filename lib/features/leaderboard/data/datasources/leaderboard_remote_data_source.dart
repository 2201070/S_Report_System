import 'package:dio/dio.dart';
import 'package:s_report_system/core/api/api_constants.dart';
import 'package:s_report_system/core/error/exceptions.dart';
import 'package:s_report_system/features/leaderboard/data/models/leaderboard_model.dart';

abstract class LeaderboardRemoteDataSource {
  Future<List<LeaderboardModel>> getLeaderboard();
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final Dio dio;

  LeaderboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<LeaderboardModel>> getLeaderboard() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/Volunteer/leaderboard',
        options: ApiConstants.authOptions(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((item) =>
                LeaderboardModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(
          message: 'Failed to load leaderboard: ${response.statusCode}');
    } on DioException catch (e) {
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
      
      throw ServerException(message: errorMsg);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}