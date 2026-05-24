import 'package:flutter/foundation.dart';
import '../models/event.dart';
import 'events_state.dart';
import 'initial_events.dart';

class EventsNotifier extends ValueNotifier<EventsState> {
  Event? _lastDeleted;
  int? _lastDeletedIndex;

  EventsNotifier() : super(EventsState(events: initialEvents));

  void addEvent(Event event) {
    value = value.copyWith(events: [...value.events, event]);
  }

  void updateEvent(Event updated) {
    final events = value.events.map((e) {
      return e.id == updated.id ? updated : e;
    }).toList();
    value = value.copyWith(events: events);
  }

  void deleteEvent(String id) {
    final idx = value.events.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    _lastDeleted = value.events[idx];
    _lastDeletedIndex = idx;
    final events = List<Event>.from(value.events)..removeAt(idx);
    value = value.copyWith(events: events);
  }

  void undoDelete() {
    if (_lastDeleted == null || _lastDeletedIndex == null) return;
    final events = List<Event>.from(value.events);
    final insertIdx = _lastDeletedIndex!.clamp(0, events.length);
    events.insert(insertIdx, _lastDeleted!);
    value = value.copyWith(events: events);
    _lastDeleted = null;
    _lastDeletedIndex = null;
  }

  void setSelectedCategory(String? categoryId) {
    value = value.copyWith(selectedCategoryId: categoryId);
  }

  void setSearch(String query) {
    value = value.copyWith(searchQuery: query);
  }

  void setSort(EventSort sort) {
    value = value.copyWith(sort: sort);
  }

  String newId() => DateTime.now().microsecondsSinceEpoch.toString();
}
