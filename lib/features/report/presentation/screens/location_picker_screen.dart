import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/features/report/presentation/widgets/location_search_bar.dart';
import 'package:s_report_system/features/report/presentation/widgets/address_card.dart';
import 'package:s_report_system/features/report/presentation/widgets/map_pin_indicator.dart';
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
  GoogleMapController? _mapController;
  
  LatLng _pickedLocation = const LatLng(26.5591, 31.6957); // سوهاج
  String _address = "جاري تحديد العنوان...";
  bool _isFetchingAddress = false;

  @override
  void initState() {
    super.initState();
    _handleCurrentLocation();
  }

  // دالة جلب العنوان (Reverse Geocoding) 
  Future<void> _getAddressFromLatLng(LatLng position) async {
    if (!mounted) return;
    setState(() => _isFetchingAddress = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address = "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
          
          _searchController.clear(); 
        });
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
      setState(() {
        _address = "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
      });
    } finally {
      if (mounted) setState(() => _isFetchingAddress = false);
    }
  }

  void _animateToLocation(LatLng target) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(target, 16),
    );
    setState(() => _pickedLocation = target);
    _getAddressFromLatLng(target);
  }

  void _handleConfirm() {
    context.read<ReportCubit>().updateLocation(
      _pickedLocation.latitude, 
      _pickedLocation.longitude
    );
    
    final cubit = context.read<ReportCubit>();
    final reportData = CreateReportModel(
      description: cubit.draftDescription,
      latitude: cubit.draftLat,
      longitude: cubit.draftLng,
      reportType: cubit.draftCategory ?? 'environmental',
      cityId: 1, 
      imageFiles: cubit.draftImages,
      voiceFile: cubit.draftVoicePath,
    );
    
    Navigator.pushNamed(context, '/review_report', arguments: reportData);
  }

  Future<void> _handleCurrentLocation() async {
    final isGranted = await PermissionService.requestLocationPermission();
    if (!isGranted) {
       _showPermissionDialog();
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    _animateToLocation(LatLng(position.latitude, position.longitude));
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('reporting.permission_denied'.tr()),
        content: Text('reporting.permission_denied_desc'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('reporting.ok'.tr())),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
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
            children: [
              _buildHeader(),

              // خانة البحث الصورية - لن تعرض العنوان المكتشف
              IgnorePointer(
                child: LocationSearchBar(
                  controller: _searchController,
                  onChanged: (val) {},
                ),
              ),

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
                        GoogleMap(
                          initialCameraPosition: CameraPosition(target: _pickedLocation, zoom: 14),
                          onMapCreated: (controller) => _mapController = controller,
                          onCameraMove: (position) => _pickedLocation = position.target,
                          onCameraIdle: () => _getAddressFromLatLng(_pickedLocation),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                        
                        const Center(child: IgnorePointer(child: MapPinIndicator())),

                        if (_isFetchingAddress)
                          const Positioned(
                            top: 10,
                            left: 0,
                            right: 0,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentBlue)),
                          ),

                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            backgroundColor: AppColors.accentBlue,
                            mini: true,
                            onPressed: _handleCurrentLocation,
                            child: const Icon(Icons.near_me, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              AddressCard(
                address: _address,
                onConfirm: _handleConfirm,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onBack,
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('reporting.location_title'.tr(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('reporting.step_2'.tr(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
              _buildProgressStepper(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStepper() {
    return Row(
      children: [
        _step(AppColors.accentGreen),
        const SizedBox(width: 8),
        _step(AppColors.accentBlue),
        const SizedBox(width: 8),
        _step(AppColors.borderPrimary),
      ],
    );
  }

  Widget _step(Color color) => Container(width: 32, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)));
}