class AppStrings {
  AppStrings._();

  static const String appName = 'EventHub';
  static const String appVersion = '1.0.0';

  static const String repoUrl = 'https://github.com/xx-arteeem-xx/flutter-lab-5';
  static const String repoShort = 'github.com/xx-arteeem-xx/flutter-lab-5';

  // ── Navigation tabs ───────────────────────────────────────────────────────
  static const String tabEvents = 'События';
  static const String tabStatistics = 'Статистика';

  // ── About ─────────────────────────────────────────────────────────────────
  static const String aboutTitle = 'О приложении';

  // ── Events tab ────────────────────────────────────────────────────────────
  static const String searchHint = 'Поиск событий...';
  static const String allCategories = 'Все';
  static const String noEvents = 'Нет событий';
  static const String noEventsDesc = 'Добавьте первое событие, нажав +';
  static const String noEventsFilter = 'Нет событий по фильтру';
  static const String noEventsFilterDesc = 'Попробуйте изменить категорию или поисковый запрос';

  // ── Sort ─────────────────────────────────────────────────────────────────
  static const String sortBy = 'Сортировка';
  static const String sortByDate = 'По дате';
  static const String sortByTitle = 'По названию';
  static const String sortByCategory = 'По категории';

  // ── Add / Edit event form ─────────────────────────────────────────────────
  static const String addEvent = 'Новое событие';
  static const String editEvent = 'Редактировать событие';
  static const String eventTitle = 'Название';
  static const String eventTitleHint = 'Например: Лекция по Flutter';
  static const String eventCategory = 'Категория';
  static const String eventDate = 'Дата';
  static const String eventTime = 'Время';
  static const String eventLocation = 'Место проведения (необязательно)';
  static const String eventLocationHint = 'Например: ауд. 305';
  static const String eventDescription = 'Описание (необязательно)';
  static const String eventDescriptionHint = 'Краткое описание события';
  static const String eventParticipants = 'Участники (через запятую, необязательно)';
  static const String eventParticipantsHint = 'Иван, Мария, Алексей';
  static const String save = 'Сохранить';
  static const String add = 'Добавить';
  static const String cancel = 'Отмена';
  static const String titleRequired = 'Название не может быть пустым';

  // ── Event detail ──────────────────────────────────────────────────────────
  static const String descriptionSection = 'Описание';
  static const String participantsSection = 'Участники';
  static const String noDescription = 'Описание не указано';
  static const String noParticipants = 'Участники не указаны';
  static const String noLocation = 'Место не указано';
  static const String deleteEvent = 'Удалить';
  static const String deleteEventDialogTitle = 'Удалить событие?';

  // ── Snackbar ─────────────────────────────────────────────────────────────
  static const String eventDeleted = 'Событие удалено';
  static const String undo = 'Отменить';

  // ── Statistics ────────────────────────────────────────────────────────────
  static const String statisticsTitle = 'Статистика';
  static const String statisticsEmpty = 'Нет событий для анализа';
  static const String statisticsEmptyDesc = 'Добавьте события, чтобы увидеть статистику';
  static const String totalEvents = 'Всего событий';
}
