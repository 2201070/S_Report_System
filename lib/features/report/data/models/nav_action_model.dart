import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class QuickActionModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String routeName;

  QuickActionModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.routeName,
  });

  // Dummy Data
  static List<QuickActionModel> get dummyActions {
    return [
      QuickActionModel(
        title: 'dashboard.my_reports'.tr(),
        subtitle: 'dashboard.history_subtitle'.tr(),
        icon: Icons.access_time_filled,
        iconColor: const Color(0xFF00BCD4),
        routeName: 'history',
      ),
      QuickActionModel(
        title: 'dashboard.alerts'.tr(),
        subtitle: 'dashboard.safety_updates'.tr(),
        icon: Icons.warning_rounded,
        iconColor: const Color(0xFFFF1744),
        routeName: 'alerts',
      ),
    ];
  }
}

class BottomNavModel {
  final String label;
  final IconData icon;
  final String routeName;

  BottomNavModel({
    required this.label,
    required this.icon,
    required this.routeName,
  });

  static List<BottomNavModel> get dummyNavItems {
    return [
      BottomNavModel(label: 'dashboard.home'.tr(), icon: Icons.home_filled, routeName: 'home'),
      BottomNavModel(label: 'dashboard.history'.tr(), icon: Icons.access_time_filled, routeName: 'history'),
      BottomNavModel(label: 'dashboard.alerts'.tr(), icon: Icons.warning_rounded, routeName: 'alerts'),
      BottomNavModel(label: 'dashboard.profile'.tr(), icon: Icons.person, routeName: 'profile'),
    ];
  }
}
