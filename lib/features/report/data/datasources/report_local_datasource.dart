import 'package:hive_flutter/hive_flutter.dart';
import 'package:s_report_system/core/error/exceptions.dart';
import 'package:s_report_system/features/report/data/models/offline_report_model.dart';

abstract class ReportLocalDataSource {
  Future<void> cacheOfflineReport(OfflineReportModel report);
  Future<List<OfflineReportModel>> getCachedOfflineReports();
  Future<void> clearCachedOfflineReports();
}

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  static const String boxName = 'reports_box';
  final Box<OfflineReportModel> reportBox;

  ReportLocalDataSourceImpl({required this.reportBox});

  @override
  Future<void> cacheOfflineReport(OfflineReportModel report) async {
    try {
      await reportBox.add(report);
    } catch (e) {
      throw const CacheException(message: 'Storage is full, cannot save data');
    }
  }

  @override
  Future<List<OfflineReportModel>> getCachedOfflineReports() async {
    try {
      return reportBox.values.toList();
    } catch (e) {
      throw const CacheException(message: 'Failed to access local database');
    }
  }

  @override
  Future<void> clearCachedOfflineReports() async {
    try {
      await reportBox.clear();
    } catch (e) {
      throw const CacheException(message: 'Failed to clear local database');
    }
  }
}