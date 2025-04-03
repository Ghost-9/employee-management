import 'package:employee_ledger/common/widgets/date_picker_button.dart';
import 'package:employee_ledger/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DatePickerModeType { startDate, endDate }

class EmployeeDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DatePickerModeType mode;
  final DateTime? startDateConstraint;

  const EmployeeDatePicker({
    super.key,
    this.initialDate,
    this.mode = DatePickerModeType.startDate,
    this.startDateConstraint,
  });

  @override
  EmployeeDatePickerState createState() => EmployeeDatePickerState();
}

class EmployeeDatePickerState extends State<EmployeeDatePicker> {
  late DateTime _selectedDate;
  late DateTime _today;
  late DateTime _firstDate;
  late DateTime _lastDate;
  late DateTime _currentSystemDate;
  bool _noDateSelected = false;
  final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  @override
  void initState() {
    super.initState();

    _currentSystemDate = DateTime.now();
    _currentSystemDate = DateTime(
      _currentSystemDate.year,
      _currentSystemDate.month,
      _currentSystemDate.day,
    );

    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    } else {
      if (widget.mode == DatePickerModeType.endDate) {
        _noDateSelected = true;
      }
      _selectedDate = _currentSystemDate;
    }

    if (widget.mode == DatePickerModeType.startDate &&
        _selectedDate.isAfter(_currentSystemDate)) {
      _selectedDate = _currentSystemDate;
    }

    if (widget.mode == DatePickerModeType.endDate &&
        widget.startDateConstraint != null &&
        _selectedDate.isBefore(widget.startDateConstraint!)) {
      _selectedDate = widget.startDateConstraint!;
    }

