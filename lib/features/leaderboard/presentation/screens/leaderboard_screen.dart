import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:s_report_system/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:s_report_system/features/leaderboard/presentation/cubit/leaderboard_state.dart';
import 'package:s_report_system/features/leaderboard/domain/entities/volunteer_rank.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D1117), Color(0xFF010409)],
              ),
            ),
          ),
          
          SafeArea(
            child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
              builder: (context, state) {
                if (state is LeaderboardLoading) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF00BCD4)));
                } else if (state is LeaderboardError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<LeaderboardCubit>().getLeaderboard(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is LeaderboardLoaded) {
                  final topVolunteers = state.volunteers;
                  
                  // لو القائمة فاضية (هندلة الـ Empty State اللي اتكلمنا عنها)
                  if (topVolunteers.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا يوجد متطوعين في لوحة الصدارة حتى الآن\nكن أنت الأول!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (Navigator.of(context).canPop())
                              IconButton(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerLeft,
                                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            if (Navigator.of(context).canPop())
                              const SizedBox(height: 16),
                            const Text(
                              'Leaderboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Top volunteers this month',
                              style: TextStyle(
                                color: Color(0xFF8B949E),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Content
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => context.read<LeaderboardCubit>().getLeaderboard(),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 130.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Podium (Top 3)
                                  if (topVolunteers.length >= 3)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // 2nd Place (Index 1)
                                          Expanded(
                                            child: _buildPodiumColumn(
                                              data: topVolunteers[1],
                                              actualRank: 2, // تمرير الترتيب الصحيح صراحة
                                              height: 80,
                                              ringColor1: const Color(0xFFC0C0C0),
                                              ringColor2: const Color(0xFFA8A8A8),
                                              textColor: const Color(0xFF0D1117),
                                            ),
                                          ),
                                          // 1st Place (Index 0)
                                          Expanded(
                                            child: _buildPodiumColumn(
                                              data: topVolunteers[0],
                                              actualRank: 1, // تمرير الترتيب الصحيح صراحة
                                              height: 112,
                                              ringColor1: const Color(0xFFFFD700),
                                              ringColor2: const Color(0xFFFFA500),
                                              textColor: const Color(0xFF0D1117),
                                              isFirst: true,
                                            ),
                                          ),
                                          // 3rd Place (Index 2)
                                          Expanded(
                                            child: _buildPodiumColumn(
                                              data: topVolunteers[2],
                                              actualRank: 3, // تمرير الترتيب الصحيح صراحة
                                              height: 64,
                                              ringColor1: const Color(0xFFCD7F32),
                                              ringColor2: const Color(0xFFB87333),
                                              textColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  
                                  // All Rankings List
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                                    child: Text(
                                      'All Rankings',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    // هنا استخدام asMap() عشان نجيب الـ Index والـ Value مع بعض
                                    child: Column(
                                      children: topVolunteers.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final v = entry.value;
                                        final rank = index + 1; // الترتيب الحقيقي!
                                        final isTop3 = rank <= 3;
                                        
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF161B22),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: const Color(0xFF30363D)),
                                          ),
                                          child: Row(
                                            children: [
                                              // Rank Badge
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  gradient: isTop3 
                                                      ? const LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [Color(0xFF00BCD4), Color(0xFF00E676)],
                                                        )
                                                      : null,
                                                  color: isTop3 ? null : const Color(0xFF30363D),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '#$rank', // استخدام الترتيب الحقيقي
                                                  style: TextStyle(
                                                    color: isTop3 ? const Color(0xFF0D1117) : const Color(0xFF8B949E),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              // Avatar
                                              _buildAvatar(v.avatarUrl, size: 48),
                                              const SizedBox(width: 16),
                                              // Info
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      v.name,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${v.totalPoints} pts',
                                                      style: const TextStyle(
                                                        color: Color(0xFF00BCD4),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(Icons.trending_up, color: Color(0xFF00E676), size: 24),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? url, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF30363D),
      ),
      alignment: Alignment.center,
      child: url != null && url.isNotEmpty && url.startsWith('http')
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00BCD4)),
                errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.white, size: 24),
              ),
            )
          : const Icon(Icons.person, color: Colors.white, size: 24),
    );
  }

  // تم إضافة actualRank كبارامتر جديد
  Widget _buildPodiumColumn({
    required VolunteerRank data,
    required int actualRank, 
    required double height,
    required Color ringColor1,
    required Color ringColor2,
    required Color textColor,
    bool isFirst = false,
  }) {
    final rank = actualRank.toString(); 
    final name = data.name.split(' ')[0];
    final points = data.totalPoints.toString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFirst)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 32),
          ),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: isFirst ? 80 : 64,
              height: isFirst ? 80 : 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ringColor1, ringColor2],
                ),
                border: Border.all(color: const Color(0xFF0D1117), width: 4),
                boxShadow: isFirst
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: _buildAvatar(data.avatarUrl, size: isFirst ? 72 : 56),
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                width: isFirst ? 32 : 28,
                height: isFirst ? 32 : 28,
                decoration: BoxDecoration(
                  color: ringColor1,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  rank,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isFirst ? 16 : 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          points,
          style: TextStyle(
            color: isFirst ? const Color(0xFFFFD700) : const Color(0xFF00BCD4),
            fontWeight: FontWeight.bold,
            fontSize: isFirst ? 18 : 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                ringColor1.withValues(alpha: 0.0),
                ringColor1.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
      ],
    );
  }
}