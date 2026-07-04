import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';

class CustomCalendar extends StatefulWidget {
  final Set<DateTime> markedDates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  const CustomCalendar({
    super.key,
    this.markedDates = const {},
    this.selectedDate,
    this.onDateSelected,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _focusedMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final initial = widget.selectedDate ?? DateTime.now();
    _focusedMonth = DateTime(initial.year, initial.month);
    _selectedDay = DateTime(initial.year, initial.month, initial.day);
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isMarked(DateTime day) =>
      widget.markedDates.any((d) => _isSameDay(d, day));

  bool _isSelected(DateTime day) => _isSameDay(_selectedDay, day);

  bool _isInCurrentMonth(DateTime day) =>
      day.month == _focusedMonth.month && day.year == _focusedMonth.year;

  /// Build 5 rows × 7 cols of [DateTime] for the focused month (Sun‑start).
  List<DateTime> _buildCalendarDays() {
    final first = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    // Sunday == 7 in ISO, remap so Sunday == 0
    final startOffset = first.weekday % 7;
    final start = first.subtract(Duration(days: startOffset));
    return List.generate(35, (i) => start.add(Duration(days: i)));
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + 1,
      );
    });
  }

  // ── month name ──────────────────────────────────────────────────────────

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // ── build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();

    final headerDay = _isInCurrentMonth(_selectedDay)
        ? _selectedDay.day
        : 1;

    final headerLabel =
        '$headerDay ${_months[_focusedMonth.month - 1]}, ${_focusedMonth.year}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── header (outside the white box) ──
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                headerLabel,
                style: AppTexts.tmdr,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _previousMonth,
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 20,
                      color: AppColors.black.shade300,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _nextMonth,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.black.shade300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── calendar body (white container) ──
        Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDayOfWeekRow(),
              const SizedBox(height: 4),
              ...List.generate(5, (row) {
                final weekDays = days.sublist(row * 7, row * 7 + 7);
                return _buildWeekRow(weekDays);
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ── day‑of‑week labels ─────────────────────────────────────────────────

  Widget _buildDayOfWeekRow() {
    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      children: labels
          .map(
            (l) => Expanded(
              child: Center(
                child: Text(
                  l,
                  style:
                      AppTexts.tmdm.copyWith(color: AppColors.black.shade400),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // ── week row ────────────────────────────────────────────────────────────

  Widget _buildWeekRow(List<DateTime> weekDays) {
    return Row(
      children: weekDays.map((day) => Expanded(child: _buildDay(day))).toList(),
    );
  }

  // ── single day cell ─────────────────────────────────────────────────────

  Widget _buildDay(DateTime day) {
    final inMonth = _isInCurrentMonth(day);
    final selected = _isSelected(day);
    final marked = _isMarked(day);

    // Text colour
    Color textColor;
    if (selected) {
      textColor = AppColors.white;
    } else if (!inMonth) {
      textColor = AppColors.black.shade200;
    } else {
      textColor = AppColors.black.shade300;
    }

    // Decoration
    BoxDecoration? decoration;
    if (selected) {
      decoration = BoxDecoration(
        color: AppColors.green.shade700,
        shape: BoxShape.circle,
      );
    } else if (marked) {
      decoration = BoxDecoration(
        color: AppColors.green.shade50,
        shape: BoxShape.circle,
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
          if (!inMonth) _focusedMonth = DateTime(day.year, day.month);
        });
        widget.onDateSelected?.call(day);
      },
      child: Container(
        height: 40,
        alignment: Alignment.center,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: decoration,
          child: Text(
            '${day.day}',
            style: AppTexts.tsmr.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
