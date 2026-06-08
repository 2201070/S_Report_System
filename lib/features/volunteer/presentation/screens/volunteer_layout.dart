import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/volunteer_cubit.dart';
import '../cubit/volunteer_state.dart';
import '../../../../core/theme/app_colors.dart';
import 'volunteer_inbox_screen.dart';
import 'volunteer_dashboard_screen.dart';
import '../../../leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:s_report_system/features/profile/presentation/screens/volunteer_profile_screen.dart'; // ✅ السكرين الجديدة
import 'package:s_report_system/features/profile/presentation/cubit/volunteer_profile_cubit.dart'; // ✅ الكيوبت الخاص بالمتطوع
import 'package:s_report_system/report_injection.dart';

class VolunteerLayout extends StatelessWidget {
  final VoidCallback onNavigateHome;
  final VoidCallback onNavigateSettings;

  const VolunteerLayout({
    super.key,
    required this.onNavigateHome,
    required this.onNavigateSettings,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VolunteerCubit, VolunteerState>(
      builder: (context, state) {
        final screens = [
          VolunteerInboxScreen(
            onBack: onNavigateHome,
            onViewMap: () => Navigator.of(context).pushNamed('/volunteer_map'),
          ),
          VolunteerDashboardScreen(
            onNavigateHome: onNavigateHome,
            onNavigateSettings: onNavigateSettings,
          ),
          const LeaderboardScreen(),
          BlocProvider(
            create: (context) => sl<VolunteerProfileCubit>()..fetchProfile(),
            child: const VolunteerProfileScreen(),
          ),
        ];

        return Scaffold(
          backgroundColor: AppColors.backgroundStart,
          extendBody: true,
          body: screens[state.currentIndex],
          bottomNavigationBar: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 1.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF12192A).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
                      BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: -5),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: SizedBox(
                        height: 65.0,
                        child: BottomNavigationBar(
                          currentIndex: state.currentIndex,
                          onTap: (index) => context.read<VolunteerCubit>().changeBottomNav(index),
                          backgroundColor: Colors.transparent,
                          type: BottomNavigationBarType.fixed,
                          elevation: 0,
                          selectedItemColor: AppColors.accentBlue,
                          unselectedItemColor: Colors.white54,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          items: [
                            _buildNavItem(Icons.explore_outlined, Icons.explore, 0, state.currentIndex),
                            _buildNavItem(Icons.task_alt_outlined, Icons.task_alt, 1, state.currentIndex),
                            _buildNavItem(Icons.leaderboard_outlined, Icons.leaderboard, 2, state.currentIndex),
                            _buildNavItem(Icons.person_outline, Icons.person, 3, state.currentIndex),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData outline, IconData filled, int index, int currentIndex) {
    final isSelected = index == currentIndex;
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSelected ? filled : outline, size: 28),
          if (isSelected) ...[
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(color: AppColors.accentBlue, shape: BoxShape.circle),
            ),
          ]
        ],
      ),
      label: '',
    );
  }
}