import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _usedWidgets = <String>[
    'Scaffold & AppBar',
    'BottomNavigationBar & IndexedStack',
    'Column / Row / ListView',
    'GridView.count (сетка событий)',
    'StatefulWidget & StatelessWidget',
    'ValueNotifier<ThemeMode> (переключение темы)',
    'ValueNotifier<EventsState> (состояние событий)',
    'SharedPreferences (персистентность темы)',
    'ChoiceChip & Wrap (фильтрация по категории)',
    'Dismissible (свайп для удаления)',
    'showModalBottomSheet (форма добавления/редактирования)',
    'DropdownButtonFormField (выбор категории)',
    'showDatePicker / showTimePicker',
    'ExpansionTile (описание и участники)',
    'CircularProgressIndicator (статистика по категориям)',
    'TextField (поиск, поля формы)',
    'PopupMenuButton (сортировка)',
    'SnackBar & ScaffoldMessenger (undo удаления)',
    'Navigator.push / pop',
    'BackdropFilter (glassmorphism)',
    'GestureDetector & InkWell',
    'FloatingActionButton',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          GlassCard(
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.event_rounded, color: accent, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.appName,
                        style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 2),
                    Text('Версия ${AppStrings.appVersion}',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Text(
              'Лабораторная работа №5 по предмету «Разработка мобильных приложений». '
              'Реализован 3-й (продвинутый) уровень задания: список событий с фильтрацией, '
              'добавление и редактирование через BottomSheet, статистика по категориям '
              'с CircularProgressIndicator, переключатель тёмной/светлой темы.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Стек технологий', style: theme.textTheme.titleMedium),
                const SizedBox(height: 14),
                _TechRow(
                    icon: Icons.code,
                    label: 'Язык',
                    value: 'Dart 3.3+',
                    accent: accent,
                    theme: theme),
                _TechRow(
                    icon: Icons.flutter_dash,
                    label: 'Фреймворк',
                    value: 'Flutter 3.24',
                    accent: accent,
                    theme: theme),
                _TechRow(
                    icon: Icons.palette_outlined,
                    label: 'Дизайн',
                    value: 'EAM Design System',
                    accent: accent,
                    theme: theme),
                _TechRow(
                    icon: Icons.text_fields,
                    label: 'Шрифт',
                    value: 'Nunito (Google Fonts)',
                    accent: accent,
                    theme: theme),
                _TechRow(
                    icon: Icons.sync_rounded,
                    label: 'CI/CD',
                    value: 'GitHub Actions',
                    accent: accent,
                    theme: theme),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Использованные виджеты',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 14),
                ..._usedWidgets.map(
                  (w) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 16, color: accent),
                        const SizedBox(width: 10),
                        Expanded(
                            child:
                                Text(w, style: theme.textTheme.bodyMedium)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            onTap: () => _launch(AppStrings.repoUrl),
            child: Row(
              children: [
                Icon(Icons.code_rounded, color: accent),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Исходный код на GitHub',
                          style: theme.textTheme.titleSmall),
                      Text(
                        AppStrings.repoShort,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.open_in_new_rounded,
                    size: 14, color: accent.withValues(alpha: 0.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _TechRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final ThemeData theme;

  const _TechRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodySmall),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
