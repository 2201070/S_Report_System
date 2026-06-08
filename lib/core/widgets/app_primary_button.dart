import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool trailingIcon;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.trailingIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: isSecondary ? AppColors.surfacePrimary : AppColors.accentBlue,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSecondary ? const BorderSide(color: AppColors.borderPrimary) : BorderSide.none,
      ),
      shadowColor: isSecondary ? Colors.transparent : AppColors.accentBlue.withValues(alpha: 0.5),
      elevation: isSecondary ? 0 : 8,
    );

    final textWidget = Text(
      text,
      style: TextStyle(
        color: isSecondary ? Colors.white : AppColors.backgroundStart,
        fontSize: 16,
        fontWeight: isSecondary ? FontWeight.w600 : FontWeight.bold,
      ),
    );

    if (icon != null) {
      if (trailingIcon) {
        return ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textWidget,
              const SizedBox(width: 8),
              Icon(icon, color: isSecondary ? Colors.white : AppColors.backgroundStart, size: 20),
            ],
          ),
        );
      }
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon, color: isSecondary ? Colors.white : AppColors.backgroundStart, size: 20),
        label: textWidget,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: textWidget,
    );
  }
}
