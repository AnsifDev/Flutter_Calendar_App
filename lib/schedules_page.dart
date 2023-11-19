import 'package:flutter/material.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/event.dart';
import 'package:project_test/event_card.dart';
import 'package:project_test/event_details.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulesPage extends StatefulWidget {
  final DataProvider dataProvider;
  final ColorScheme currentTheme;

  const SchedulesPage(
      {super.key, required this.dataProvider, required this.currentTheme});

  @override
  State<StatefulWidget> createState() => SchedulesPageState();
}

class SchedulesPageState extends State<SchedulesPage> {
  double prevOffset = 0;
  bool scrollAttached = false;
  bool updatePermitted = true;

  late PageController pageController;
  ScrollController get scrollController => widget.dataProvider.scrollController;
  CalendarFormat get calendarFormat => widget.dataProvider.calendarFormat;
  set calendarFormat(CalendarFormat value) {
    widget.dataProvider.calendarFormat = value;
  }

  bool get hovered => widget.dataProvider.hovered;
  set hovered(bool value) {
    widget.dataProvider.hovered = value;
  }

  void scrollEventListener() {
    if (prevOffset < scrollController.offset &&
        calendarFormat == CalendarFormat.month) {
      setState(() {
        calendarFormat = CalendarFormat.week;
      });
    }

    if (scrollController.offset != 0 && !hovered) {
      setState(() => hovered = true);
    } else if (scrollController.offset == 0 && hovered) {
      setState(() => hovered = false);
    }

    prevOffset = scrollController.offset;
  }

  @override
  void initState() {
    scrollController.addListener(scrollEventListener);

    pageController = PageController(initialPage: 0xffff);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollEventListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 200);
    int ndays = DateTime.now().millisecondsSinceEpoch ~/ (1000 * 3600 * 24);
    int fdays = widget.dataProvider.focusedDay.millisecondsSinceEpoch ~/
        (1000 * 3600 * 24);
    // print("${widget.dataProvider.focusedDay.day}");

    var pageView = PageView.builder(
      onPageChanged: (index) {
        int actualIndex = index - 0xffff;
        int diff = actualIndex - (fdays - ndays);
        print("$diff");
        DateTime newFocusedDay = DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch +
                actualIndex * 1000 * 3600 * 24);
        if (updatePermitted) {
          setState(() {
            widget.dataProvider.focusedDay = newFocusedDay;
          });
        }
        if (diff == 0) updatePermitted = true;
      },
      controller: pageController,
      itemBuilder: (BuildContext context, int index) {
        int actualIndex = index - 0xffff;
        DateTime today = DateTime.now();
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            (today.millisecondsSinceEpoch + (24 * 3600 * 1000) * actualIndex));

        // print("${fdays - ndays}: $actualIndex: ${dateTime.toIso8601String()}");
        return viewEvents(dateTime);
      },
    );

    if (scrollAttached) {
      pageController.animateToPage((fdays - ndays) + 0xffff,
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
    }

    scrollAttached = true;

    return Column(
      children: [
        AnimatedContainer(
          duration: duration,
          child: Container(
            color: widget.dataProvider.hovered
                ? widget.currentTheme.primary.withOpacity(0.08)
                : widget.currentTheme.primary.withOpacity(0),
            child: buildCalendarWidget(
                currentTheme: widget.currentTheme, duration: duration),
          ),
        ),
        Expanded(child: pageView)
      ],
    );
  }

  Widget buildCalendarWidget(
      {required ColorScheme currentTheme, required Duration duration}) {
    return TableCalendar(
      firstDay: DateTime(2020),
      lastDay: DateTime(2050),
      eventLoader: (day) {
        List<Event> dayEvents = List.empty(growable: true);
        for (var event in widget.dataProvider.events) {
          if (isSameDay(event.dateTime, day)) {
            dayEvents.add(event);
          }
        }
        return dayEvents;
      },
      focusedDay: widget.dataProvider.focusedDay,
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
      weekendDays: const [DateTime.sunday],
      calendarFormat: widget.dataProvider.calendarFormat,
      formatAnimationDuration: duration,
      selectedDayPredicate: (day) =>
          isSameDay(day, widget.dataProvider.focusedDay),
      onDaySelected: (selectedDay, fDay) {
        if (!isSameDay(widget.dataProvider.focusedDay, selectedDay)) {
          updatePermitted = false;
          setState(() => widget.dataProvider.focusedDay = fDay);
        }
      },
      availableCalendarFormats: const {
        CalendarFormat.month: "Expand",
        CalendarFormat.week: "Collapse"
      },
    );
  }

  Widget viewEvents(DateTime dateTime) {
    List<Event> dayEvents = widget.dataProvider.getEventsOn(dateTime);
    // print("${dayEvents.length}");
    return (dayEvents.isEmpty)
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.event_busy,
              size: 200,
              color: widget.currentTheme.onSurface.withOpacity(0.2),
            ),
            Text(
              "No events this day.\nSchedule some right away",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: widget.currentTheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.bold),
            )
          ])
        : ListView.builder(
            // controller: widget.dataProvider.scrollController,
            itemCount: dayEvents.length,
            itemBuilder: (buildContext, index) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: true,
                      useSafeArea: true,
                      showDragHandle: true,
                      context: buildContext,
                      builder: (builder) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin: const EdgeInsets.only(bottom: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [EventDetails(event: dayEvents[index])],
                          ),
                        );
                      });
                },
                child: EventCard(
                  event: dayEvents[index],
                ),
              );
            });
  }
}
