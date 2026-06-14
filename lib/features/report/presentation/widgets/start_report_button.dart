import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class StartReportButton extends StatefulWidget {
  final VoidCallback onStartReport;

  const StartReportButton({super.key, required this.onStartReport});

  @override
  State<StartReportButton> createState() => _StartReportButtonState();
}

class _StartReportButtonState extends State<StartReportButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 0.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 160.0;
    const double stackSize = 220.0;

    return GestureDetector(
      onTap: widget.onStartReport,
      child: SizedBox(
        width: stackSize,
        height: stackSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentBlue.withValues(alpha: _opacityAnimation.value),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentBlue.withValues(alpha: _opacityAnimation.value),
                          blurRadius: 40,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.accentBlue, AppColors.accentBlueDark],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentBlue.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, 

                children: [
                   const Icon(Icons.add, color: AppColors.textPrimary, size: 36),
                   const SizedBox(height: 4),
                   Text('reporting.start_report'.tr().split(' ').first, style: AppTextStyles.startButtonLabel),
                   Text('reporting.start_report'.tr().replaceAll('reporting.start_report'.tr().split(' ').first, '').trim(), style: AppTextStyles.startButtonLabel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
