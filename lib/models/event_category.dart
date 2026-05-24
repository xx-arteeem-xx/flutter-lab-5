import 'package:flutter/material.dart';

class EventCategory {
  final String id;
  final String label;
  final String emoji;
  final IconData icon;
  final Color color;

  const EventCategory({
    required this.id,
    required this.label,
    required this.emoji,
    required this.icon,
    required this.color,
  });
}

const List<EventCategory> kCategories = [
  EventCategory(
    id: 'study',
    label: 'Учёба',
    emoji: '📚',
    icon: Icons.school_rounded,
    color: Color(0xFF4A90D9),
  ),
  EventCategory(
    id: 'sport',
    label: 'Спорт',
    emoji: '🏃',
    icon: Icons.directions_run_rounded,
    color: Color(0xFF4FB84E),
  ),
  EventCategory(
    id: 'fun',
    label: 'Развлечения',
    emoji: '🎉',
    icon: Icons.celebration_rounded,
    color: Color(0xFFAB47BC),
  ),
  EventCategory(
    id: 'work',
    label: 'Работа',
    emoji: '💼',
    icon: Icons.work_rounded,
    color: Color(0xFFF58345),
  ),
  EventCategory(
    id: 'personal',
    label: 'Личное',
    emoji: '🌟',
    icon: Icons.star_rounded,
    color: Color(0xFFE91E8C),
  ),
];

EventCategory categoryById(String id) =>
    kCategories.firstWhere((c) => c.id == id);
