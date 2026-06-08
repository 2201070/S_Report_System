import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/report_history_model.dart';

class ReportCard extends StatefulWidget {
  final ReportHistoryModel report;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const ReportCard({
    super.key,
    required this.report,
    required this.onView,
    required this.onDelete,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    Color statusTextColor = AppColors.backgroundStart;

    switch (widget.report.status) {
      case ReportStatus.pending:
        statusColor = AppColors.accentOrange;
        statusText = 'history.pending'.tr();
        break;
      case ReportStatus.progress:
        statusColor = AppColors.accentBlueLight;
        statusText = 'history.in_progress'.tr();
        statusTextColor = Colors.white;
        break;
      case ReportStatus.resolved:
        statusColor = AppColors.accentGreen;
        statusText = 'dashboard.resolved'.tr();
        break;
      case ReportStatus.urgent:
        statusColor = AppColors.accentRed;
        statusText = 'history.urgent'.tr();
        statusTextColor = Colors.white;
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfacePrimary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? AppColors.accentBlue : AppColors.borderPrimary,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            if (widget.report.thumbnail != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: widget.report.isNetworkImage
                      ? CachedNetworkImage(
                          imageUrl: widget.report.thumbnail!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: AppColors.borderPrimary),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                      : Image.asset(
                          widget.report.thumbnail!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                        ),
                ),
              ),
            if (widget.report.thumbnail != null) const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.report.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.report.category,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ID: ${widget.report.id} • ${widget.report.date}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      // Action Buttons (visible on hover or always on touch devices, but we'll show them always slightly faded and highlight on hover for better mobile UX)
                      Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.remove_red_eye_outlined,
                            hoverColor: AppColors.accentBlue,
                            onTap: widget.onView,
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            icon: Icons.delete_outline,
                            hoverColor: AppColors.accentRed,
                            onTap: widget.onDelete,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color hoverColor,
    required VoidCallback onTap,
  }) {
    // simplified version of the hover actions for touch devices as well
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isHovered ? hoverColor.withValues(alpha: 0.1) : AppColors.borderPrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: _isHovered ? hoverColor : Colors.white,
        ),
      ),
    );
  }
}
