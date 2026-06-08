import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/core/theme/app_text_styles.dart';
import 'package:s_report_system/features/volunteer/domain/entities/volunteer_task_entity.dart';
import 'package:s_report_system/features/volunteer/data/models/mission_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_cubit.dart';
import 'package:s_report_system/features/volunteer/presentation/cubit/volunteer_state.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';

class MissionDetailsScreen extends StatefulWidget {
  final VolunteerTaskEntity mission;
  final VoidCallback onBack;

  const MissionDetailsScreen({
    super.key,
    required this.mission,
    required this.onBack,
  });

  @override
  State<MissionDetailsScreen> createState() => _MissionDetailsScreenState();
}

class _MissionDetailsScreenState extends State<MissionDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  late final List<String> _dummyImages;

  @override
  void initState() {
    super.initState();
    _dummyImages = [
      MissionModel.placeholderImage,
      MissionModel.placeholderImage,
      MissionModel.placeholderImage,
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openInMaps() async {
    final lat = widget.mission.latitude;
    final lng = widget.mission.longitude;
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('volunteer.could_not_open_map'.tr())),
        );
      }
    }
  }

  void _showConfirmationModal(bool isAccepting) {
    final cubit = context.read<VolunteerCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundStart,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: AppColors.borderPrimary),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderPrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(bottom: 24),
                ),
                Icon(
                  isAccepting ? Icons.check_circle_outline : Icons.cancel_outlined,
                  color: isAccepting ? AppColors.accentGreen : AppColors.accentRed,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  isAccepting ? 'Accept Mission?' : 'Decline Mission?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isAccepting
                      ? (widget.mission.status == 'Accepted' ? 'Are you sure you want to mark this mission as completed?' : 'You are about to accept this mission. Please ensure you can reach the location and complete the task.')
                      : 'Are you sure you want to decline this mission? It will be reassigned to another volunteer.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.borderPrimary),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        // ✅ التعديل هنا: الـ Text بداخل الـ OutlinedButton
                        child: Text(
                          'reporting.cancel'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BlocBuilder<VolunteerCubit, VolunteerState>(
                        builder: (context, state) {
                          final isLoading = state.status == VolunteerStatus.actionLoading;
                          return ElevatedButton(
                            onPressed: isLoading ? null : () {
                              if (isAccepting) {
                                if (widget.mission.status == 'Accepted') {
                                  context.read<VolunteerCubit>().completeMission(widget.mission.reportId);
                                } else {
                                  context.read<VolunteerCubit>().acceptMission(widget.mission.reportId);
                                }
                              } else {
                                context.read<VolunteerCubit>().declineMission(
                                  widget.mission.reportId,
                                  lat: widget.mission.latitude,
                                  lng: widget.mission.longitude,
                                  cityId: 1, 
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAccepting ? AppColors.accentBlue : AppColors.accentRed,
                              foregroundColor: isAccepting ? AppColors.backgroundStart : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading && isAccepting
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : Text(
                                    isAccepting ? 'Confirm' : 'Decline',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VolunteerCubit, VolunteerState>(
      listenWhen: (previous, current) => 
          previous.status == VolunteerStatus.actionLoading && current.status != VolunteerStatus.actionLoading,
      listener: (context, state) {
        if (state.status == VolunteerStatus.taskAcceptedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('reporting.mission_accepted'.tr())),
          );
          Navigator.of(context).pop(); 
          Navigator.of(context).pop(); 
        } else if (state.status == VolunteerStatus.taskCompletedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('reporting.task_completed'.tr())),
          );
          context.read<ProfileCubit>().refresh();
          Navigator.of(context).pop(); 
          Navigator.of(context).pop(); 
        } else if (state.status == VolunteerStatus.taskDeclinedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('reporting.mission_declined'.tr())),
          );
          Navigator.of(context).pop(); 
          Navigator.of(context).pop(); 
        } else if (state.status == VolunteerStatus.error) {
          Navigator.of(context).pop(); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  if (widget.mission.status == 'Accepted') {
                    context.read<VolunteerCubit>().completeMission(widget.mission.reportId);
                  } else {
                    context.read<VolunteerCubit>().acceptMission(widget.mission.reportId);
                  }
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundStart,
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                            color: AppColors.surfacePrimary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderPrimary),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'volunteer.mission_details'.tr(),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '#${widget.mission.reportId}',
                            style: const TextStyle(
                              color: AppColors.accentBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48), 
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 250,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemCount: _dummyImages.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    _dummyImages[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: AppColors.surfacePrimary,
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported, color: AppColors.textSecondary, size: 48),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '${_currentImageIndex + 1} / ${_dummyImages.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _dummyImages.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: _currentImageIndex == index ? 24 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _currentImageIndex == index ? AppColors.accentBlue : Colors.white.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mission.status.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.mission.cityName ?? 'Unknown location',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surfacePrimary.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.borderPrimary),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined, color: AppColors.accentBlue, size: 20),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Date Logged', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                        Text(DateFormat('MMM d, yyyy').format(widget.mission.createdAt), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              Text(
                                'volunteer.report_desc'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surfacePrimary.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.borderPrimary),
                                ),
                                child: Text(
                                  widget.mission.description,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    height: 1.5,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _openInMaps,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.accentBlue),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(Icons.map_outlined, color: AppColors.accentBlue),
                                  label: Text(
                                    'volunteer.open_maps'.tr(),
                                    style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.backgroundEnd,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton.icon(
                          onPressed: () => _showConfirmationModal(false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.accentRed.withValues(alpha: 0.5)),
                            backgroundColor: AppColors.surfacePrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.close, color: AppColors.accentRed, size: 20),
                          label: Text(
                            'volunteer.decline'.tr(),
                            style: const TextStyle(color: AppColors.accentRed, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () => _showConfirmationModal(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentBlue,
                            foregroundColor: AppColors.backgroundStart,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle_outline, size: 20),
                          label: Text(
                            widget.mission.status == 'Accepted' ? 'reporting.complete_mission'.tr() : 'reporting.accept_mission'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}