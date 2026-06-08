import 'package:dio/dio.dart';
import 'package:s_report_system/core/api/api_constants.dart';
import 'package:s_report_system/core/error/exceptions.dart';
import 'package:s_report_system/features/volunteer/data/models/mission_model.dart';
import 'package:s_report_system/features/volunteer/data/models/volunteer_history_model.dart';

abstract class VolunteerRemoteDataSource {
  Future<List<MissionModel>> getNearbyMissions(
      {required double lat, required double lng, int cityId = 1});
  Future<void> acceptMission(int id);
  Future<void> completeMission(int id);
  Future<void> cancelMission(int id);
  Future<MissionModel?> getCurrentMission();
  Future<List<VolunteerHistoryModel>> getVolunteerHistory();
}

class VolunteerRemoteDataSourceImpl implements VolunteerRemoteDataSource {
  final Dio dio;

  VolunteerRemoteDataSourceImpl({required this.dio});

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
  Future<List<MissionModel>> getNearbyMissions(
      {required double lat, required double lng, int cityId = 1}) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/Volunteer/nearby',
        queryParameters: {'lat': lat, 'lng': lng, 'cityId': cityId},
      );
      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((e) => MissionModel.fromJson(e))
            .toList();
      }
      throw ServerException(message: 'Failed to load nearby missions.');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> acceptMission(int id) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/Volunteer/AcceptMission',
        queryParameters: {'missionId': id},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
         throw ServerException(message: 'Failed to accept mission.');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> completeMission(int id) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/Volunteer/complete/$id',
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
         throw ServerException(message: 'Failed to complete mission.');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> cancelMission(int id) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/Volunteer/cancel/$id',
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
         throw ServerException(message: 'Failed to cancel mission.');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MissionModel?> getCurrentMission() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/Volunteer/current',
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map && (response.data as Map).isEmpty) return null;
        return MissionModel.fromJson(response.data);
      } else if (response.statusCode == 204) {
        return null;
      }
      throw ServerException(message: 'Failed to fetch current mission.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw _handleError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<VolunteerHistoryModel>> getVolunteerHistory() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/Volunteer/History',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((e) =>
                VolunteerHistoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(message: 'Failed to fetch volunteer history.');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}