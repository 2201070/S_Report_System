import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/dashboard_data_model.dart';

import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_state.dart';

class DashboardHeader extends StatelessWidget {
  final DashboardDataModel data;
  final VoidCallback? onVolunteerTap;
  final VoidCallback onBellTap;

  const DashboardHeader({
    super.key,
    required this.data,
    required this.onVolunteerTap,
    required this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'dashboard.good_morning'.tr(),
                  style: AppTextStyles.headerGreeting,
                ),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    String displayName = "Loading..."; 
                    
                    if (state is ProfileSuccess) {
                      displayName = state.user.firstName; 
                    } else if (state is ProfileError) {
                      displayName = "User"; 
                    }
                    
                    return Text(
                      displayName,
                      style: AppTextStyles.headerName,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onVolunteerTap != null) ...[
                _buildVolunteerButton(),
                SizedBox(width: 12.w),
              ],
              _buildBellButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildVolunteerButton() {
    return InkWell(
      onTap: onVolunteerTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.accentGreen.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              Icons.shield_outlined,
              color: AppColors.accentGreen,
              size: 16.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'dashboard.volunteer'.tr(),
              style: AppTextStyles.volunteerButton,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBellButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onBellTap,
          icon: Icon(Icons.notifications_none, color: Colors.white, size: 28.sp),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppColors.accentRed,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.backgroundStart, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}