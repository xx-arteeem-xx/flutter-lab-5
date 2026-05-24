import '../models/event.dart';
import '../models/event_category.dart';

enum EventSort { byDate, byTitle, byCategory }

class EventsState {
  final List<Event> events;
  final String? selectedCategoryId;
  final String searchQuery;
  final EventSort sort;

  const EventsState({
    required this.events,
    this.selectedCategoryId,
    this.searchQuery = '',
    this.sort = EventSort.byDate,
  });

  factory EventsState.initial() => const EventsState(events: []);

  static const Object _sentinel = Object();

  EventsState copyWith({
    List<Event>? events,
    Object? selectedCategoryId = _sentinel,
    String? searchQuery,
    EventSort? sort,
  }) {
    return EventsState(
      events: events ?? this.events,
      selectedCategoryId: identical(selectedCategoryId, _sentinel)
          ? this.selectedCategoryId
          : selectedCategoryId as String?,
      searchQuery: searchQuery ?? this.searchQuery,
      sort: sort ?? this.sort,
    );
  }

  List<Event> get filteredEvents {
    var result = List<Event>.from(events);

    if (selectedCategoryId != null) {
      result = result.where((e) => e.categoryId == selectedCategoryId).toList();
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((e) {
        return e.title.toLowerCase().contains(q) ||
            e.description.toLowerCase().contains(q) ||
            e.location.toLowerCase().contains(q);
      }).toList();
    }

    switch (sort) {
      case EventSort.byDate:
        result.sort((a, b) {
          final dateCmp = a.date.compareTo(b.date);
          if (dateCmp != 0) return dateCmp;
          final aMin = a.time.hour * 60 + a.time.minute;
          final bMin = b.time.hour * 60 + b.time.minute;
          return aMin.compareTo(bMin);
        });
      case EventSort.byTitle:
        result.sort((a, b) => a.title.compareTo(b.title));
      case EventSort.byCategory:
        result.sort((a, b) {
          final catA = categoryById(a.categoryId).label;
          final catB = categoryById(b.categoryId).label;
          return catA.compareTo(catB);
        });
    }

    return result;
  }

  bool get isFiltered =>
      selectedCategoryId != null || searchQuery.isNotEmpty;

  int get totalCount => events.length;
  int get filteredCount => filteredEvents.length;

  Map<String, int> get countByCategory {
    final map = <String, int>{};
    for (final cat in kCategories) {
      map[cat.id] = 0;
    }
    for (final e in events) {
      map[e.categoryId] = (map[e.categoryId] ?? 0) + 1;
    }
    return map;
  }
}
