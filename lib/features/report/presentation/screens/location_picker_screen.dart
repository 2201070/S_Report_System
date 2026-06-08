import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/features/report/presentation/widgets/location_search_bar.dart';
import 'package:s_report_system/features/report/presentation/widgets/address_card.dart';
import 'package:s_report_system/features/report/presentation/widgets/map_pin_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_report_system/features/report/presentation/cubit/report_cubit.dart';
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:s_report_system/core/utils/permission_service.dart';

class LocationPickerScreen extends StatefulWidget {
  final VoidCallback onBack;

  const LocationPickerScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _address = "123 Al-Ahram St, Giza";

  void _handleConfirm() {
    context.read<ReportCubit>().updateLocation(30.0444, 31.2357);
    final cubit = context.read<ReportCubit>();
    final reportData = CreateReportModel(
      description: cubit.draftDescription,
      latitude: cubit.draftLat,
      longitude: cubit.draftLng,
      reportType: cubit.draftCategory ?? 'environmental',
      cityId: 2, // Default cityId
      imageFiles: cubit.draftImages,
      voiceFile: cubit.draftVoicePath,
    );
    Navigator.pushNamed(context, '/review_report', arguments: reportData);
  }

  void _handleCurrentLocation() async {
    final isGranted = await PermissionService.requestLocationPermission();
    if (!isGranted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('reporting.permission_denied'.tr()),
            content: Text('reporting.permission_denied_desc'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('reporting.ok'.tr()),
              ),
            ],
          ),
        );
      }
      return;
    }

    setState(() {
      _address = "Current Location: 123 Al-Ahram St, Giza";
      _searchController.text = _address;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.borderPrimary)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: widget.onBack,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'reporting.location_title'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'reporting.step_2'.tr(),
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                        // Progress Stepper (Green, Cyan, Gray)
                        Row(
                          children: [
                            Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.accentGreen, borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 8),
                            Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.accentBlue, borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 8),
                            Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.borderPrimary, borderRadius: BorderRadius.circular(2))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              LocationSearchBar(
                controller: _searchController,
                onChanged: (val) {
                  // In a real app we'd trigger a search here
                },
              ),

              // Map Area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.borderPrimary),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [
                        // Map Placeholder
                        Positioned.fill(
                          child: Container(
                            color: AppColors.backgroundStart,
                            child: const Center(
                              child: Text(
                                'Map View Area',
                                style: TextStyle(color: AppColors.borderPrimary, fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                        
                        // Centered Pin
                        const Center(
                          child: MapPinIndicator(),
                        ),

                        // Current Location Button
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: InkWell(
                            onTap: _handleCurrentLocation,
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: AppColors.accentBlue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.near_me,
                                color: AppColors.backgroundStart,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Address Card
              AddressCard(
                address: _address,
                onConfirm: _handleConfirm,
              ),

              const SizedBox(height: 16), // Bottom Padding
            ],
          ),
        ),
      ),
    );
  }
}
