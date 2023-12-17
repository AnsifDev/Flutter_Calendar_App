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
  Event? eventEditBottomSheetEvent;

  late List<Event> events;
  late ScrollController scrollController;

  DataProvider._();

  void Function(void Function() callback)? setHomeState;

  void onAppInit() {
    scrollController = ScrollController();

    events = List<Event>.generate(100, (index) {
      var event = Event(
          title: "Event $index",
          dateTime: DateTime(
              2023,
              DateTime.now().month,
              Random().nextInt(31) + 1,
              Random().nextInt(23),
              Random().nextInt(6) * 10),
          image: Random().nextBool()
              ? "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/copy-of-event-poster-design-template-aec8f854474878ad32eb54d38b40f85c_screen.jpg?ts=1567084345"
              : null);
      event.links.add(EventLink("Register", "https://www.google.com"));
      return event;
    });
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

  static DataProvider? instance;
  static DataProvider getInstance() {
    instance ??= DataProvider._();
    return instance!;
  }
}
