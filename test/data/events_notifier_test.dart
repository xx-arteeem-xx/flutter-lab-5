import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab_5/data/events_notifier.dart';
import 'package:flutter_lab_5/data/events_state.dart';
import 'package:flutter_lab_5/models/event.dart';

Event _makeEvent({
  String id = '99',
  String title = 'New Event',
  String categoryId = 'work',
}) {
  return Event(
    id: id,
    title: title,
    date: DateTime(2026, 7, 1),
    time: const TimeOfDay(hour: 12, minute: 0),
    categoryId: categoryId,
  );
}

void main() {
  late EventsNotifier notifier;

  setUp(() {
    notifier = EventsNotifier();
  });

  tearDown(() {
    notifier.dispose();
  });

  group('addEvent', () {
    test('appends event to the list', () {
      final initialCount = notifier.value.events.length;
      final event = _makeEvent(id: 'new1');
      notifier.addEvent(event);
      expect(notifier.value.events.length, initialCount + 1);
      expect(notifier.value.events.last.id, 'new1');
    });

    test('increments totalCount', () {
      final before = notifier.value.totalCount;
      notifier.addEvent(_makeEvent(id: 'new2'));
      expect(notifier.value.totalCount, before + 1);
    });
  });

  group('updateEvent', () {
    test('replaces event with same id', () {
      final original = notifier.value.events.first;
      final updated = original.copyWith(title: 'Updated Title');
      notifier.updateEvent(updated);
      final found = notifier.value.events.firstWhere((e) => e.id == original.id);
      expect(found.title, 'Updated Title');
    });

    test('does not change list length', () {
      final before = notifier.value.events.length;
      final original = notifier.value.events.first;
      notifier.updateEvent(original.copyWith(title: 'Changed'));
      expect(notifier.value.events.length, before);
    });
  });

  group('deleteEvent', () {
    test('removes event from list', () {
      final before = notifier.value.events.length;
      final id = notifier.value.events.first.id;
      notifier.deleteEvent(id);
      expect(notifier.value.events.length, before - 1);
      expect(notifier.value.events.any((e) => e.id == id), isFalse);
    });

    test('does nothing for unknown id', () {
      final before = notifier.value.events.length;
      notifier.deleteEvent('nonexistent');
      expect(notifier.value.events.length, before);
    });
  });

  group('undoDelete', () {
    test('re-inserts deleted event (length restored)', () {
      final before = notifier.value.events.length;
      final id = notifier.value.events.first.id;
      notifier.deleteEvent(id);
      notifier.undoDelete();
      expect(notifier.value.events.length, before);
    });

    test('re-inserts at original index', () {
      final events = notifier.value.events;
      final targetIdx = 1.clamp(0, events.length - 1);
      final targetId = events[targetIdx].id;
      notifier.deleteEvent(targetId);
      notifier.undoDelete();
      expect(notifier.value.events[targetIdx].id, targetId);
    });

    test('undo after second delete has only one undo level', () {
      final id1 = notifier.value.events[0].id;
      final id2 = notifier.value.events[1].id;
      notifier.deleteEvent(id1);
      notifier.deleteEvent(id2);
      notifier.undoDelete();
      // Only id2 is restored
      expect(notifier.value.events.any((e) => e.id == id2), isTrue);
      expect(notifier.value.events.any((e) => e.id == id1), isFalse);
    });

    test('undo when nothing was deleted does nothing', () {
      final before = notifier.value.events.length;
      notifier.undoDelete();
      expect(notifier.value.events.length, before);
    });
  });

  group('setSelectedCategory', () {
    test('sets selectedCategoryId', () {
      notifier.setSelectedCategory('study');
      expect(notifier.value.selectedCategoryId, 'study');
    });

    test('setSelectedCategory(null) clears filter', () {
      notifier.setSelectedCategory('study');
      notifier.setSelectedCategory(null);
      expect(notifier.value.selectedCategoryId, isNull);
    });
  });

  group('setSearch', () {
    test('updates searchQuery', () {
      notifier.setSearch('flutter');
      expect(notifier.value.searchQuery, 'flutter');
    });

    test('empty string clears search', () {
      notifier.setSearch('flutter');
      notifier.setSearch('');
      expect(notifier.value.searchQuery, '');
    });
  });

  group('setSort', () {
    test('updates sort to byTitle', () {
      notifier.setSort(EventSort.byTitle);
      expect(notifier.value.sort, EventSort.byTitle);
    });

    test('updates sort to byCategory', () {
      notifier.setSort(EventSort.byCategory);
      expect(notifier.value.sort, EventSort.byCategory);
    });

    test('updates sort back to byDate', () {
      notifier.setSort(EventSort.byTitle);
      notifier.setSort(EventSort.byDate);
      expect(notifier.value.sort, EventSort.byDate);
    });
  });

  group('immutability', () {
    test('state mutations do not modify previous state object', () {
      final before = notifier.value;
      notifier.addEvent(_makeEvent(id: 'x'));
      expect(notifier.value, isNot(same(before)));
      expect(before.events.any((e) => e.id == 'x'), isFalse);
    });
  });
}
