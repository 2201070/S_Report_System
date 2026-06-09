import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://abdallahnasrat-001-site1.anytempurl.com/api';

  static String? currentToken;

  static Future<String?> getToken() async {
    if (currentToken != null && currentToken!.isNotEmpty) {
      return currentToken;
    }
    final prefs = await SharedPreferences.getInstance();
    currentToken = prefs.getString('token');
    return currentToken;
  }

  static Options authOptions({String contentType = 'application/json'}) =>
      Options(
        headers: {
          'Authorization': 'Bearer ${currentToken ?? ''}',
          'Accept': '*/*',
          'Content-Type': contentType,
        },
      );
}