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
          print('🔑 My Current Token: ${ApiConstants.currentToken}');
          
          // ✅ تم إضافة شرط للتأكد من وجود التوكن فعلياً لتجنب إرسال "Bearer null"
          if (!options.headers.containsKey('Authorization') && 
              ApiConstants.currentToken != null && 
              ApiConstants.currentToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${ApiConstants.currentToken}';
          }
          
          return handler.next(options);
        },
      ),
    );
  }
}