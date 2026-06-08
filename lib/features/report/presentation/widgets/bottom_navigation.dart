import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/nav_action_model.dart';

class CustomBottomNavigation extends StatelessWidget {
  final List<BottomNavModel> items;
  final String activeRoute;
  final Function(String) onNavItemSelected;
  final VoidCallback onStartReport;

  const CustomBottomNavigation({
    super.key,
    required this.items,
    required this.activeRoute,
    required this.onNavItemSelected,
    required this.onStartReport,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Fixed height constraint for layout stabilization
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfacePrimary,
          border: Border(
             top: BorderSide(
               color: AppColors.borderPrimary,
               width: 1.0,
             ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 80,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildNavItem(items[0]),
                      _buildNavItem(items[1]),
                      const SizedBox(width: 56), // Placeholder for FAB space
                      _buildNavItem(items[2]),
                      _buildNavItem(items[3]),
                    ],
                  ),
                ),
                Positioned(
                  top: -20,
                  child: _buildCenterFAB(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BottomNavModel item) {
    final isActive = activeRoute == item.routeName;
    return GestureDetector(
      onTap: () => onNavItemSelected(item.routeName),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            color: isActive ? AppColors.accentBlue : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: isActive 
                ? AppTextStyles.bottomNavLabelActive 
                : AppTextStyles.bottomNavLabelInactive,
          ),
        ],
      ),
    );
  }

  Widget _buildCenterFAB() {
    return GestureDetector(
      onTap: onStartReport,
      child: Container(
        width: 56,
        height: 56,
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
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
