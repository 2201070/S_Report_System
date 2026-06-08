import 'dart:ui';
import 'package:flutter/material.dart';

class AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEarned;
  final Color color;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.isEarned,
    this.color = const Color(0xFF00E5FF),
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = isEarned ? color : Colors.white38;
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: badgeColor.withValues(alpha: 0.1),
            border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
            boxShadow: isEarned ? [
              BoxShadow(
                color: badgeColor.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ] : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Icon(
                icon,
                color: badgeColor,
                size: 32,
                shadows: isEarned ? [Shadow(color: badgeColor, blurRadius: 10)] : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isEarned ? Colors.white : Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
