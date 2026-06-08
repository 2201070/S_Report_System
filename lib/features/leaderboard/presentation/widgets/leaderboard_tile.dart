import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/leaderboard_user_model.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardUserModel user;

  const LeaderboardTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: user.rank <= 3
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.accentBlue, AppColors.accentGreen],
                    )
                  : null,
              color: user.rank > 3 ? AppColors.borderPrimary : null,
            ),
            child: Center(
              child: Text(
                '#${user.rank}',
                style: TextStyle(
                  color: user.rank <= 3 ? AppColors.backgroundStart : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Avatar
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.borderPrimary,
              shape: BoxShape.circle,
            ),
            child: Text(
              user.avatar,
              style: const TextStyle(fontSize: 24, height: 1.0),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'leaderboard.pts'.tr(args: [user.points.toString()]),
                      style: const TextStyle(
                        color: AppColors.accentBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: AppColors.accentGreen,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.trend,
                          style: const TextStyle(
                            color: AppColors.accentGreen,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
