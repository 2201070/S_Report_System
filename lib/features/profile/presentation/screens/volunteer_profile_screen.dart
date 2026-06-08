import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/features/profile/presentation/cubit/volunteer_profile_cubit.dart';
import 'package:s_report_system/features/auth/presentation/screens/login_screen.dart';

final List<Map<String, dynamic>> allAchievements = [
  {"title": "First Mission", "icon": Icons.flag},
  {"title": "Helper", "icon": Icons.handshake},
  {"title": "Guardian", "icon": Icons.security},
  {"title": "Hero", "icon": Icons.shield},
  {"title": "Legend", "icon": Icons.military_tech},
];

class VolunteerProfileScreen extends StatelessWidget {
  const VolunteerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A), // خلفية أغمق وأحدث
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Volunteer Profile'.tr(),
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<VolunteerProfileCubit, VolunteerProfileState>(
        builder: (context, state) {
          if (state is VolunteerProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentBlue));
          }

          if (state is VolunteerProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<VolunteerProfileCubit>().fetchProfile(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue),
                  )
                ],
              ),
            );
          }

          if (state is VolunteerProfileSuccess) {
            final profile = state.profile;
            final String name = profile.name ?? 'Volunteer';
            final String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'V';
            final Set<String> earnedSet = Set.from(profile.earnedAchievements ?? []);

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Modern Profile Header
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A2338), Color(0xFF12192A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 15)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.accentOrange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: AppColors.accentOrange.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, color: AppColors.accentOrange, size: 20),
                                  const SizedBox(width: 8),
                                  Text('${profile.totalPoints ?? 0} Points',
                                      style: const TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Avatar with Glow
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(colors: [AppColors.accentBlue, Color(0xFF3B82F6)]),
                              boxShadow: [
                                BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.6), blurRadius: 30, spreadRadius: 8),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ClipOval(
                                child: profile.avatar != null && profile.avatar!.isNotEmpty
                                    ? Image.network(profile.avatar!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(firstLetter))
                                    : _buildAvatarPlaceholder(firstLetter),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Text(name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          const SizedBox(height: 28),

                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn('Missions', (profile.completedMissionsCount ?? 0).toString(), Icons.task_alt),
                              _buildStatDivider(),
                              _buildStatColumn('Achievements', (profile.earnedAchievements?.length ?? 0).toString(), Icons.emoji_events),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Achievements Section
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text("Achievements", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1,
                      ),
                      itemCount: allAchievements.length,
                      itemBuilder: (context, index) {
                        final ach = allAchievements[index];
                        final String title = ach['title'];
                        final bool isUnlocked = earnedSet.contains(title);

                        return _buildModernAchievementBadge(title, ach['icon'], isUnlocked);
                      },
                    ),

                    const SizedBox(height: 40),

                    // Bottom Actions
                    _buildActionButton(
                      text: 'Switch to User Dashboard',
                      icon: Icons.swap_horiz,
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                    ),

                    const SizedBox(height: 12),
                    _buildFlatMenuTile(icon: Icons.history, title: 'My Reports'.tr(), onTap: () => Navigator.pushNamed(context, '/volunteer-history')),

                    const SizedBox(height: 12),
                    _buildFlatMenuTile(
                      icon: Icons.logout,
                      title: 'Sign Out'.tr(),
                      isDestructive: true,
                      onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String letter) {
    return Center(
      child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentBlue, size: 30),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13.5)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 45, width: 1, color: Colors.white24);
  }

  Widget _buildModernAchievementBadge(String title, IconData icon, bool isUnlocked) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2338),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUnlocked ? AppColors.accentBlue.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.08),
          width: isUnlocked ? 1.5 : 1,
        ),
        boxShadow: [
          if (isUnlocked)
            BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: isUnlocked ? 1.0 : 0.35,
                child: Icon(icon, size: 48, color: isUnlocked ? Colors.amberAccent : Colors.white54),
              ),
              if (!isUnlocked)
                const Icon(Icons.lock_rounded, color: Colors.white70, size: 26),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isUnlocked ? Colors.white : Colors.white54,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String text, required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 26),
        label: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          shadowColor: AppColors.accentBlue.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildFlatMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.redAccent : Colors.white;
    final iconColor = isDestructive ? Colors.redAccent : AppColors.accentBlue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF12192A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(width: 18),
            Expanded(child: Text(title, style: TextStyle(color: color, fontSize: 16.5, fontWeight: FontWeight.w600))),
            Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.4), size: 26),
          ],
        ),
      ),
    );
  }
}