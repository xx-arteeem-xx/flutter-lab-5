import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/events_notifier.dart';
import '../../data/events_state.dart';
import '../../models/event.dart';
import '../../models/event_category.dart';
import '../../widgets/glass_card.dart';
import '../events/add_event_sheet.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  final EventsNotifier eventsNotifier;

  const EventDetailScreen({
    super.key,
    required this.eventId,
    required this.eventsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EventsState>(
      valueListenable: eventsNotifier,
      builder: (context, state, _) {
        final event = state.events
            .where((e) => e.id == eventId)
            .firstOrNull;

        if (event == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.of(context).pop();
          });
          return const Scaffold(body: SizedBox.shrink());
        }

        return _EventDetailContent(
          event: event,
          eventsNotifier: eventsNotifier,
        );
      },
    );
  }
}

class _EventDetailContent extends StatelessWidget {
  final Event event;
  final EventsNotifier eventsNotifier;

  const _EventDetailContent({
    required this.event,
    required this.eventsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final category = categoryById(event.categoryId);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    Future<void> deleteWithConfirm() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(AppStrings.deleteEventDialogTitle),
          content: Text('«${event.title}» будет удалено.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                AppStrings.deleteEvent,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        final messenger = ScaffoldMessenger.of(context);
        eventsNotifier.deleteEvent(event.id);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: const Text(AppStrings.eventDeleted),
            action: SnackBarAction(
              label: AppStrings.undo,
              onPressed: eventsNotifier.undoDelete,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error),
            tooltip: AppStrings.deleteEvent,
            onPressed: deleteWithConfirm,
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: accent),
            tooltip: AppStrings.editEvent,
            onPressed: () => AddEventSheet.show(
              context,
              eventsNotifier,
              initial: event,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          _CategoryBanner(category: category),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Дата',
                  value: event.formattedDate,
                  accent: accent,
                  theme: theme,
                ),
                const Divider(height: 16),
                _InfoRow(
                  icon: Icons.access_time_outlined,
                  label: 'Время',
                  value: event.formattedTime,
                  accent: accent,
                  theme: theme,
                ),
                const Divider(height: 16),
                _InfoRow(
                  icon: Icons.category_outlined,
                  label: 'Категория',
                  value: '${category.emoji} ${category.label}',
                  accent: accent,
                  theme: theme,
                ),
                if (event.location.isNotEmpty) ...[
                  const Divider(height: 16),
                  _InfoRow(
                    icon: Icons.place_outlined,
                    label: 'Место',
                    value: event.location,
                    accent: accent,
                    theme: theme,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            padding: EdgeInsets.zero,
            child: ExpansionTile(
              leading: Icon(Icons.notes_rounded, color: accent),
              title: Text(
                AppStrings.descriptionSection,
                style: theme.textTheme.titleSmall,
              ),
              initiallyExpanded: event.description.isNotEmpty,
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    event.description.isEmpty
                        ? AppStrings.noDescription
                        : event.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: event.description.isEmpty
                          ? theme.textTheme.bodySmall?.color
                          : null,
                      fontStyle: event.description.isEmpty
                          ? FontStyle.italic
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            padding: EdgeInsets.zero,
            child: ExpansionTile(
              leading: Icon(Icons.people_outline_rounded, color: accent),
              title: Text(
                AppStrings.participantsSection,
                style: theme.textTheme.titleSmall,
              ),
              initiallyExpanded: event.participants.isNotEmpty,
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                if (event.participants.isEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.noParticipants,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: event.participants
                        .map(
                          (p) => Chip(
                            label: Text(p),
                            avatar: Icon(
                              Icons.person_outline_rounded,
                              size: 16,
                              color: accent,
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBanner extends StatelessWidget {
  final EventCategory category;

  const _CategoryBanner({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 72,
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: category.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Text(
            category.label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final ThemeData theme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: accent),
        const SizedBox(width: 12),
        Text(label, style: theme.textTheme.bodySmall),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
