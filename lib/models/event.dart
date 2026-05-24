import 'package:flutter/material.dart';

const _months = [
  'янв', 'фев', 'мар', 'апр', 'май', 'июн',
  'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
];

String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String formatTime(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String categoryId;
  final String location;
  final List<String> participants;

  const Event({
    required this.id,
    required this.title,
    this.description = '',
    required this.date,
    required this.time,
    required this.categoryId,
    this.location = '',
    this.participants = const [],
  });

  Event copyWith({
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    String? categoryId,
    String? location,
    List<String>? participants,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      categoryId: categoryId ?? this.categoryId,
      location: location ?? this.location,
      participants: participants ?? this.participants,
    );
  }

  String get formattedDate => formatDate(date);
  String get formattedTime => formatTime(time);
}
