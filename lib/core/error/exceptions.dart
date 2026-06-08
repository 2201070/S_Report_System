/// [ServerException] 
class ServerException implements Exception {
  final String? message;

  const ServerException({this.message});
}

/// [CacheException] 
class CacheException implements Exception {
  final String? message;

  const CacheException({this.message});
}

/// [OfflineException]
class OfflineException implements Exception {}

/// [LogicException]
class LogicException implements Exception {
  final String? message;

  const LogicException({this.message});
}