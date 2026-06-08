import 'package:easy_localization/easy_localization.dart';

class StatModel {
  final String title;
  final String value;
  final String highlightText;
  final String? subtitleText;
  final bool isPrimaryColor;

  StatModel({
    required this.title,
    required this.value,
    this.highlightText = '',
    this.subtitleText,
    this.isPrimaryColor = true,
  });
}

class DashboardDataModel {
  final String userName;
  final List<StatModel> stats;

  DashboardDataModel({
    required this.userName,
    required this.stats,
  });

  // Dummy Data
  static DashboardDataModel get dummyData {
    return DashboardDataModel(
      userName: 'Abdalrhman',
      stats: [
        StatModel(
          title: 'dashboard.active_reports'.tr(),
          value: '3',
          highlightText: '+1',
          subtitleText: 'dashboard.this_week'.tr(),
        ),
        StatModel(
          title: 'dashboard.points_earned'.tr(),
          value: '1,240',
          highlightText: 'dashboard.level_5'.tr(),
          isPrimaryColor: false,
        ),
      ],
    );
  }
}
