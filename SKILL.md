# SKILL.md — AI Context for Future Sessions

## Project Summary

Flutter app: EventHub — Event Planning App (Lab 5). 2-tab layout (Events + Statistics) with EAM glassmorphism design.

## Design Tokens

| Token | Dark | Light |
|---|---|---|
| Background | `#080A11` | `#F4F7FF` |
| Surface | `#0E121F` | `#FFFFFF` |
| Accent | `#50C8FF` | `#173EAC` |
| Body text | `#EFF3FF` | `#4F607F` |
| Heading | `#F7F9FF` | `#253654` |
| Border | `rgba(125,151,199,0.18)` | `rgba(101,119,162,0.16)` |
| NavBar | `#0D1020` | `#FFFFFF` |
| Font | Nunito (Google Fonts) | same |

## Critical Files

| File | Purpose |
|---|---|
| `lib/core/constants/app_colors.dart` | All color constants |
| `lib/core/constants/app_strings.dart` | All strings, URLs |
| `lib/core/theme/app_theme.dart` | ThemeData dark + light |
| `lib/core/theme/theme_notifier.dart` | ValueNotifier<ThemeMode> + SharedPreferences |
| `lib/widgets/glass_card.dart` | Reusable glassmorphism card |
| `lib/app.dart` | App root + _MainScaffold (2 tabs + FAB + sort PopupMenu) |
| `lib/data/events_notifier.dart` | EventsNotifier — all state mutations + undo |
| `lib/data/events_state.dart` | EventsState — immutable state + computed filteredEvents |
| `lib/data/initial_events.dart` | 8 initial Event objects (getter, not const — TimeOfDay not const) |
| `lib/models/event_category.dart` | EventCategory + kCategories (5 items) + categoryById() |
| `lib/models/event.dart` | Event + copyWith + formatDate/formatTime helpers |
| `lib/features/events/events_tab.dart` | EventsTab (StatefulWidget — owns TextEditingController) |
| `lib/features/events/add_event_sheet.dart` | AddEventSheet — add + edit mode (initial param) |
| `lib/features/event_detail/event_detail_screen.dart` | Detail view — ValueListenableBuilder for live updates |
| `lib/features/statistics/statistics_tab.dart` | CircularProgressIndicator per category |
| `android/app/build.gradle` | Signing config via key.properties |
| `.github/workflows/release.yml` | CI: flutter create → icons → sign → build → release |

## State Architecture

```
EventsNotifier (ValueNotifier<EventsState>)
  └─ EventsState (immutable)
      ├─ List<Event> events
      ├─ String? selectedCategoryId
      ├─ String searchQuery
      ├─ EventSort sort  (byDate | byTitle | byCategory)
      └─ computed: filteredEvents, countByCategory, isFiltered

ThemeNotifier (ValueNotifier<ThemeMode>)
  └─ persisted in SharedPreferences key 'themeMode'
```

## Key Patterns

**Theme switching:** `ValueListenableBuilder<ThemeMode>` wraps `MaterialApp`.

**State mutations:** always `value = value.copyWith(...)` — never mutate fields.

**copyWith with nullable selectedCategoryId:** uses `_sentinel = Object()` pattern — passing `null` explicitly clears the filter, omitting the param preserves existing value.

**filteredEvents order:** category filter → search (title + description + location) → sort.

**Sort active indicator:** PopupMenuButton checks `state.sort == EventSort.byX` to bold + color the active item.

**AddEventSheet modes:** `initial == null` → add new event; `initial != null` → edit mode (pre-fill fields, call updateEvent on submit). Static `show()` method for convenience.

**EventDetailScreen freshness:** receives `eventId` + `eventsNotifier`, finds event via `state.events.where().firstOrNull`. If null (deleted while open) → `addPostFrameCallback` → `Navigator.pop`.

**Undo delete:** single-level undo via `_lastDeleted` + `_lastDeletedIndex` in EventsNotifier. SnackBar action calls `notifier.undoDelete()`.

**Statistics:** counts from `EventsState.countByCategory` — uses ALL events (not filtered). `CircularProgressIndicator(value: count/total)` with Stack + centered Text overlay.

**EventsTab:** StatefulWidget to own `TextEditingController` for search. `ValueListenableBuilder` for the rest.

**ID generation:** `DateTime.now().microsecondsSinceEpoch.toString()` — no uuid package.

**GlassCard:** `isDark → BackdropFilter blur(12,12) + darkGlass + darkBorder` / `isLight → white + lightBorder + boxShadow`.

**initialEvents:** getter not const (TimeOfDay is not const-constructible).

## Android Config

- namespace: `com.example.flutter_lab_5`
- minSdk: `flutter.minSdkVersion` (21)
- compileSdk: `flutter.compileSdkVersion`
- Signing: `key.properties` → `signingConfigs.release` in `buildTypes.release`

## CI/CD

- Trigger: push to `main`
- Steps: checkout → JDK17 → Flutter stable → `flutter create . --platforms android --project-name flutter_lab_5` → delete `build.gradle.kts` → patch label to `EventHub` → gradlew chmod → keystore decode → key.properties → pub get → `dart run flutter_launcher_icons` → analyze → test → build apk → GitHub Release
- Secrets: `KEYSTORE_BASE64`, `KEY_STORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`
- Stable URL: `releases/latest/download/app-release.apk`

## Categories

| id | label | emoji | color |
|---|---|---|---|
| study | Учёба | 📚 | `#4A90D9` |
| sport | Спорт | 🏃 | `#4FB84E` |
| fun | Развлечения | 🎉 | `#AB47BC` |
| work | Работа | 💼 | `#F58345` |
| personal | Личное | 🌟 | `#E91E8C` |
