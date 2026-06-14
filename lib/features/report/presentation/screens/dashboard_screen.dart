import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/core/theme/app_text_styles.dart';
import 'package:s_report_system/core/widgets/responsive_layout.dart';
import 'package:s_report_system/features/report/data/models/dashboard_data_model.dart';
import 'package:s_report_system/features/report/data/models/nav_action_model.dart';
import 'package:s_report_system/features/report/presentation/widgets/dashboard_header.dart';
import 'package:s_report_system/features/report/presentation/widgets/start_report_button.dart';
import 'package:s_report_system/features/report/presentation/widgets/quick_action_card.dart';
import 'package:s_report_system/features/report/presentation/widgets/bottom_navigation.dart';

import 'package:s_report_system/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:s_report_system/features/settings/presentation/cubit/settings_state.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_state.dart';

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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        final isBlocked = profileState is ProfileSuccess ? profileState.user.rate < 2 : false;
        return Column(
          children: [
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                final isVolunteerMode = state is SettingsLoaded ? state.settings.isVolunteerMode : false;
                
                return DashboardHeader(
                  data: _data,
                  onVolunteerTap: (isVolunteerMode && !isBlocked) ? () => _onNavigate('volunteer') : null,
                  onBellTap: () => debugPrint('Bell tapped'),
                );
              },
            ),

            if (isBlocked)
              Expanded(
                child: Center(
                  child: _buildRestrictedAccountCard(context),
                ), 
              )
            else
              Expanded(
                child: Column(
                  children: [
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
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRestrictedAccountCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 24.0 : 48.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 32 : 40),
              decoration: BoxDecoration(
                color: AppColors.accentRed.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.2), width: 2),
                    ),
                    child: Icon(
                      Icons.gpp_bad_outlined,
                      color: AppColors.accentRed,
                      size: isSmallScreen ? 48 : 56,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  Text(
                    'dashboard.account_restricted'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 22 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'dashboard.account_restricted_desc'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: isSmallScreen ? 14 : 16,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 32 : 40),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                      
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.accentRed.withValues(alpha: 0.5)),
                        padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16 : 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: Icon(Icons.support_agent, color: AppColors.textSecondary, size: isSmallScreen ? 22 : 26),
                      label: Text(
                        'dashboard.contact_support'.tr(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRail({bool extended = false}) {
    int selectedIndex = _navItems.indexWhere((item) => item.routeName == _activeNav);
    if (selectedIndex == -1) selectedIndex = 0;
    return NavigationRail(
      extended: extended,
      backgroundColor: AppColors.surfacePrimary.withValues(alpha: 200),
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