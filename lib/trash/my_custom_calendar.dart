import 'package:flutter/material.dart';
import 'package:project_test/event.dart';
import 'package:project_test/trash/main1.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCustomCalendar extends StatefulWidget {
  final ColorScheme currentTheme;
  final CalendarFormat calendarFormat;
  final ScrollController scrollController;
  final Duration duration;
  final List<Event> events;
  final ObjectContainer onDaySelected;
  final ObjectContainer<TableCalendar> calendarWidget = ObjectContainer();

  MyCustomCalendar(
      {super.key,
      required this.currentTheme,
      this.calendarFormat = CalendarFormat.month,
      required this.scrollController,
      required this.duration,
      required this.events,
      required this.onDaySelected});

  @override
  State<StatefulWidget> createState() => _MyCustomCalendarState();
}

class _MyCustomCalendarState extends State<MyCustomCalendar> {
  late CalendarFormat calendarFormat;
  double prevOffset = 0;
  bool hovered = false;
  var focusedDay = DateTime.now();

  @override
  void initState() {
    calendarFormat = widget.calendarFormat;
    widget.scrollController.addListener(onScrollEvent);
    super.initState();
  }

  void onScrollEvent() {
    if (prevOffset < widget.scrollController.offset &&
        calendarFormat == CalendarFormat.month) {
      setState(() {
        calendarFormat = CalendarFormat.week;
      });
    }

    if (widget.scrollController.offset == 0 && hovered) {
      setState(() => hovered = false);
    } else if (widget.scrollController.offset != 0 && !hovered) {
      setState(() => hovered = true);
    }

    prevOffset = widget.scrollController.offset;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = widget.currentTheme;
    var calendarWidget = TableCalendar(
      firstDay: DateTime(2020),
      lastDay: DateTime(2050),
      eventLoader: (day) {
        List<Event> events = List.empty(growable: true);
        for (var event in widget.events) {
          if (isSameDay(event.dateTime, day)) {
            events.add(event);
          }
        }
        return events;
      },
      focusedDay: focusedDay,
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: currentTheme.onSurface),
          weekendStyle: TextStyle(color: currentTheme.error)),
      headerStyle: HeaderStyle(
          formatButtonDecoration: BoxDecoration(
              color: currentTheme.primaryContainer,
              border: Border.all(color: currentTheme.primary, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          formatButtonTextStyle:
              TextStyle(color: currentTheme.onPrimaryContainer),
          formatButtonPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
      calendarStyle: CalendarStyle(
          markerSize: 5,
          markersMaxCount: 1,
          markerMargin: const EdgeInsets.only(bottom: 8),
          markersAutoAligned: false,
          markerDecoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: currentTheme.tertiary,
          ),
          weekendTextStyle: TextStyle(color: currentTheme.error),
          todayDecoration: ShapeDecoration(
              shape: const CircleBorder(), color: currentTheme.surfaceVariant),
          todayTextStyle: TextStyle(color: currentTheme.onSurfaceVariant),
          selectedDecoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: currentTheme.primaryContainer),
          selectedTextStyle: TextStyle(color: currentTheme.onPrimaryContainer)),
      onFormatChanged: (format) {
        setState(() {
          if (calendarFormat == CalendarFormat.month) {
            calendarFormat = CalendarFormat.week;
          } else {
            calendarFormat = CalendarFormat.month;
          }
        });
      },
      calendarFormat: calendarFormat,
      formatAnimationDuration: widget.duration,
      selectedDayPredicate: (day) => isSameDay(day, focusedDay),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(this.focusedDay, selectedDay)) {
          setState(() => this.focusedDay = focusedDay);
          widget.onDaySelected.object(focusedDay, selectedDay);
        }
      },
      availableCalendarFormats: const {
        CalendarFormat.month: "Expand",
        CalendarFormat.week: "Collapse"
      },
    );

    return AnimatedContainer(
      duration: widget.duration,
      color: hovered ? currentTheme.primary.withOpacity(0.08) : null,
      child: calendarWidget,
    );
  }

  static bool isSameDay(DateTime day1, DateTime day2) {
    return DateTime(day1.year, day1.month, day1.day)
            .compareTo(DateTime(day2.year, day2.month, day2.day)) ==
        0;
  }
}
