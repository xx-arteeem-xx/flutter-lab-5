import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/events_notifier.dart';
import '../../models/event.dart';
import '../../models/event_category.dart';

class AddEventSheet extends StatefulWidget {
  final EventsNotifier notifier;
  final Event? initial;

  const AddEventSheet({
    super.key,
    required this.notifier,
    this.initial,
  });

  static Future<void> show(
    BuildContext context,
    EventsNotifier notifier, {
    Event? initial,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEventSheet(notifier: notifier, initial: initial),
    );
  }

  @override
  State<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends State<AddEventSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _participantsCtrl;
  late String _categoryId;
  late DateTime _date;
  late TimeOfDay _time;
  String? _titleError;

  bool get _isEditMode => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final ev = widget.initial;
    _titleCtrl = TextEditingController(text: ev?.title ?? '');
    _locationCtrl = TextEditingController(text: ev?.location ?? '');
    _descriptionCtrl = TextEditingController(text: ev?.description ?? '');
    _participantsCtrl = TextEditingController(
      text: ev?.participants.join(', ') ?? '',
    );
    _categoryId = ev?.categoryId ?? kCategories.first.id;
    _date = ev?.date ?? DateTime.now().add(const Duration(days: 1));
    _time = ev?.time ?? const TimeOfDay(hour: 12, minute: 0);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _participantsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = AppStrings.titleRequired);
      return;
    }

    final participants = _participantsCtrl.text
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (_isEditMode) {
      final updated = widget.initial!.copyWith(
        title: title,
        description: _descriptionCtrl.text.trim(),
        date: _date,
        time: _time,
        categoryId: _categoryId,
        location: _locationCtrl.text.trim(),
        participants: participants,
      );
      widget.notifier.updateEvent(updated);
    } else {
      final event = Event(
        id: widget.notifier.newId(),
        title: title,
        description: _descriptionCtrl.text.trim(),
        date: _date,
        time: _time,
        categoryId: _categoryId,
        location: _locationCtrl.text.trim(),
        participants: participants,
      );
      widget.notifier.addEvent(event);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      duration: const Duration(milliseconds: 150),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    _isEditMode ? AppStrings.editEvent : AppStrings.addEvent,
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: accent),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleCtrl,
                      autofocus: !_isEditMode,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) {
                        if (_titleError != null) {
                          setState(() => _titleError = null);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: AppStrings.eventTitle,
                        hintText: AppStrings.eventTitleHint,
                        errorText: _titleError,
                        prefixIcon: Icon(Icons.title_rounded, color: accent),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _categoryId,
                      decoration: InputDecoration(
                        labelText: AppStrings.eventCategory,
                        prefixIcon: Icon(Icons.category_rounded, color: accent),
                      ),
                      items: kCategories
                          .map((cat) => DropdownMenuItem(
                                value: cat.id,
                                child: Row(
                                  children: [
                                    Text(cat.emoji),
                                    const SizedBox(width: 8),
                                    Text(cat.label),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _categoryId = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _PickerButton(
                            icon: Icons.calendar_month_rounded,
                            label: AppStrings.eventDate,
                            value: formatDate(_date),
                            accent: accent,
                            onTap: _pickDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PickerButton(
                            icon: Icons.access_time_rounded,
                            label: AppStrings.eventTime,
                            value: formatTime(_time),
                            accent: accent,
                            onTap: _pickTime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _locationCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: AppStrings.eventLocation,
                        hintText: AppStrings.eventLocationHint,
                        prefixIcon: Icon(Icons.place_outlined, color: accent),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: AppStrings.eventDescription,
                        hintText: AppStrings.eventDescriptionHint,
                        prefixIcon: Icon(Icons.notes_rounded, color: accent),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _participantsCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: AppStrings.eventParticipants,
                        hintText: AppStrings.eventParticipantsHint,
                        prefixIcon: Icon(Icons.people_outline_rounded, color: accent),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          _isEditMode ? AppStrings.save : AppStrings.add,
                        ),
                      ),
                    ),
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

class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final VoidCallback onTap;

  const _PickerButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: accent),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
