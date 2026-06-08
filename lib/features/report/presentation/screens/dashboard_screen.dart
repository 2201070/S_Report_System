import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ تم إضافة الإضافة
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/core/theme/app_text_styles.dart';
import 'package:s_report_system/core/widgets/responsive_layout.dart';
import 'package:s_report_system/features/report/data/models/dashboard_data_model.dart';
import 'package:s_report_system/features/report/data/models/nav_action_model.dart';
import 'package:s_report_system/features/report/presentation/widgets/dashboard_header.dart';
import 'package:s_report_system/features/report/presentation/widgets/start_report_button.dart';
import 'package:s_report_system/features/report/presentation/widgets/quick_action_card.dart';
import 'package:s_report_system/features/report/presentation/widgets/bottom_navigation.dart';

// ✅ تم إضافة الـ Cubit والـ State
import 'package:s_report_system/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:s_report_system/features/settings/presentation/cubit/settings_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _activeNav = 'home';
  final DashboardDataModel _data = DashboardDataModel.dummyData;
  final List<QuickActionModel> _quickActions = QuickActionModel.dummyActions;
  final List<BottomNavModel> _navItems = BottomNavModel.dummyNavItems;

  void _onNavigate(String routeName) {
    setState(() {
      _activeNav = routeName;
    });
    debugPrint('Navigating to $routeName');
    if (routeName == 'alerts') {
      Navigator.pushNamed(context, '/alerts');
    } else if (routeName == 'history') {
      Navigator.pushNamed(context, '/history');
    } else if (routeName == 'profile') {
      Navigator.pushNamed(context, '/profile');
    } else if (routeName == 'volunteer') {
      Navigator.pushNamed(context, '/volunteer');
    }
  }

  void _onStartReport() {
    Navigator.pushNamed(context, '/select_category');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            mobileBody: Column(
              children: [
                Expanded(child: _buildMainContent()),
                CustomBottomNavigation(
                  items: _navItems,
                  activeRoute: _activeNav,
                  onNavItemSelected: _onNavigate,
                  onStartReport: _onStartReport,
                ),
              ],
            ),
            tabletBody: Row(
              children: [
                _buildNavigationRail(),
                Expanded(child: _buildMainContent()),
              ],
            ),
            desktopBody: Row(
              children: [
                _buildNavigationRail(extended: true),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final isVolunteerMode = state is SettingsLoaded ? state.settings.isVolunteerMode : false;
            
            return DashboardHeader(
              data: _data,
              onVolunteerTap: isVolunteerMode ? () => _onNavigate('volunteer') : null,
              onBellTap: () => debugPrint('Bell tapped'),
            );
          },
        ),

        Expanded(
          child: Center(
            child: StartReportButton(onStartReport: _onStartReport),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('dashboard.quick_actions'.tr(), style: AppTextStyles.quickActionSectionTitle),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: QuickActionCard(action: _quickActions[0], onTap: () => _onNavigate(_quickActions[0].routeName))),
                  const SizedBox(width: 12),
                  Expanded(child: QuickActionCard(action: _quickActions[1], onTap: () => _onNavigate(_quickActions[1].routeName))),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationRail({bool extended = false}) {
    int selectedIndex = _navItems.indexWhere((item) => item.routeName == _activeNav);
    if (selectedIndex == -1) selectedIndex = 0;

    return NavigationRail(
      extended: extended,
      backgroundColor: AppColors.surfacePrimary.withAlpha(200),
      selectedIconTheme: const IconThemeData(color: AppColors.accentBlue),
      selectedIndex: selectedIndex,
      onDestinationSelected: (idx) {
        if (idx == _navItems.length) _onStartReport(); else _onNavigate(_navItems[idx].routeName);
      },
      destinations: [
        ..._navItems.map((item) => NavigationRailDestination(icon: Icon(item.icon), label: Text(item.label))),
        NavigationRailDestination(
          icon: const Icon(Icons.add_circle, color: AppColors.accentGreen),
          label: Text('reporting.start_report'.tr()),
        ),
      ],
    );
  }
}