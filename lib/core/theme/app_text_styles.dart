import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../utils/size_config.dart';

class AppTextStyles {
  static TextStyle get headerGreeting => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14.sp,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get headerName => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24.sp,
    height: 1.5,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get volunteerButton => TextStyle(
    color: AppColors.accentGreen,
    fontSize: 14.sp,
    height: 1.5,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get cardTitle => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14.sp,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get cardValue => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 30.sp, 
    height: 1.5,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get cardValueAlt => TextStyle(
    color: AppColors.accentBlue,
    fontSize: 30.sp,
    height: 1.5,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get cardSubtitleText => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14.sp,
    height: 1.5,
  );

  static TextStyle get cardSubtitleHighlight => TextStyle(
    color: AppColors.accentGreen,
    fontSize: 14.sp,
    height: 1.5,
  );
  
  static TextStyle get startButtonLabel => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18.sp,
    height: 1.5,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get quickActionSectionTitle => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get quickActionTitle => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14.sp,
    height: 1.5,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get quickActionSubtitle => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.sp,
    height: 1.5,
  );

  static TextStyle get bottomNavLabelActive => TextStyle(
    color: AppColors.accentBlue,
    fontSize: 12.sp,
    height: 1.5,
  );

  static TextStyle get bottomNavLabelInactive => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.sp,
    height: 1.5,
  );

  static TextStyle get screenTitle => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28.sp,
    height: 1.5,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get screenSubtitle => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16.sp,
    height: 1.5,
  );

  static TextStyle get sectionTitle => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18.sp,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get alertTitle => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get alertBadgeText => TextStyle(
    fontSize: 12.sp,
    height: 1.5,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get alertLocationText => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14.sp,
    height: 1.5,
  );

  static TextStyle get alertMetaText => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.sp,
    height: 1.5,
  );

  static TextStyle get heatmapLegendText => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12.sp,
    height: 1.5,
  );
}
