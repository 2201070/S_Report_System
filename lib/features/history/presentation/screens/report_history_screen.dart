import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:s_report_system/core/theme/app_colors.dart';
import 'package:s_report_system/core/theme/app_text_styles.dart';
import 'package:s_report_system/core/widgets/app_filter_pill.dart';
import 'package:s_report_system/core/utils/size_config.dart';
import 'package:s_report_system/features/history/presentation/cubit/history_cubit.dart';
import 'package:s_report_system/features/history/presentation/cubit/history_state.dart';
import 'package:s_report_system/features/report/data/models/my_reports_model.dart';

class ReportHistoryScreen extends StatefulWidget {
  final VoidCallback onBack;
  const ReportHistoryScreen({super.key, required this.onBack});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  String _activeFilter = 'all';

  Color _stateColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending': return AppColors.accentOrange;
      case 'inprogress':
      case 'in_progress':
      case 'in progress': return AppColors.accentBlueLight;
      case 'resolved': return AppColors.accentGreen;
      case 'rejected': return AppColors.accentRed;
      default: return AppColors.textSecondary;
    }
  }

  List<MyReportsModel> _filter(List<MyReportsModel> reports) {
    if (_activeFilter == 'all') return reports;
    return reports.where((r) => r.reportState.toLowerCase().contains(_activeFilter)).toList();
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
          child: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              final reports = state is HistorySuccess ? state.reports : <MyReportsModel>[];
              final filtered = _filter(reports);

              return Column(
                children: [
                  _buildHeader(reports, state),
                  _buildFilterPills(reports),
                  Expanded(child: _buildBody(state, filtered)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(List<MyReportsModel> reports, HistoryState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32), onPressed: widget.onBack, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              const SizedBox(width: 16),
              Text('history.title'.tr(), style: AppTextStyles.screenTitle),
              const Spacer(),
              if (state is HistoryLoading)
                const CircularProgressIndicator(color: AppColors.accentBlue)
              else
                IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: () => context.read<HistoryCubit>().refresh()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPills(List<MyReportsModel> reports) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _pill('All', 'all', reports.length, AppColors.textSecondary),
          _pill('Pending', 'pending', reports.where((r) => r.reportState.toLowerCase().contains('pending')).length, AppColors.accentOrange),
          _pill('In Progress', 'inprogress', reports.where((r) => r.reportState.toLowerCase().contains('progress')).length, AppColors.accentBlueLight),
          _pill('Resolved', 'resolved', reports.where((r) => r.reportState.toLowerCase().contains('resolved')).length, AppColors.accentGreen),
        ],
      ),
    );
  }

  Widget _pill(String label, String value, int count, Color color) => Padding(
    padding: const EdgeInsets.only(right: 12),
    child: AppFilterPill(label: label, active: _activeFilter == value, onClick: () => setState(() => _activeFilter = value), count: count, color: color),
  );

  Widget _buildBody(HistoryState state, List<MyReportsModel> filtered) {
    if (state is HistoryLoading) return const Center(child: CircularProgressIndicator());
    
    if (filtered.isEmpty) {
      return LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_add, size: 80.sp, color: Colors.white24),
              SizedBox(height: 20.h),
              Text('No Reports Yet', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              Text('Start your first report now', style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp)),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/select_category'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue, padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h)),
                child: const Text('Start New Report', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      });
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: filtered.length,
      itemBuilder: (context, index) => ReportListTile( 
        report: filtered[index],
        stateColor: _stateColor(filtered[index].reportState),
        onTap: () => Navigator.pushNamed(context, '/report-details', arguments: filtered[index].id),
      ),
    );
  }
}

class ReportListTile extends StatelessWidget {
  final MyReportsModel report;
  final Color stateColor;
  final VoidCallback onTap;

  const ReportListTile({super.key, required this.report, required this.stateColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surfacePrimary, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.borderPrimary)),
        child: Row(
          children: [
            // Thumbnail...
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(report.reportType.isEmpty ? 'Report' : report.reportType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  Text(report.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}