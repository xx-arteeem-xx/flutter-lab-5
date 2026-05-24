import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/events_notifier.dart';
import '../../data/events_state.dart';
import '../../models/event_category.dart';
import '../../widgets/glass_card.dart';

class StatisticsTab extends StatelessWidget {
  final EventsNotifier notifier;

  const StatisticsTab({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EventsState>(
      valueListenable: notifier,
      builder: (context, state, _) {
        final total = state.totalCount;
        final counts = state.countByCategory;

        if (total == 0) {
          return _EmptyStatistics();
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            _TotalCard(total: total),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemCount: kCategories.length,
              itemBuilder: (_, i) {
                final cat = kCategories[i];
                final count = counts[cat.id] ?? 0;
                return _CategoryStatCard(
                  category: cat,
                  count: count,
                  total: total,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// ─── Total card ──────────────────────────────────────────────────────────────

class _TotalCard extends StatelessWidget {
  final int total;

  const _TotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.event_rounded, color: accent, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.totalEvents,
                style: theme.textTheme.bodySmall,
              ),
              Text(
                '$total',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Category stat card ──────────────────────────────────────────────────────

class _CategoryStatCard extends StatelessWidget {
  final EventCategory category;
  final int count;
  final int total;

  const _CategoryStatCard({
    required this.category,
    required this.count,
    required this.total,
  });

  double get _percentage => total > 0 ? count / total : 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;
    final pct = (_percentage * 100).round();

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: _percentage,
                  strokeWidth: 7,
                  backgroundColor: category.color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(category.color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: category.color,
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accent.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            category.emoji,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            category.label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyStatistics extends StatelessWidget {
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
              Icons.bar_chart_rounded,
              size: 64,
              color: accent.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.statisticsEmpty,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.statisticsEmptyDesc,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
