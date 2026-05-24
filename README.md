# EventHub — Flutter Event Planning App

[![Build & Release APK](https://github.com/xx-arteeem-xx/flutter-lab-5/actions/workflows/release.yml/badge.svg)](https://github.com/xx-arteeem-xx/flutter-lab-5/actions/workflows/release.yml)
[![Download APK](https://img.shields.io/badge/Download-APK-50C8FF?logo=android)](https://github.com/xx-arteeem-xx/flutter-lab-5/releases/latest/download/app-release.apk)
[![Flutter](https://img.shields.io/badge/Flutter-3.24-54C5F8?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Unlicense-green)](LICENSE)

Лабораторная работа №5 по предмету «Разработка мобильных приложений» — Фирсов Артём, ИС-302, НГУЭУ.

Приложение-планировщик событий: список дел с категориями, фильтрацией, поиском, добавлением и редактированием через BottomSheet, детальной страницей с ExpansionTile и статистикой по категориям. Уровень 3 (продвинутый) выполнен полностью.

---

## О приложении

**EventHub** помогает студентам и активным людям планировать события: лекции, тренировки, встречи и личные дела в одном каталоге.

### Функциональность

| Уровень | Описание |
|---|---|
| **Базовый** | GridView (2 колонки) с карточками событий, фильтрация по категориям через ChoiceChip, FAB → BottomSheet-форма (TextField, DropdownButton, DatePicker, TimePicker), экран деталей с ExpansionTile, свайп для удаления с undo через SnackBar, строка счётчика событий |
| **Средний (Task 1)** | Редактирование события: кнопка в AppBar экрана деталей открывает BottomSheet с предзаполненными полями. Удаление события: кнопка корзины в AppBar экрана деталей с диалогом подтверждения и SnackBar-undo |
| **Средний (Task 2)** | Поиск по названию / описанию / месту в реальном времени + сортировка (по дате / названию / категории) через PopupMenuButton |
| **Продвинутый (Task 3)** | Вкладка «Статистика»: CircularProgressIndicator для каждой категории, показывающий долю событий в процентах |

### Вкладки

- **События** — GridView с 2 колонками, поиск, ChoiceChips для фильтрации по категории (Учёба📚, Спорт🏃, Развлечения🎉, Работа💼, Личное🌟), строка "N событий", FAB для добавления.
- **Статистика** — 5 карточек с CircularProgressIndicator по каждой категории: количество и процент от общего числа событий.

---

## Дизайн

Приложение реализует **EAM Design System** — единую дизайн-систему всей серии лабораторных работ.

| Токен | Тёмная тема | Светлая тема |
|---|---|---|
| Фон | `#080A11` | `#F4F7FF` |
| Поверхность | `#0E121F` | `#FFFFFF` |
| Акцент | `#50C8FF` | `#173EAC` |
| Текст (тело) | `#EFF3FF` | `#4F607F` |
| Заголовок | `#F7F9FF` | `#253654` |
| Шрифт | Nunito (Google Fonts) | — |

- **GlassCard** в тёмной теме: `BackdropFilter` + blur(12), translucent overlay
- **GlassCard** в светлой теме: белая карточка с тенью и рамкой

---

## Технологии

| Технология | Версия |
|---|---|
| Dart | 3.3+ |
| Flutter | 3.24 |
| google_fonts | 6.2.1 |
| shared_preferences | 2.2.3 |
| url_launcher | 6.3.0 |
| flutter_launcher_icons | 0.13.1 (dev) |
| flutter_lints | 4.0.0 (dev) |

### Архитектура

```
lib/
├── main.dart                  # async main → SharedPreferences → runApp
├── app.dart                   # App (MaterialApp) + _MainScaffold (2 tabs + FAB + sort)
├── core/
│   ├── constants/             # AppColors, AppStrings
│   └── theme/                 # AppTheme (dark/light), ThemeNotifier
├── models/                    # EventCategory (+ kCategories), Event (+ formatDate/formatTime)
├── data/                      # EventsState (immutable + computed), EventsNotifier, initialEvents
├── widgets/                   # GlassCard, ThemeToggleButton
└── features/
    ├── events/                # EventsTab (search + chips + grid), EventCard (Dismissible), AddEventSheet
    ├── event_detail/          # EventDetailScreen (ExpansionTile, edit button)
    ├── statistics/            # StatisticsTab (CircularProgressIndicator per category)
    └── about/                 # AboutScreen
```

**State management:** `EventsNotifier extends ValueNotifier<EventsState>` — единый нотификатор для всех событий. `ThemeNotifier extends ValueNotifier<ThemeMode>` + SharedPreferences.

---

## Установка

### Скачать APK

[Последний релиз](https://github.com/xx-arteeem-xx/flutter-lab-5/releases/latest/download/app-release.apk) собирается автоматически при каждом пуше в `main`.

### Собрать локально

```bash
# 1. Клонировать репозиторий
git clone https://github.com/xx-arteeem-xx/flutter-lab-5.git
cd flutter-lab-5

# 2. Сгенерировать Android boilerplate
flutter create . --platforms android --project-name flutter_lab_5

# 3. Установить зависимости
flutter pub get

# 4. Сгенерировать иконки
dart run flutter_launcher_icons

# 5. Запустить приложение
flutter run

# 6. Запустить тесты
flutter test

# 7. Собрать debug APK
flutter build apk --debug
```

---

## CI/CD

Автоматическая сборка и публикация через **GitHub Actions** при пуше в ветку `main`.

### Шаги pipeline

1. Checkout репозитория
2. Setup JDK 17 (Gradle 8.6 / AGP 8.3)
3. Setup Flutter (stable channel)
4. `flutter create . --platforms android` — генерация бинарных файлов
5. Patch app label → `EventHub`
6. Decode keystore из секрета `KEYSTORE_BASE64`
7. Создание `key.properties` из секретов
8. `flutter pub get`
9. `dart run flutter_launcher_icons` — кастомная иконка
10. `flutter analyze --no-fatal-infos`
11. `flutter test`
12. `flutter build apk --release`
13. Создание GitHub Release с тегом `v1.0.{run_number}`

### Настройка GitHub Secrets

Для работы CI/CD необходимо добавить секреты в **Settings → Secrets and variables → Actions**:

| Secret | Описание |
|---|---|
| `KEYSTORE_BASE64` | Base64-encoded `keystore.jks` |
| `KEY_STORE_PASSWORD` | Пароль хранилища ключей |
| `KEY_PASSWORD` | Пароль ключа |
| `KEY_ALIAS` | Псевдоним ключа (обычно `upload`) |

Для генерации keystore:
```bash
keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
# Получить base64:
base64 -i keystore.jks | pbcopy   # macOS
certutil -encode keystore.jks tmp.b64 && findstr /v /c:- tmp.b64 > keystore.b64  # Windows
```

---

## Автор

**Фирсов Артём Алексеевич** — НГУЭУ, ИС-302, 2026
