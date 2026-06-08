import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final bool isPrimaryColor;
  final String? highlightText;
  final String? subtitleText;

  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
    this.isPrimaryColor = true,
    this.highlightText,
    this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Fixed width for stability
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderPrimary,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? AppColors.accentBlue, size: 24),
            const SizedBox(height: 8),
          ],
          Text(
            title, 
            style: AppTextStyles.cardTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: isPrimaryColor ? AppTextStyles.cardValue : AppTextStyles.cardValueAlt,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (highlightText != null || subtitleText != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (highlightText != null && highlightText!.isNotEmpty)
                  Flexible(
                    child: Text(
                      highlightText!,
                      style: AppTextStyles.cardSubtitleHighlight,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (subtitleText != null && highlightText != null && highlightText!.isNotEmpty)
                  const SizedBox(width: 4),
                if (subtitleText != null)
                  Flexible(
                    child: Text(
                      subtitleText!,
                      style: AppTextStyles.cardSubtitleText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            )
          ]
        ],
      ),
    );
  }
}
