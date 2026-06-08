import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/nav_action_model.dart';

class QuickActionCard extends StatefulWidget {
  final QuickActionModel action;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.action,
    required this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value) {
        setState(() {
          _isHovered = value;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
             color: _isHovered ? widget.action.iconColor : AppColors.borderPrimary,
             width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.action.icon,
              color: widget.action.iconColor,
              size: 24,
            ),
            const SizedBox(height: 12),
            Text(
              widget.action.title,
              style: AppTextStyles.quickActionTitle,
            ),
            const SizedBox(height: 4),
            Text(
              widget.action.subtitle,
              style: AppTextStyles.quickActionSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}
