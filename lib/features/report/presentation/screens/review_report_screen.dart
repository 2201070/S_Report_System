import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:s_report_system/features/profile/presentation/cubit/profile_state.dart';
import 'package:s_report_system/features/report/data/models/create_report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_report_system/features/report/presentation/cubit/report_cubit.dart';
import 'package:s_report_system/features/report/presentation/cubit/report_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewReportScreen extends StatefulWidget {
  final CreateReportModel reportData;
  final VoidCallback onBack;

  const ReviewReportScreen({
    super.key,
    required this.reportData,
    required this.onBack,
  });

  @override
  State<ReviewReportScreen> createState() => _ReviewReportScreenState();
}

class _ReviewReportScreenState extends State<ReviewReportScreen> {
  bool _isEmergency = false;
  


  void _handleSubmit() async {
    final prefs = await SharedPreferences.getInstance();
  final cityId = prefs.getInt('cityId') ?? 1;
     debugPrint('🏙️ cityId اللي هيتبعت: $cityId');

    

    // بناء التقرير النهائي ببيانات الشاشات السابقة + مدينة المستخدم
    final finalReport = CreateReportModel(
      description: widget.reportData.description,
      latitude: widget.reportData.latitude,
      longitude: widget.reportData.longitude,
      reportType: widget.reportData.reportType,
      imageFiles: widget.reportData.imageFiles,
      voiceFile: widget.reportData.voiceFile,
      cityId: cityId ,// 👈 إرفاق المدينة هنا
    );
    
    context.read<ReportCubit>().submitReport(finalReport);

  }

  String _getCategoryName(String id) {
    final categories = <String, String>{
      'infrastructure': 'reporting.cat_infrastructure'.tr(),
      'environmental': 'reporting.cat_environmental'.tr(),
      'safety': 'reporting.cat_safety'.tr(),
      'health': 'reporting.cat_health'.tr(),
    };
    return categories[id] ?? id;
  }

  ImageProvider _getImageProvider(String path) {
    if (kIsWeb) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/submission_success',
            (route) => false,
            arguments:
                'SR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          );
        } else if (state is ReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.accentRed,
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
                              'reporting.review_submit'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'reporting.step_3'.tr(),
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                        // Progress Stepper (all completed)
                        Row(
                          children: [
                            Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.accentGreen, borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 8),
                            Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.accentGreen, borderRadius: BorderRadius.circular(2))),
                            const SizedBox(width: 8),
                            Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.accentBlue, borderRadius: BorderRadius.circular(2))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Emergency Toggle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: _isEmergency ? AppColors.accentRed.withValues(alpha: 0.1) : AppColors.surfacePrimary,
                          border: Border.all(
                            color: _isEmergency ? AppColors.accentRed : AppColors.borderPrimary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _isEmergency ? AppColors.accentRed : AppColors.borderPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.warning_amber_rounded,
                                      color: _isEmergency ? Colors.white : AppColors.textSecondary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'reporting.emergency_priority'.tr(),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'reporting.priority_response'.tr(),
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Custom Toggle Switch
                            GestureDetector(
                              onTap: () => setState(() => _isEmergency = !_isEmergency),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 56,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _isEmergency ? AppColors.accentRed : AppColors.borderPrimary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOutBack,
                                      top: 4,
                                      left: _isEmergency ? 28 : 4,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Report Summary Card
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          border: Border.all(color: AppColors.borderPrimary),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'reporting.report_summary'.tr(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            
                            // Category
                            _buildSummaryRow(
                              icon: Icons.description_outlined,
                              label: 'reporting.category'.tr(),
                              value: _getCategoryName(widget.reportData.reportType),
                              showBorder: true,
                            ),
                            const SizedBox(height: 16),

                            // Location
                            _buildSummaryRow(
                              icon: Icons.location_on_outlined,
                              label: 'reporting.location'.tr(),
                              value: '${widget.reportData.latitude}, ${widget.reportData.longitude}',
                              showBorder: true,
                            ),
                            const SizedBox(height: 16),

                            // Media
                            _buildMediaRow(showBorder: widget.reportData.description.isNotEmpty),
                            if (widget.reportData.description.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              // Description
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('reporting.description'.tr(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.reportData.description,
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      // AI Badge
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'reporting.ai_analysis'.tr(),
                              style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'reporting.ai_desc'.tr(),
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Submit Button
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.borderPrimary)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEmergency ? AppColors.accentRed : AppColors.accentBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadowColor: _isEmergency ? AppColors.accentRed.withValues(alpha: 0.4) : null,
                        elevation: _isEmergency ? 8 : 0,
                      ),
                      child: BlocBuilder<ReportCubit, ReportState>(
                        builder: (context, state) {
                          if (state is ReportLoading) {
                            return const Center(child: CircularProgressIndicator(color: Colors.white));
                          }
                          return Text(
                            _isEmergency ? 'reporting.submit_emergency'.tr() : 'reporting.submit_to_authorities'.tr(),
                            style: TextStyle(
                              color: _isEmergency ? Colors.white : AppColors.backgroundStart,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSummaryRow({required IconData icon, required String label, required String value, bool showBorder = false}) {
    return Container(
      padding: showBorder ? const EdgeInsets.only(bottom: 16) : EdgeInsets.zero,
      decoration: showBorder ? const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderPrimary)),
      ) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accentBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaRow({bool showBorder = false}) {
    return Container(
      padding: showBorder ? const EdgeInsets.only(bottom: 16) : EdgeInsets.zero,
      decoration: showBorder ? const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderPrimary)),
      ) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.camera_alt_outlined, color: AppColors.accentBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('reporting.media'.tr(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...widget.reportData.imageFiles.map((img) {
                      return Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderPrimary),
                          image: DecorationImage(
                            image: _getImageProvider(img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
