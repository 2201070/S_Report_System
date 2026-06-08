import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final List<Color> gradientColors;
  final String pattern;
  final String intensity;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.gradientColors,
    required this.pattern,
    required this.intensity,
  });

  static const List<CategoryModel> dummyCategories = [
    CategoryModel(
      id: 'accident',
      name: 'Accident',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFFF9500),
      description: 'Traffic accidents, collisions',
      gradientColors: [Color(0x33FF9500), Color(0x1AFFC107), Colors.transparent],
      pattern: 'diagonal-lines',
      intensity: 'high',
    ),
    CategoryModel(
      id: 'fire',
      name: 'Fire',
      icon: Icons.local_fire_department_outlined,
      color: Color(0xFFFF3B30),
      description: 'Fire, smoke, or burning',
      gradientColors: [Color(0x4DFF3B30), Color(0x26FF9500), Colors.transparent],
      pattern: 'flames',
      intensity: 'high',
    ),
    CategoryModel(
      id: 'environmental',
      name: 'Environmental',
      icon: Icons.eco_outlined,
      color: Color(0xFF34C759),
      description: 'Waste, pollution, nature',
      gradientColors: [Color(0x3334C759), Color(0x1A10B981), Colors.transparent],
      pattern: 'leaves',
      intensity: 'low',
    ),
    CategoryModel(
      id: 'health',
      name: 'Health / Sanitation',
      icon: Icons.add_circle_outline,
      color: Color(0xFF00BCD4),
      description: 'Healthcare, cleanliness',
      gradientColors: [Color(0x3300BCD4), Color(0x1A009688), Colors.transparent],
      pattern: 'medical',
      intensity: 'low',
    ),
    CategoryModel(
      id: 'other',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFF8E8E93),
      description: 'General or unspecified',
      gradientColors: [Color(0x269E9E9E), Color(0x14757575), Colors.transparent],
      pattern: 'abstract',
      intensity: 'low',
    ),
  ];
}