    _today = _selectedDate;
    _updateMonthRange();
  }

  void _updateMonthRange() {
    _firstDate = DateTime(_today.year, _today.month, 1);
    _lastDate = DateTime(_today.year, _today.month + 1, 0);
  }

  void _selectDay(DateTime day) {
    if (widget.mode == DatePickerModeType.startDate &&
        day.isAfter(_currentSystemDate)) {
      return;
    }

    if (widget.mode == DatePickerModeType.endDate &&
        widget.startDateConstraint != null &&
        day.isBefore(widget.startDateConstraint!)) {
      return;
    }

    setState(() {
      _selectedDate = day;
      _noDateSelected = false; // Reset noDateSelected when a date is selected.
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      _today = DateTime(_today.year, _today.month - 1, 1);
      _updateMonthRange();
    });
  }

  void _goToNextMonth() {
    if (widget.mode == DatePickerModeType.startDate) {
      final nextMonth = DateTime(_today.year, _today.month + 1, 1);
      final currentMonth = DateTime(
        _currentSystemDate.year,
        _currentSystemDate.month,
        1,
      );

      if (nextMonth.isAfter(currentMonth)) {
        return;
      }
    }

    setState(() {
      _today = DateTime(_today.year, _today.month + 1, 1);
      _updateMonthRange();
    });
  }

  void _selectRelativeDate(String type) {
    if (widget.mode == DatePickerModeType.startDate) {
      _handleStartDateRelative(type);
    } else {
      _handleEndDateRelative(type);
    }
  }

  void _handleStartDateRelative(String type) {
    setState(() {
      if (type == 'today') {
        _selectedDate = _currentSystemDate;
      } else if (type == 'nextMonday') {
        final reference = _selectedDate;
        int daysUntilNextMonday = (DateTime.monday - reference.weekday + 7) % 7;
        final nextMonday = reference.add(Duration(days: daysUntilNextMonday));

        if (!nextMonday.isAfter(_currentSystemDate)) {
          _selectedDate = nextMonday;
        }
      } else if (type == 'nextTuesday') {
        final reference = _selectedDate;
        int daysUntilNextTuesday =
            (DateTime.tuesday - reference.weekday + 7) % 7;
        final nextTuesday = reference.add(Duration(days: daysUntilNextTuesday));
        if (!nextTuesday.isAfter(_currentSystemDate)) {
          _selectedDate = nextTuesday;
        }
      } else if (type == 'afterOneWeek') {
        final reference = _selectedDate;
        final afterOneWeek = reference.add(const Duration(days: 7));
        if (!afterOneWeek.isAfter(_currentSystemDate)) {
          _selectedDate = afterOneWeek;
        }
      }
      _today = _selectedDate;
      _updateMonthRange();
    });
  }

  void _handleEndDateRelative(String type) {
    setState(() {
      if (type == 'noDate') {
        _noDateSelected = true;
        Navigator.pop(context, null);
        return;
      } else if (type == 'today') {
        _selectedDate = _currentSystemDate;
        _noDateSelected =
            false; // Reset noDateSelected when a date is selected.
      }

      if (widget.startDateConstraint != null &&
          _selectedDate.isBefore(widget.startDateConstraint!)) {
        _selectedDate = widget.startDateConstraint!;
        _noDateSelected = false;
      }

      _today = _selectedDate;
      _updateMonthRange();
    });
  }

  Widget _buildDay(DateTime day) {
    bool isSelected =
        _selectedDate.year == day.year &&
        _selectedDate.month == day.month &&
        _selectedDate.day == day.day;

    bool isTodayInCalendar =
        _currentSystemDate.year == day.year &&
        _currentSystemDate.month == day.month &&
        _currentSystemDate.day == day.day;

    bool isSameMonth = _today.month == day.month;

    bool isSelectable = true;

    if (widget.mode == DatePickerModeType.startDate &&
        day.isAfter(_currentSystemDate)) {
      isSelectable = false;
    }

    if (widget.mode == DatePickerModeType.endDate &&
        widget.startDateConstraint != null &&
        day.isBefore(widget.startDateConstraint!)) {
      isSelectable = false;
    }

    if (widget.mode == DatePickerModeType.endDate &&
        day.isAfter(_currentSystemDate)) {
      isSelectable = false;
    }

    return Expanded(
      child: GestureDetector(
        onTap: (isSameMonth && isSelectable) ? () => _selectDay(day) : null,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color:
                isSelected && !_noDateSelected
                    ? Colors.blue
                    : Colors.transparent,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color:
                    _noDateSelected
                        ? Colors.grey
                        : isSelected
                        ? Colors.white
                        : isTodayInCalendar && isSameMonth
                        ? Colors.blue
                        : isSameMonth
                        ? isSelectable
                            ? Colors.black
                            : Colors.grey.withValues(alpha: 0.5)
                        : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeek(List<DateTime?> weekDays) {
    return Row(
      children:
          weekDays.map((day) {
            if (day != null &&
                day.isAfter(_firstDate.subtract(const Duration(days: 1))) &&
                day.isBefore(_lastDate.add(const Duration(days: 1)))) {
              return _buildDay(day);
            } else {
              return const Expanded(child: SizedBox());
            }
          }).toList(),
    );
  }

  List<DateTime?> _getCalendarDays() {
    final firstDayOfMonth = DateTime(_today.year, _today.month, 1);
    final lastDayOfMonth = DateTime(_today.year, _today.month + 1, 0);
    final firstDayOfCalendar = firstDayOfMonth.subtract(
      Duration(days: (firstDayOfMonth.weekday % 7)),
    );

    final lastDayOfCalendar = lastDayOfMonth.add(
      Duration(
        days:
            7 -
            (lastDayOfMonth.weekday % 7 == 0 ? 7 : lastDayOfMonth.weekday % 7),
      ),
    );

    final calendarDays = <DateTime?>[];
    DateTime currentDay = firstDayOfCalendar;
    while (!currentDay.isAfter(lastDayOfCalendar)) {
      calendarDays.add(currentDay);
      currentDay = currentDay.add(const Duration(days: 1));
    }
    return calendarDays;
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = _getCalendarDays();
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.mode == DatePickerModeType.startDate)
            _buildStartDateOptions(isSmallScreen)
          else
            _buildEndDateOptions(isSmallScreen),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left_rounded),
                  onPressed: _goToPreviousMonth,
                  visualDensity: VisualDensity.compact,
                  color: AppColors.lightGrey,
                  iconSize: 30.0,
                ),
                Center(
                  child: Text(
                    DateFormat('MMMM yyyy').format(_today),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.color8,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_right_rounded,
                    color: AppColors.lightGrey,
                  ),
                  onPressed:
                      widget.mode == DatePickerModeType.startDate &&
                              _today.year == _currentSystemDate.year &&
                              _today.month == _currentSystemDate.month
                          ? null
                          : _goToNextMonth,
                  iconSize: 30.0,
                  color:
                      widget.mode == DatePickerModeType.startDate &&
                              _today.year == _currentSystemDate.year &&
                              _today.month == _currentSystemDate.month
                          ? Colors.grey.withValues(alpha: 0.5)
                          : null,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children:
                  weekDays
                      .map(
                        (day) => Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10.0 : 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                for (var i = 0; i < calendarDays.length; i += 7)
                  _buildWeek(
                    calendarDays.sublist(
                      i,
                      i + 7 > calendarDays.length ? calendarDays.length : i + 7,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.event_rounded,
                      size: 24.0,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      widget.mode == DatePickerModeType.endDate
                          ? _noDateSelected
                              ? 'No Date'
                              : _dateFormat.format(_selectedDate)
                          : _dateFormat.format(_selectedDate),
                      style: TextStyle(fontSize: isSmallScreen ? 13.0 : 14.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueLight3,
                        foregroundColor: AppColors.primary,
                        minimumSize: Size(73, 40),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: Text("Cancel"),
                    ),

                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          _noDateSelected ? null : _selectedDate,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: Size(73, 40),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartDateOptions(bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DatePickerButton(
                title: 'Today',
                onPressed: () => _selectRelativeDate('today'),
                textColor:
                    _isSelectedDateEqualTo(_currentSystemDate)
                        ? AppColors.primaryLight
                        : AppColors.color1,
                backgroundColor:
                    _isSelectedDateEqualTo(_currentSystemDate)
                        ? AppColors.color1
                        : AppColors.blueLight3,
                fontSize: isSmallScreen ? 12.0 : 14.0,
              ),
              DatePickerButton(
                title: 'Next Monday',
                onPressed: () => _selectRelativeDate('nextMonday'),
                textColor:
                    _isSelectedDateNextDay(DateTime.monday)
                        ? AppColors.primaryLight
                        : AppColors.color1,
                backgroundColor:
                    _isSelectedDateNextDay(DateTime.monday)
                        ? AppColors.color1
                        : AppColors.blueLight3,
                fontSize: isSmallScreen ? 12.0 : 14.0,
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DatePickerButton(
                title: 'Next Tuesday',
                onPressed: () => _selectRelativeDate('nextTuesday'),
                textColor:
                    _isSelectedDateNextDay(DateTime.tuesday)
                        ? AppColors.primaryLight
                        : AppColors.color1,
                backgroundColor:
                    _isSelectedDateNextDay(DateTime.tuesday)
                        ? AppColors.color1
                        : AppColors.blueLight3,
                fontSize: isSmallScreen ? 12.0 : 14.0,
              ),
              DatePickerButton(
                title: 'After 1 week',
                onPressed: () => _selectRelativeDate('afterOneWeek'),
                textColor:
                    _isSelectedDateAfterOneWeek()
                        ? AppColors.primaryLight
                        : AppColors.color1,
                backgroundColor:
                    _isSelectedDateAfterOneWeek()
                        ? AppColors.color1
                        : AppColors.blueLight3,
                fontSize: isSmallScreen ? 12.0 : 14.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEndDateOptions(bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DatePickerButton(
            title: 'No Date',
            onPressed: () => _selectRelativeDate('noDate'),
            textColor:
                _noDateSelected ? AppColors.primaryLight : AppColors.color1,
            backgroundColor:
                _noDateSelected ? AppColors.color1 : AppColors.blueLight3,
            fontSize: isSmallScreen ? 12.0 : 14.0,
          ),
          DatePickerButton(
            title: 'Today',
            onPressed: () => _selectRelativeDate('today'),
            textColor:
                _noDateSelected
                    ? AppColors.color1
                    : _isSelectedDateEqualTo(_currentSystemDate)
                    ? AppColors.primaryLight
                    : AppColors.color1,
            backgroundColor:
                _noDateSelected
                    ? AppColors.blueLight3
                    : _isSelectedDateEqualTo(_currentSystemDate)
                    ? AppColors.color1
                    : AppColors.blueLight3,
            fontSize: isSmallScreen ? 12.0 : 14.0,
          ),
        ],
      ),
    );
  }

  bool _isSelectedDateEqualTo(DateTime date) {
    return _selectedDate.year == date.year &&
        _selectedDate.month == date.month &&
        _selectedDate.day == date.day;
  }

  bool _isSelectedDateNextDay(int weekday) {
    final now = _currentSystemDate;
    int daysUntilNext = (weekday - now.weekday + 7) % 7;
    final nextDate = now.add(Duration(days: daysUntilNext));

    return _selectedDate.year == nextDate.year &&
        _selectedDate.month == nextDate.month &&
        _selectedDate.day == nextDate.day;
  }

  bool _isSelectedDateAfterOneWeek() {
    final oneWeekAgo = _currentSystemDate.subtract(const Duration(days: 7));

    return _selectedDate.year == oneWeekAgo.year &&
        _selectedDate.month == oneWeekAgo.month &&
        _selectedDate.day == oneWeekAgo.day;
  }
}
