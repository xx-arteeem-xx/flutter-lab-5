import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/events_notifier.dart';
import '../../data/events_state.dart';
import '../../models/event_category.dart';
import 'widgets/event_card.dart';

class EventsTab extends StatefulWidget {
  final EventsNotifier notifier;

  const EventsTab({super.key, required this.notifier});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EventsState>(
      valueListenable: widget.notifier,
      builder: (context, state, _) {
        final events = state.filteredEvents;

        return Column(
          children: [
            _SearchBar(
              controller: _searchCtrl,
              notifier: widget.notifier,
            ),
            _CategoryChips(state: state, notifier: widget.notifier),
            _StatsLine(state: state),
            Expanded(
              child: events.isEmpty
                  ? _EmptyState(isFiltered: state.isFiltered)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: events.length,
                      itemBuilder: (_, i) => EventCard(
                        event: events[i],
                        notifier: widget.notifier,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Search bar ──────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final EventsNotifier notifier;

  const _SearchBar({required this.controller, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: TextField(
        controller: controller,
        onChanged: notifier.setSearch,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: Icon(Icons.search_rounded, color: accent, size: 20),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              return value.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: Icon(Icons.clear_rounded, size: 18, color: accent),
                      onPressed: () {
                        controller.clear();
                        notifier.setSearch('');
                      },
                    );
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accent, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─── Category chips ──────────────────────────────────────────────────────────

class _CategoryChips extends StatelessWidget {
  final EventsState state;
  final EventsNotifier notifier;

  const _CategoryChips({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _Chip(
            label: AppStrings.allCategories,
            isSelected: state.selectedCategoryId == null,
            onSelected: () => notifier.setSelectedCategory(null),
          ),
          ...kCategories.map(
            (cat) => _Chip(
              label: '${cat.emoji} ${cat.label}',
              isSelected: state.selectedCategoryId == cat.id,
              onSelected: () => notifier.setSelectedCategory(cat.id),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

// ─── Stats line ──────────────────────────────────────────────────────────────

class _StatsLine extends StatelessWidget {
  final EventsState state;

  const _StatsLine({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = state.filteredCount;
    final total = state.totalCount;

    final text = state.isFiltered
        ? '$count из $total ${_eventWord(total)}'
        : '$total ${_eventWord(total)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: theme.textTheme.labelMedium),
      ),
    );
  }

  String _eventWord(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return 'событие';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
      return 'события';
    }
    return 'событий';
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isFiltered;

  const _EmptyState({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFiltered
                  ? Icons.search_off_rounded
                  : Icons.event_busy_rounded,
              size: 64,
              color: accent.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              isFiltered
                  ? AppStrings.noEventsFilter
                  : AppStrings.noEvents,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? AppStrings.noEventsFilterDesc
                  : AppStrings.noEventsDesc,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
