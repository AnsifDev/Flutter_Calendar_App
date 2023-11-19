import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_test/event.dart';
import 'package:table_calendar/table_calendar.dart';

class DataProvider {
  var themeMode = ThemeMode.dark;
  var pageIndex = 0;
  var hovered = false;
  var focusedDay = DateTime.now();
  var calendarFormat = CalendarFormat.week;
  var channelLength = 25 + Random().nextInt(25);

  late List<Event> events;
  late ScrollController scrollController;

  void Function(void Function() callback)? setHomeState;

  void onAppInit() {
    scrollController = ScrollController();

    events = List<Event>.generate(
        100,
        (index) => Event(
            title: "Event $index",
            dateTime: DateTime(
                2023,
                DateTime.now().month,
                Random().nextInt(31) + 1,
                Random().nextInt(23),
                Random().nextInt(6) * 10),
            owner: Random().nextBool() ? null : "ASIET",
            image: Random().nextBool()));
  }

  List<Event> getFocusedDayEvents() {
    return getEventsOn(focusedDay);
  }

  List<Event> getEventsOn(DateTime dateTime) {
    List<Event> dayEvents = List.empty(growable: true);
    for (var event in events) {
      if (isSameDay(event.dateTime, dateTime)) {
        dayEvents.add(event);
      }
    }
    return dayEvents;
  }

  List<Event> getEventsFromDate(DateTime dateTime) {
    List<Event> dayEvents = List.empty(growable: true);
    for (var event in events) {
      if (dateTime.compareTo(event.dateTime) <= 0) {
        dayEvents.add(event);
      }
    }
    return dayEvents;
  }
}
