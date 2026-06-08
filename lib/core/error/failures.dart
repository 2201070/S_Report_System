import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  const Failure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// --- 1. Server Failures (Dio & Backend) ---
class ServerFailure extends Failure {
  const ServerFailure({required super.errorMessage});

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(errorMessage: 'Connection timeout with API server');
      case DioExceptionType.sendTimeout:
        return const ServerFailure(errorMessage: 'Send timeout with API server');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(errorMessage: 'Receive timeout with API server');
      case DioExceptionType.badCertificate:
        return const ServerFailure(errorMessage: 'Bad Certificate with API server');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure(errorMessage: 'Request to API server was canceled');
      case DioExceptionType.connectionError:
        return const ServerFailure(errorMessage: 'No Internet Connection');
      case DioExceptionType.unknown:
        return ServerFailure(errorMessage: "NETWORK_ERROR: ${dioError.message}");
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    String? extractedMessage;
    
    if (response is Map<String, dynamic> || response is Map) {
      final mapResp = response as Map;
      if (mapResp.containsKey('message')) {
        extractedMessage = mapResp['message']?.toString();
      } else if (mapResp.containsKey('error') && mapResp['error'] is Map) {
        extractedMessage = mapResp['error']['message']?.toString();
      }
    } else if (response != null) {
      extractedMessage = response.toString();
    }

    // 🚨 التعديل السحري لمنع الرسائل الفاضية
    if (extractedMessage != null && extractedMessage.trim().isEmpty) {
      extractedMessage = null; 
    }

    final code = statusCode ?? 500;

    if (code == 400 || code == 401 || code == 403) {
      return ServerFailure(
        errorMessage: extractedMessage ?? 'Unauthorized request or Invalid Data!',
      );
    } else if (code == 404) {
      return const ServerFailure(errorMessage: 'Your request was not found, please try later!');
    } else if (code >= 500) {
      return ServerFailure(errorMessage: extractedMessage ?? 'Internal Server error, please try later');
    } else {
      return ServerFailure(errorMessage: extractedMessage ?? 'Opps! There was an error, please try again');
    }
  }
}

// --- 2. Local Cache Failures (Hive / Database) ---
class CacheFailure extends Failure {
  const CacheFailure({required super.errorMessage});

  factory CacheFailure.fromException(dynamic e) {
    if (e.toString().contains('Full')) {
      return const CacheFailure(errorMessage: 'Storage is full, cannot save data');
    } else if (e.toString().contains('Box not found')) {
      return const CacheFailure(errorMessage: 'Failed to access local database');
    }
    return const CacheFailure(errorMessage: 'An error occurred while retrieving cached data');
  }
}

// --- 3. Business Logic Failures ---
class LogicFailure extends Failure {
  const LogicFailure({required super.errorMessage});

  factory LogicFailure.fromMessage(String msg) {
    return LogicFailure(errorMessage: msg);
  }
}

// --- 4. Network Connectivity Failures ---
class NetworkFailure extends Failure {
  const NetworkFailure({required super.errorMessage});
}