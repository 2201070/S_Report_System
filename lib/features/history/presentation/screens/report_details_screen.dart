import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/features/report/data/models/report_details_model.dart'; // ✅ تم التعديل
import 'package:s_report_system/features/report/domain/usecases/get_report_details_usecase.dart';
import 'package:s_report_system/features/report/domain/usecases/cancel_report_usecase.dart';

class ReportDetailsScreen extends StatefulWidget {
  final int reportId;
  const ReportDetailsScreen({super.key, required this.reportId});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  bool _loading = true;
  String? _error;
  ReportDetailsModel? _report; // ✅ تم التعديل
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final useCase = context.read<GetReportDetailsUseCase>();
    final result = await useCase(widget.reportId);
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.errorMessage;
      }),
      (report) => setState(() {
        _loading = false;
        _report = report;
      }),
    );
  }

  Future<void> _cancelReport() async {
    setState(() {
      _isCancelling = true;
    });

    final cancelUseCase = context.read<CancelReportUseCase>();
    final result = await cancelUseCase(widget.reportId);

    setState(() {
      _isCancelling = false;
    });

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      },
      (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        _loadDetails();
      },
    );
  }

  Color _stateColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return AppColors.accentOrange;
      case 'inprogress':
      case 'in progress':
        return AppColors.accentBlueLight;
      case 'resolved':
        return AppColors.accentGreen;
      case 'rejected':
        return AppColors.accentRed;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // App Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Report Details',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.accentBlue));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(_error!,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDetails,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue),
            ),
          ],
        ),
      );
    }
    if (_report == null) return const SizedBox.shrink();

    final report = _report!;
    final stateColor = _stateColor(report.reportState);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media Gallery
          if (report.attachedMedia.isNotEmpty)
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: report.attachedMedia.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: report.attachedMedia[i],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                            color: AppColors.borderPrimary,
                            child: const Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.accentBlue))),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.borderPrimary,
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.white38, size: 48),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (report.attachedMedia.isEmpty)
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.borderPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                  child: Icon(Icons.image_not_supported,
                      color: Colors.white38, size: 48)),
            ),
          const SizedBox(height: 20),

          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderPrimary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type + State
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report.reportType.isNotEmpty
                            ? report.reportType
                            : 'Report #${report.reportId}', // ✅ تم التعديل
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: stateColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: stateColor.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        report.reportState, // ✅ تم التعديل
                        style: TextStyle(
                            color: stateColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderPrimary),
                const SizedBox(height: 12),

                _infoRow(Icons.description_outlined, 'Description',
                    report.description),
                _infoRow(Icons.calendar_today_outlined, 'Date', report.date),
                _infoRow(Icons.confirmation_number_outlined, 'Report ID',
                    '#${report.reportId}'), // ✅ تم التعديل
                _infoRow(Icons.location_on_outlined, 'Coordinates',
                    'Lat: ${report.latitude.toStringAsFixed(5)}, Lng: ${report.longitude.toStringAsFixed(5)}'),
                if (report.attachedMedia.isNotEmpty)
                  _infoRow(Icons.attach_file_outlined, 'Media',
                      '${report.attachedMedia.length} file(s)'),
              ],
            ),
          ),

          // Map Placeholder
          const SizedBox(height: 16),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderPrimary),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_outlined,
                      color: AppColors.accentBlue, size: 40),
                  const SizedBox(height: 8),
                  const Text('Map Location',
                      style: TextStyle(color: Colors.white70)),
                  Text(
                    '${report.latitude.toStringAsFixed(5)}, ${report.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(
                        color: AppColors.accentBlue, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          if (report.reportState.toLowerCase() == 'pending') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isCancelling ? null : _cancelReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isCancelling
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Cancel Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accentBlue, size: 18),
          const SizedBox(width: 10),
          Text('$label: ',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}