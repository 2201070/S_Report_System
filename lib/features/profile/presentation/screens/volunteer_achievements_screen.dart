import 'package:flutter/material.dart';
import 'package:s_report_system/core/theme/app_colors.dart';

class VolunteerAchievementsScreen extends StatelessWidget {
  final List<String> earnedAchievements;
  
  final List<Map<String, dynamic>> allAchievements = [
    {"title": "First Mission", "icon": Icons.flag},
    {"title": "Helper", "icon": Icons.handshake},
    {"title": "Guardian", "icon": Icons.security},
    {"title": "Hero", "icon": Icons.shield},
    {"title": "Legend", "icon": Icons.military_tech},
  ];

  VolunteerAchievementsScreen({super.key, required this.earnedAchievements});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(title: const Text('Achievements'), backgroundColor: Colors.transparent),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.1,
        ),
        itemCount: allAchievements.length,
        itemBuilder: (context, index) {
          final item = allAchievements[index];
          final isUnlocked = earnedAchievements.contains(item['title']);
          
          return Container(
            decoration: BoxDecoration(
              color: isUnlocked ? const Color(0xFF12192A) : Colors.black26,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isUnlocked ? AppColors.accentBlue : Colors.white10, width: 2),
            ),
            child: Opacity(
              opacity: isUnlocked ? 1.0 : 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], color: isUnlocked ? AppColors.accentOrange : Colors.white54, size: 40),
                  const SizedBox(height: 8),
                  Text(item['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  if (!isUnlocked) const Icon(Icons.lock, color: Colors.white54, size: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}