# Changelog

Все значимые изменения в проекте фиксируются в этом файле.  
Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/).

---

## [Unreleased]

---

## [1.0.0] — 2026-05-25

### Добавлено

**Приложение**
- Инициализирован Flutter-проект `flutter_lab_5` с поддержкой Android
- Реализованы две вкладки через `BottomNavigationBar` + `IndexedStack`:
  - **События** — GridView(crossAxisCount: 2) с карточками событий, поиск в реальном времени, фильтрация по категориям через ChoiceChip, строка счётчика событий, FAB для добавления
  - **Статистика** — 5 карточек с CircularProgressIndicator по каждой из 5 категорий, общая карточка с итоговым числом событий

**Level 1 — Базовый уровень**
- `GridView.count(crossAxisCount: 2)` с карточками событий (GlassCard + Dismissible)
- 5 категорий: Учёба📚, Спорт🏃, Развлечения🎉, Работа💼, Личное🌟
- 8 начальных событий, охватывающих все категории
- Фильтрация через `ChoiceChip` (горизонтальный скролл)
- Строка "N событий" / "N из M событий" с правильными падежами
- FAB → `showModalBottomSheet` с формой: TextField(название), DropdownButtonFormField(категория), DatePicker, TimePicker, TextField(место), TextField(описание), TextField(участники)
- Экран деталей: банер с цветом категории, карточка с метаданными, `ExpansionTile` для описания и участников
- Свайп влево (Dismissible) для удаления события + SnackBar с кнопкой «Отменить»

**Level 2 — Средний уровень**
- Task 1: редактирование события через кнопку в AppBar экрана деталей → `AddEventSheet` в режиме редактирования с предзаполненными полями
- Task 2: строка поиска с clear-кнопкой над сеткой + `PopupMenuButton` с тремя вариантами сортировки (по дате / по названию / по категории), активный вариант подсвечивается акцентным цветом

**Level 3 — Продвинутый уровень**
- Вкладка «Статистика» с `CircularProgressIndicator` для каждой категории: кольцо отображает долю событий данной категории в процентах от общего числа, центр кольца показывает количество и процент
- Пустое состояние с иконкой при отсутствии событий

**Дизайн-система (EAM → Flutter)**
- `AppColors` — все токены EAM: тёмный фон `#080A11`, акцент `#50C8FF`, светлый фон `#F4F7FF`, акцент light `#173EAC`, семантические цвета (success, warning, danger)
- `AppTheme` — `ThemeData.dark()` и `ThemeData.light()` с полным набором: `ColorScheme`, `TextTheme` (Nunito), `AppBarTheme`, `BottomNavigationBarTheme`, `CardTheme`, `ChipTheme`, `SwitchTheme`, `SliderTheme`, `ProgressIndicatorTheme`, `SnackBarTheme`, `ElevatedButtonTheme`, `OutlinedButtonTheme`, `FloatingActionButtonTheme`, `DialogTheme`
- `GlassCard` — glassmorphism-виджет: `BackdropFilter` + blur(12) в тёмной теме, plain card с тенью в светлой
- Шрифт **Nunito** через `google_fonts`

**State Management**
- `ThemeNotifier extends ValueNotifier<ThemeMode>` — переключение + сохранение в `SharedPreferences`
- `EventsNotifier extends ValueNotifier<EventsState>` — все операции с событиями:
  - `addEvent`, `updateEvent`, `deleteEvent`, `undoDelete` (один уровень отмены)
  - `setSelectedCategory`, `setSearch`, `setSort`
- `EventsState` — иммутабельное состояние с computed properties:
  - `filteredEvents` — применяет фильтр категории → поиск → сортировку
  - `countByCategory` — подсчёт по всем событиям (не по отфильтрованным)
  - `isFiltered`, `totalCount`, `filteredCount`
- Сортировка: `EventSort.byDate` (по дате + времени), `byTitle` (алфавитно), `byCategory` (по метке категории)
- `EventsState.copyWith` с `_sentinel`-паттерном для корректной обработки `null` в `selectedCategoryId`

**CI/CD**
- `.github/workflows/release.yml` — автосборка подписанного release APK при пуше в `main`
- Добавлен шаг `dart run flutter_launcher_icons` для генерации кастомной иконки
- Добавлен шаг патча метки приложения → `EventHub`
- APK подписывается keystore из GitHub Secret `KEYSTORE_BASE64`
- Каждая сборка создаёт GitHub Release с тегом `v1.0.{run_number}`
- Стабильный URL: `.../releases/latest/download/app-release.apk`

**Android**
- `android/app/build.gradle` с signing config через `key.properties` (Groovy DSL)
- `android/gradle.properties` с JVM-параметрами для Gradle
- `AndroidManifest.xml` с `INTERNET` permission и `queries` для `url_launcher`
- Namespace: `com.example.flutter_lab_5`

**Страница «О приложении»**
- Открывается через иконку `info_outline_rounded` в AppBar
- Карточки: заголовок, описание, стек технологий, список 22 использованных виджетов, ссылка на GitHub

**Тесты**
- `test/models/event_state_test.dart` — 15 unit-тестов для `EventsState` (фильтрация, поиск, сортировка, copyWith, countByCategory)
- `test/data/events_notifier_test.dart` — 14 unit-тестов для `EventsNotifier` (CRUD, undo, фильтры, иммутабельность)
- `test/widget_test.dart` — 13 widget smoke-тестов (вкладки, FAB, иконки AppBar, переключение темы, BottomSheet)

**Документация**
- `README.md` — описание проекта, APK badge, таблица уровней, архитектура, инструкции по настройке CI
- `CHANGELOG.md` — этот файл
- `SKILL.md` — контекст для AI в будущих итерациях

### Зависимости

```yaml
google_fonts: ^6.2.1
shared_preferences: ^2.2.3
url_launcher: ^6.3.0
cupertino_icons: ^1.0.8
flutter_launcher_icons: ^0.13.1  (dev)
flutter_lints: ^4.0.0            (dev)
```

---

[Unreleased]: https://github.com/xx-arteeem-xx/flutter-lab-5/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/xx-arteeem-xx/flutter-lab-5/releases/tag/v1.0.0
