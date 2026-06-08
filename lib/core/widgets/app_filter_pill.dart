import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppFilterPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onClick;
  final int? count;
  final Color? color;

  const AppFilterPill({
    super.key,
    required this.label,
    required this.active,
    required this.onClick,
    this.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.accentBlue : AppColors.surfacePrimary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: active ? AppColors.accentBlue : AppColors.borderPrimary,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? AppColors.backgroundStart : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.backgroundStart
                      : (color ?? AppColors.borderPrimary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: active || color == null
                        ? AppColors.textPrimary
                        : AppColors.backgroundStart,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
