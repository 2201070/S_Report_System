import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../domain/entities/volunteer_task_entity.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_cubit.dart';
import '../cubit/volunteer_state.dart';
import '../widgets/mission_card.dart';

import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerInboxScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onViewMap;

  const VolunteerInboxScreen({
    super.key,
    required this.onBack,
    required this.onViewMap,
  });

  @override
  State<VolunteerInboxScreen> createState() => _VolunteerInboxScreenState();
}

class _VolunteerInboxScreenState extends State<VolunteerInboxScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMissionsWithLocation();
    });
  }

  // الدالة الجديدة لجلب الموقع الحقيقي
  Future<void> _fetchMissionsWithLocation() async {
   final prefs = await SharedPreferences.getInstance();
  int cityIdToUse = prefs.getInt('cityId') ?? 29;


    // إحداثيات افتراضية في حالة عدم تفعيل الـ GPS
    double currentLat = 26.5569; 
    double currentLng = 31.6948; 

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          currentLat = position.latitude;
          currentLng = position.longitude;
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }

    if (mounted) {
      context.read<VolunteerCubit>().getNearbyMissions(
        lat: currentLat,
        lng: currentLng,
        cityId: cityIdToUse,
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onViewDetails(VolunteerTaskEntity mission) {
    debugPrint('View Details for mission: ${mission.reportId}');
    Navigator.pushNamed(context, '/mission_details', arguments: mission);
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'volunteer.no_missions_found'.tr(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ⚠️ دالة البناء (Build) اللي كانت مفقودة
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
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
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: widget.onBack,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'volunteer.missions_title'.tr(),
                        style: AppTextStyles.screenTitle,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        BlocBuilder<VolunteerCubit, VolunteerState>(
                          builder: (context, state) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppColors.accentOrange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.accentOrange.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: AppColors.accentOrange, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${state.totalPoints} pts',
                                    style: const TextStyle(
                                      color: AppColors.accentOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        InkWell(
                          onTap: widget.onViewMap,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(Icons.location_on_outlined, color: AppColors.accentBlue, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Body Content
              Expanded(
                child: BlocBuilder<VolunteerCubit, VolunteerState>(
                  builder: (context, state) {
                    final isOnline = state.isOnline;
                    final missions = state.missions;

                    return Column(
                      children: [
                        // Status Indicator Banner
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isOnline ? AppColors.accentGreen.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isOnline ? AppColors.accentGreen.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.show_chart,
                                          color: isOnline ? AppColors.accentGreen : Colors.grey,
                                          size: 24,
                                        ),
                                        if (isOnline)
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: FadeTransition(
                                              opacity: _pulseController,
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: AppColors.accentGreen,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isOnline ? 'Online – Ready for Missions' : 'Offline',
                                          style: TextStyle(
                                            color: isOnline ? AppColors.accentGreen : Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${missions.length} missions assigned',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.5),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () => context.read<VolunteerCubit>().toggleVolunteerMode(!isOnline),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isOnline ? AppColors.accentGreen.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                                    foregroundColor: isOnline ? AppColors.accentGreen : Colors.grey,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  child: Text('volunteer.toggle'.tr()),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Error State Handling
                        if (state.status == VolunteerStatus.error && state.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: AppColors.accentRed),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        // Loading State Handling
                        if (state.status == VolunteerStatus.loading)
                          const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.accentBlue))),

                        // Empty State Handling
                        if (state.status == VolunteerStatus.loaded && missions.isEmpty)
                          Expanded(
                            child: _buildEmptyState(),
                          )
                        else if (state.status != VolunteerStatus.loading)
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              itemCount: missions.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                return TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 20, end: 0),
                                  duration: Duration(milliseconds: 400 + (index * 100)),
                                  curve: Curves.easeOut,
                                  builder: (context, double value, child) {
                                    return Transform.translate(
                                      offset: Offset(0, value),
                                      child: Opacity(
                                        opacity: 1 - (value / 20),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: InkWell(
                                    onTap: () => _onViewDetails(missions[index]),
                                    child: MissionCard(
                                      mission: missions[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
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
}