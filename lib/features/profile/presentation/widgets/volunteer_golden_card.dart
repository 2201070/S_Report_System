import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/core/navigation/app_router.dart';
import '../cubit/volunteer_profile_cubit.dart';
import '../../data/models/volunteer_profile_model.dart';

class VolunteerGoldenCard extends StatefulWidget {
  const VolunteerGoldenCard({super.key});

  @override
  State<VolunteerGoldenCard> createState() => _VolunteerGoldenCardState();
}

class _VolunteerGoldenCardState extends State<VolunteerGoldenCard> {
  @override
  void initState() {
    super.initState();
    context.read<VolunteerProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VolunteerProfileCubit, VolunteerProfileState>(
      builder: (context, state) {
        if (state is VolunteerProfileLoading || state is VolunteerProfileInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(color: Colors.amber)),
          );
        } else if (state is VolunteerProfileSuccess) {
          return _buildCard(state.profile, context);
        } else if (state is VolunteerProfileError) {
           return Padding(
             padding: const EdgeInsets.symmetric(vertical: 16),
             child: Center(
               child: Column(
                 children: [
                   const Icon(Icons.error_outline, color: Colors.red),
                   const SizedBox(height: 8),
                   Text(state.message, style: const TextStyle(color: Colors.red)),
                 ],
               ),
             ),
           );
        }
        return const SizedBox.shrink(); 
      },
    );
  }

  Widget _buildCard(VolunteerProfileModel profile, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2C220E), Color(0xFF1A1408)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                      image: profile.avatar != null && profile.avatar!.isNotEmpty
                          ? DecorationImage(image: NetworkImage(profile.avatar!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: profile.avatar == null || profile.avatar!.isEmpty
                        ? const Center(
                            child: Icon(Icons.person, color: Colors.amber, size: 32),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hero Volunteer',
                          style: TextStyle(color: Colors.amber.withValues(alpha: 0.8), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white12, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(Icons.star_rounded, profile.totalPoints.toString(), 'Points'),
                  Container(width: 1, height: 40, color: Colors.white12),
                  _buildStatColumn(Icons.task_alt_rounded, profile.completedMissionsCount.toString(), 'Missions'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRouter.volunteer);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.volunteer_activism, color: Colors.amber),
                SizedBox(width: 12),
                Text(
                  'Switch to Volunteer Dashboard',
                  style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, color: Colors.amber),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.amber, size: 20),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
      ],
    );
  }
}
