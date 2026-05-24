import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'data/events_notifier.dart';
import 'data/events_state.dart';
import 'features/about/about_screen.dart';
import 'features/events/add_event_sheet.dart';
import 'features/events/events_tab.dart';
import 'features/statistics/statistics_tab.dart';
import 'widgets/theme_toggle_button.dart';

class App extends StatefulWidget {
  final SharedPreferences prefs;

  const App({super.key, required this.prefs});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ThemeNotifier _themeNotifier;
  final EventsNotifier _eventsNotifier = EventsNotifier();

  @override
  void initState() {
    super.initState();
    _themeNotifier = ThemeNotifier(widget.prefs);
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    _eventsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, mode, __) => MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: _MainScaffold(
          themeNotifier: _themeNotifier,
          eventsNotifier: _eventsNotifier,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MainScaffold extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final EventsNotifier eventsNotifier;

  const _MainScaffold({
    required this.themeNotifier,
    required this.eventsNotifier,
  });

  @override
  State<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<_MainScaffold> {
  int _tab = 0;

  static const _titles = <String>[
    AppStrings.tabEvents,
    AppStrings.tabStatistics,
  ];

  void _openAbout() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AboutScreen()),
    );
  }

  void _showAddEventSheet() {
    AddEventSheet.show(context, widget.eventsNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_tab]),
        actions: [
          if (_tab == 0)
            ValueListenableBuilder<EventsState>(
              valueListenable: widget.eventsNotifier,
              builder: (_, state, __) => PopupMenuButton<EventSort>(
                icon: const Icon(Icons.sort_rounded),
                tooltip: AppStrings.sortBy,
                onSelected: widget.eventsNotifier.setSort,
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: EventSort.byDate,
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: state.sort == EventSort.byDate
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.sortByDate,
                          style: state.sort == EventSort.byDate
                              ? TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: EventSort.byTitle,
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_by_alpha_rounded,
                          size: 16,
                          color: state.sort == EventSort.byTitle
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.sortByTitle,
                          style: state.sort == EventSort.byTitle
                              ? TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: EventSort.byCategory,
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: state.sort == EventSort.byCategory
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.sortByCategory,
                          style: state.sort == EventSort.byCategory
                              ? TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: AppStrings.aboutTitle,
            onPressed: _openAbout,
          ),
          ThemeToggleButton(notifier: widget.themeNotifier),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          EventsTab(notifier: widget.eventsNotifier),
          StatisticsTab(notifier: widget.eventsNotifier),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: _showAddEventSheet,
              tooltip: AppStrings.addEvent,
              child: const Icon(Icons.add_rounded),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event_rounded),
            label: AppStrings.tabEvents,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart_rounded),
            label: AppStrings.tabStatistics,
          ),
        ],
      ),
    );
  }
}
