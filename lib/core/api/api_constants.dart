import 'package:dio/dio.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://abdallahnasrat-001-site1.anytempurl.com/api';

  static const String kAuthToken =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjI3IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZW1haWxhZGRyZXNzIjoiYWhtZWQubW9oYW1lZEBleGFtcGxlLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlVzZXIiLCJjaXR5SWQiOiIyOSIsImV4cCI6MTc4MzQ0Mjc0NCwiaXNzIjoiUy1SZXBvcnRfU3lzdGVtIiwiYXVkIjoiUy1SZXBvcnRBcHBsaWNhdGlvbnMifQ.LX-hSpgvLyeOsor0p3UqvgeUW8-Vj3trufmxmhKLs9U';

  /// Default authenticated [Options] for JSON endpoints.
  static Options authOptions({String contentType = 'application/json'}) =>
      Options(
        headers: {
          'Authorization': kAuthToken,
          'Accept': '*/*',
          'Content-Type': contentType,
        },
      );
}
