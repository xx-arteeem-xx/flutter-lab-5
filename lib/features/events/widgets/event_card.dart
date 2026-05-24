import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/events_notifier.dart';
import '../../../models/event.dart';
import '../../../models/event_category.dart';
import '../../../widgets/glass_card.dart';
import '../../event_detail/event_detail_screen.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final EventsNotifier notifier;

  const EventCard({
    super.key,
    required this.event,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final category = categoryById(event.categoryId);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;
    final messenger = ScaffoldMessenger.of(context);

    return Dismissible(
      key: ValueKey(event.id),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(isDark: isDark),
      onDismissed: (_) {
        notifier.deleteEvent(event.id);
        messenger.showSnackBar(
          SnackBar(
            content: const Text(AppStrings.eventDeleted),
            action: SnackBarAction(
              label: AppStrings.undo,
              onPressed: notifier.undoDelete,
            ),
          ),
        );
      },
      child: GlassCard(
        padding: EdgeInsets.zero,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(
              eventId: event.id,
              eventsNotifier: notifier,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryBanner(category: category),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 12, color: accent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.formattedDate,
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, size: 12, color: accent),
                        const SizedBox(width: 4),
                        Text(
                          event.formattedTime,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (event.location.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.place_outlined, size: 12, color: accent),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
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
      height: 38,
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.18),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              category.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: category.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  final bool isDark;

  const _DismissBackground({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
    );
  }
}
