import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_constants.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 25);

    if (_dio == null) {
      _dio = Dio();
      
      _dio!
        ..options.baseUrl = ApiConstants.baseUrl 
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      addDioInterceptor();
    }
    
    return _dio!;
  }

  static void addDioInterceptor() {
    _dio?.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    _dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Accept'] ??= 'application/json';
         if (!options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer ${ApiConstants.kAuthToken}';
          }
          return handler.next(options);
        },
      ),
    );
  }
}