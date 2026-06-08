import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_cubit.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_state.dart';
import 'package:s_report_system/features/volunteer/presentation/widgets/mission_card.dart';

class VolunteerDashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateHome;
  final VoidCallback onNavigateSettings;

  const VolunteerDashboardScreen({
    super.key,
    required this.onNavigateHome,
    required this.onNavigateSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: onNavigateHome,
        ),
        title: Text(
          'volunteer.my_tasks_title'.tr(),
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1A1A1A)),
            onPressed: onNavigateSettings,
          ),
        ],
      ),
      body: BlocBuilder<VolunteerCubit, VolunteerState>(
        builder: (context, state) {
          if (state.status == VolunteerStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentBlue));
          }

          // 2. حالة الخطأ
          if (state.status == VolunteerStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'An error occurred',
                style: const TextStyle(color: AppColors.accentRed),
              ),
            );
          }

          final myMissions = state.myMissions;

          if (myMissions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.task_alt, size: 64, color: Color(0xFFD4D4D4)),
                  const SizedBox(height: 16),
                  Text(
                    'volunteer.no_active_missions'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myMissions.length, 
            itemBuilder: (context, index) {
              final mission = myMissions[index]; 
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MissionCard(mission: mission), 
              );
            },
          );
        },
      ),
    );
  }
}