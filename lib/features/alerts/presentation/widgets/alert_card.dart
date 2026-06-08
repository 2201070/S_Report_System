import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/alert_model.dart';

class AlertCard extends StatefulWidget {
  final AlertModel alert;
  final VoidCallback onTap;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onTap,
  });

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color alertColor;
    IconData alertIcon;
    Color badgeTextColor;

    switch (widget.alert.type) {
      case AlertType.urgent:
        alertColor = AppColors.accentRed;
        alertIcon = Icons.warning_rounded;
        badgeTextColor = Colors.white;
        break;
      case AlertType.warning:
        alertColor = AppColors.accentOrange;
        alertIcon = Icons.error_outline_rounded;
        badgeTextColor = AppColors.backgroundStart;
        break;
      case AlertType.info:
        alertColor = AppColors.accentBlue;
        alertIcon = Icons.info_outline_rounded;
        badgeTextColor = AppColors.backgroundStart;
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: alertColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: alertColor,
              width: 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: alertColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  alertIcon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.alert.title,
                            style: AppTextStyles.alertTitle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: alertColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.alert.type.name.toUpperCase(),
                            style: AppTextStyles.alertBadgeText.copyWith(color: badgeTextColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.alert.location,
                          style: AppTextStyles.alertLocationText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.alert.time,
                          style: AppTextStyles.alertMetaText,
                        ),
                        Text(
                          '${widget.alert.affectedPeople} affected',
                          style: AppTextStyles.alertMetaText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
