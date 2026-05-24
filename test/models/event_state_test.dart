import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab_5/data/events_state.dart';
import 'package:flutter_lab_5/models/event.dart';

Event _makeEvent({
  String id = '1',
  String title = 'Test Event',
  String categoryId = 'study',
  DateTime? date,
  TimeOfDay time = const TimeOfDay(hour: 10, minute: 0),
  String description = '',
  String location = '',
}) {
  return Event(
    id: id,
    title: title,
    date: date ?? DateTime(2026, 6, 1),
    time: time,
    categoryId: categoryId,
    description: description,
    location: location,
  );
}

void main() {
  group('EventsState initial', () {
    test('initial has empty events and default values', () {
      final state = EventsState.initial();
      expect(state.events, isEmpty);
      expect(state.selectedCategoryId, isNull);
      expect(state.searchQuery, '');
      expect(state.sort, EventSort.byDate);
    });
  });

  group('EventsState.filteredEvents', () {
    late EventsState state;

    setUp(() {
      state = EventsState(events: [
        _makeEvent(id: '1', title: 'Flutter Lecture', categoryId: 'study', date: DateTime(2026, 6, 3)),
        _makeEvent(id: '2', title: 'Morning Run', categoryId: 'sport', date: DateTime(2026, 6, 1)),
        _makeEvent(id: '3', title: 'Concert', categoryId: 'fun', date: DateTime(2026, 6, 5)),
        _makeEvent(id: '4', title: 'Work Meeting', categoryId: 'work', date: DateTime(2026, 6, 2)),
        _makeEvent(id: '5', title: 'Birthday Party', categoryId: 'personal', date: DateTime(2026, 6, 4)),
      ]);
    });

    test('returns all events when no filter and no search', () {
      expect(state.filteredEvents.length, 5);
    });

    test('filters by categoryId', () {
      final filtered = state.copyWith(selectedCategoryId: 'study').filteredEvents;
      expect(filtered.length, 1);
      expect(filtered.first.categoryId, 'study');
    });

    test('filter by nonexistent category returns empty', () {
      final filtered = state.copyWith(selectedCategoryId: 'personal').filteredEvents;
      expect(filtered.length, 1);
      expect(filtered.first.id, '5');
    });

    test('filters by searchQuery (case-insensitive, title)', () {
      final filtered = state.copyWith(searchQuery: 'run').filteredEvents;
      expect(filtered.length, 1);
      expect(filtered.first.title, 'Morning Run');
    });

    test('filters by searchQuery in location', () {
      final s = EventsState(events: [
        _makeEvent(id: '1', title: 'Event', categoryId: 'study', location: 'Аудитория 305'),
      ]);
      final filtered = s.copyWith(searchQuery: 'аудитория').filteredEvents;
      expect(filtered.length, 1);
    });

    test('combines category and search (AND logic)', () {
      final filtered = state
          .copyWith(selectedCategoryId: 'study', searchQuery: 'flutter')
          .filteredEvents;
      expect(filtered.length, 1);
      expect(filtered.first.id, '1');
    });

    test('combined filter returns empty when both constraints give no match', () {
      final filtered = state
          .copyWith(selectedCategoryId: 'sport', searchQuery: 'flutter')
          .filteredEvents;
      expect(filtered, isEmpty);
    });

    test('sorts by date ascending', () {
      final sorted = state.copyWith(sort: EventSort.byDate).filteredEvents;
      final dates = sorted.map((e) => e.date).toList();
      for (int i = 1; i < dates.length; i++) {
        expect(dates[i].isAfter(dates[i - 1]) || dates[i] == dates[i - 1], isTrue);
      }
    });

    test('sorts by title alphabetically', () {
      final sorted = state.copyWith(sort: EventSort.byTitle).filteredEvents;
      final titles = sorted.map((e) => e.title).toList();
      for (int i = 1; i < titles.length; i++) {
        expect(titles[i].compareTo(titles[i - 1]), greaterThanOrEqualTo(0));
      }
    });

    test('sorts by category label alphabetically', () {
      final sorted = state.copyWith(sort: EventSort.byCategory).filteredEvents;
      expect(sorted, isNotEmpty);
    });
  });

  group('EventsState computed properties', () {
    test('isFiltered is false with null category and empty search', () {
      final state = EventsState(events: []);
      expect(state.isFiltered, isFalse);
    });

    test('isFiltered is true when category is set', () {
      final state = EventsState(events: [], selectedCategoryId: 'study');
      expect(state.isFiltered, isTrue);
    });

    test('isFiltered is true when searchQuery is non-empty', () {
      final state = EventsState(events: [], searchQuery: 'test');
      expect(state.isFiltered, isTrue);
    });

    test('countByCategory returns count for all categories', () {
      final state = EventsState(events: [
        _makeEvent(id: '1', categoryId: 'study'),
        _makeEvent(id: '2', categoryId: 'study'),
        _makeEvent(id: '3', categoryId: 'sport'),
      ]);
      final counts = state.countByCategory;
      expect(counts['study'], 2);
      expect(counts['sport'], 1);
      expect(counts['fun'], 0);
      expect(counts['work'], 0);
      expect(counts['personal'], 0);
    });

    test('countByCategory counts ALL events (not filtered)', () {
      final state = EventsState(
        events: [
          _makeEvent(id: '1', categoryId: 'study'),
          _makeEvent(id: '2', categoryId: 'sport'),
        ],
        selectedCategoryId: 'study',
      );
      final counts = state.countByCategory;
      expect(counts['sport'], 1);
    });

    test('totalCount returns all events count', () {
      final state = EventsState(events: [
        _makeEvent(id: '1'),
        _makeEvent(id: '2'),
        _makeEvent(id: '3'),
      ]);
      expect(state.totalCount, 3);
    });
  });

  group('EventsState.copyWith', () {
    test('copyWith preserves unchanged fields', () {
      final state = EventsState(
        events: [_makeEvent()],
        selectedCategoryId: 'study',
        searchQuery: 'test',
        sort: EventSort.byTitle,
      );
      final copy = state.copyWith();
      expect(copy.events.length, 1);
      expect(copy.selectedCategoryId, 'study');
      expect(copy.searchQuery, 'test');
      expect(copy.sort, EventSort.byTitle);
    });

    test('copyWith with null selectedCategoryId clears it', () {
      final state = EventsState(events: [], selectedCategoryId: 'study');
      final copy = state.copyWith(selectedCategoryId: null);
      expect(copy.selectedCategoryId, isNull);
    });

    test('copyWith without selectedCategoryId keeps existing value', () {
      final state = EventsState(events: [], selectedCategoryId: 'study');
      final copy = state.copyWith(searchQuery: 'new');
      expect(copy.selectedCategoryId, 'study');
    });
  });
}
