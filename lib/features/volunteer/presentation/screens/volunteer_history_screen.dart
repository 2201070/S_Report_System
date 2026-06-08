import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/features/volunteer/data/models/volunteer_history_model.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_history_cubit.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_history_state.dart';

class VolunteerHistoryScreen extends StatelessWidget {
  const VolunteerHistoryScreen({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Volunteer History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BlocBuilder<VolunteerHistoryCubit, VolunteerHistoryState>(
                      builder: (context, state) {
                        if (state is VolunteerHistoryLoading) {
                          return const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: AppColors.accentBlue, strokeWidth: 2),
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.refresh,
                              color: Colors.white, size: 22),
                          onPressed: () =>
                              context.read<VolunteerHistoryCubit>().refresh(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: BlocBuilder<VolunteerHistoryCubit, VolunteerHistoryState>(
                  builder: (context, state) {
                    if (state is VolunteerHistoryLoading ||
                        state is VolunteerHistoryInitial) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.accentBlue),
                      );
                    }

                    if (state is VolunteerHistoryError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              style:
                                  const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => context
                                  .read<VolunteerHistoryCubit>()
                                  .refresh(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentBlue),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is VolunteerHistorySuccess) {
                      if (state.missions.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_toggle_off,
                                  color: AppColors.textSecondary, size: 56),
                              SizedBox(height: 16),
                              Text(
                                'No completed missions yet.',
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        itemCount: state.missions.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _MissionHistoryCard(
                              mission: state.missions[index]);
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissionHistoryCard extends StatelessWidget {
  final VolunteerHistoryModel mission;
  const _MissionHistoryCard({required this.mission});

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'rescue':
        return AppColors.accentRed;
      case 'medical':
        return const Color(0xFF00BCD4);
      case 'logistics':
        return AppColors.accentOrange;
      case 'environmental':
        return AppColors.accentGreen;
      default:
        return AppColors.accentBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(mission.missionType);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: title + points badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title.isNotEmpty
                          ? mission.title
                          : 'Mission #${mission.missionId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (mission.missionType.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: typeColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          mission.missionType,
                          style: TextStyle(
                              color: typeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Points Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.accentGreen.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star,
                        color: AppColors.accentGreen, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+${mission.earnedPoints} pts',
                      style: const TextStyle(
                        color: AppColors.accentGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: AppColors.borderPrimary, height: 1),
          const SizedBox(height: 12),

          // Description
          if (mission.description.isNotEmpty)
            Text(
              mission.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),

          const SizedBox(height: 10),

          // Footer: date + ID
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 6),
              Text(
                mission.formattedDate,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
              const Spacer(),
              Text(
                'ID: ${mission.missionId}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
