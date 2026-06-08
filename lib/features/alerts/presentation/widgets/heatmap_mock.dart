import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HeatmapMock extends StatelessWidget {
  const HeatmapMock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256, // matching h-64
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a1f26), Color(0xFF0f1318)],
              ),
            ),
          ),
          
          // Grid mock
          Opacity(
            opacity: 0.2,
            child: _buildGrid(),
          ),
          
          // Legend
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundStart.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderPrimary),
              ),
              child: Row(
                children: [
                  _buildLegendItem(AppColors.accentRed, 'Urgent'),
                  const SizedBox(width: 16),
                  _buildLegendItem(AppColors.accentOrange, 'Warning'), 
                  const SizedBox(width: 16),
                  _buildLegendItem(AppColors.accentBlue, 'Info'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Column(
      children: List.generate(6, (rowIndex) {
        return Expanded(
          child: Row(
            children: List.generate(8, (colIndex) {
              final index = rowIndex * 8 + colIndex;
              Color bgColor = Colors.transparent;
              if (index % 7 == 0) {
                bgColor = AppColors.accentRed;
              } else if (index % 5 == 0) bgColor = AppColors.accentOrange; 
              else if (index % 3 == 0) bgColor = AppColors.accentBlue;

              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(color: AppColors.borderPrimary),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.heatmapLegendText),
      ],
    );
  }
}
