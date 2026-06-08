import 'package:dio/dio.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://abdallahnasrat-001-site1.anytempurl.com/api';

  // متغير ديناميكي لحفظ التوكن الحالي بدلاً من التوكن الثابت
  static String? currentToken;

}