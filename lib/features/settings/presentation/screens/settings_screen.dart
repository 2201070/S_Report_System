import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/core/theme/app_text_styles.dart';
import 'package:s_report_system/core/localization/language_manager.dart';
import 'package:s_report_system/features/auth/presentation/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ تم الإضافة لمسح البيانات


import 'package:s_report_system/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:s_report_system/features/settings/presentation/cubit/settings_state.dart';
import 'package:s_report_system/features/settings/presentation/widgets/settings_tile.dart';
import 'package:s_report_system/features/settings/presentation/widgets/custom_switch.dart';

import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_cubit.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_state.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SettingsScreen({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.borderPrimary,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                      onPressed: onBack,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'settings.title'.tr(),
                      style: AppTextStyles.screenTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'settings.subtitle'.tr(),
                      style: AppTextStyles.screenSubtitle,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                // 🛡 مراقبة حالة الحساب
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                    final isBlocked = profileState is ProfileSuccess ? profileState.user.rate < 2 : false;

                    return BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        if (state is! SettingsLoaded) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final settings = state.settings;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              _buildVolunteerModeCard(context, settings.isVolunteerMode, isBlocked),
                              // Account Settings
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('settings.account_settings'.tr(), style: AppTextStyles.sectionTitle),
                                    const SizedBox(height: 16),
                                    SettingsTile(
                                      icon: Icons.person_outline,
                                      label: 'settings.profile_info'.tr(),
                                      description: 'settings.profile_info_desc'.tr(),
                                      onClick: () {},
                                    ),
                                    const SizedBox(height: 12),
                                    SettingsTile(
                                      icon: Icons.lock_outline,
                                      label: 'settings.password_security'.tr(),
                                      description: 'settings.password_security_desc'.tr(),
                                      onClick: () {},
                                    ),
                                  ],
                                ),
                              ),

                              // Privacy
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('settings.privacy'.tr(), style: AppTextStyles.sectionTitle),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfacePrimary,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: AppColors.borderPrimary),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'settings.data_sharing'.tr(),
                                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  'settings.data_sharing_desc'.tr(),
                                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomSwitch(
                                            enabled: settings.dataSharing,
                                            onChange: (val) => context.read<SettingsCubit>().toggleDataSharing(val),
                                          ),
                                        ],
                                      ),
                                      ),
                                  ],
                                ),
                              ),

                              // Notification Preferences
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('settings.notifications'.tr(), style: AppTextStyles.sectionTitle),
                                    const SizedBox(height: 16),
                                    _buildNotificationToggle(
                                      icon: Icons.notifications_active_outlined,
                                      title: 'settings.push_notifications'.tr(),
                                      subtitle: 'settings.push_notifications_desc'.tr(),
                                      enabled: settings.pushNotifications,
                                      onChange: (val) => context.read<SettingsCubit>().togglePushNotifications(val),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildNotificationToggle(
                                      icon: Icons.chat_bubble_outline,
                                      title: 'settings.sms_notifications'.tr(),
                                      subtitle: 'settings.sms_notifications_desc'.tr(),
                                      enabled: settings.smsNotifications,
                                      onChange: (val) => context.read<SettingsCubit>().toggleSmsNotifications(val),
                                    ),
                                  ],
                                ),
                              ),

                              // Language Selection
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('settings.language'.tr(), style: AppTextStyles.sectionTitle),
                                    const SizedBox(height: 16),
                                    _buildLanguageSelectionButton(
                                      label: 'English',
                                      value: 'english',
                                      currentValue: settings.language,
                                      onChanged: (val) {
                                        context.read<SettingsCubit>().updateLanguage(val);
                                        LanguageManager.changeLanguage(context, LanguageManager.english);
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildLanguageSelectionButton(
                                      label: 'العربية (Arabic)',
                                      value: 'arabic',
                                      currentValue: settings.language,
                                      onChanged: (val) {
                                        context.read<SettingsCubit>().updateLanguage(val);
                                        LanguageManager.changeLanguage(context, LanguageManager.arabic);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // App Info
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfacePrimary,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.borderPrimary),
                                  ),
                                  child: Column(
                                    children: [
                                      Text('settings.app_version'.tr(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                                      const SizedBox(height: 4),
                                      const Text('v2.4.0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),

                              // Logout Button
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child:  InkWell(
                              onTap: () async {
                                // 🟢 1. إظهار مؤشر تحميل (اختياري)
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.accentRed)),
                                );

                                try {
                                  // 🟢 2. مسح بيانات المستخدم المحفوظة في الذاكرة
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.clear(); // سيمسح الـ userId والـ token وأي بيانات أخرى

                                  // 🟢 3. تسجيل الخروج من Firebase
                                  await FirebaseAuth.instance.signOut();

                                  if (context.mounted) {
                                    // إخفاء مؤشر التحميل
                                    Navigator.pop(context); 
                                    
                                    // 🛑 استبدل Scaffold() باسم شاشة اللوجين الخاصة بك (مثل LoginScreen)
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginScreen()), 
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Navigator.pop(context); // إخفاء مؤشر التحميل في حالة الخطأ
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('حدث خطأ أثناء تسجيل الخروج: $e'), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              },
                                  borderRadius: BorderRadius.circular(16),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentRed.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.accentRed),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.logout, color: AppColors.accentRed, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'settings.log_out'.tr(),
                                          style: const TextStyle(color: AppColors.accentRed, fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildNotificationToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required ValueChanged<bool> onChange,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentBlue, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
            ],
          ),
          CustomSwitch(enabled: enabled, onChange: onChange),
        ],
      ),
    );
  }

  Widget _buildLanguageSelectionButton({
    required String label,
    required String value,
    required String currentValue,
    required ValueChanged<String> onChanged,
  }) {
    final bool isSelected = currentValue == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentBlue.withValues(alpha: 0.1) : AppColors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.accentBlue : AppColors.borderPrimary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.language, color: AppColors.accentBlue, size: 20),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
              ],
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: AppColors.accentBlue, shape: BoxShape.circle),
                child: Center(
                  child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildVolunteerModeCard(BuildContext context, bool isVolunteerMode, bool isBlocked) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isBlocked ? AppColors.accentRed.withValues(alpha: 0.3) : const Color(0xFF30363D)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Volunteer Mode', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      isBlocked ? 'Not available for your account' : 'Activate to see missions',
                      style: TextStyle(color: isBlocked ? AppColors.accentRed.withValues(alpha: 0.7) : const Color(0xFF8B949E), fontSize: 14),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: isBlocked ? false : isVolunteerMode, 
                  activeColor: const Color(0xFF00BCD4),
                  onChanged: isBlocked 
                    ? null 
                    : (value) {
                        context.read<SettingsCubit>().toggleVolunteerMode(value);
                        try {
                          context.read<VolunteerCubit>().toggleVolunteerMode(value);
                        } catch (_) {}
                      },
                ),
              ],
            ),
            
            if (isVolunteerMode && !isBlocked) ...[
              const SizedBox(height: 16),
              const Text('Online and accepting missions', style: TextStyle(color: Color(0xFF00BCD4), fontSize: 14, fontWeight: FontWeight.w600)),
            ],

            if (isBlocked) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.accentRed, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'settings.volunteer_blocked_desc'.tr(),
                        style: const TextStyle(color: AppColors.accentRed, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}