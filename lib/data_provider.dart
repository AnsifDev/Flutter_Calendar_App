import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_test/database/event.dart';
import 'package:project_test/database/user.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';

import 'database/channel.dart';

class DataProvider {
  var themeMode = ThemeMode.dark;
  var pageIndex = 0;
  var hovered = false;
  var focusedDay = DateTime.now();
  var calendarFormat = CalendarFormat.week;
  var channelLength = 25 + Random().nextInt(25);

  late FirebaseDatabase database;
  late List<Event> events;
  late ScrollController scrollController;
  Channel? channelASIET;
  late List<Event> channelAsietEvents;

  DataProvider._();

  void Function(void Function() callback)? setHomeState;
  
  Future<void> loadEventsFrom(List<String> src, List<Event> dest) async {
    var trash = <String>[];
    var processes = <Future<Event?>>[];

    for (var eventId in src) {
      var process = EventsDatabase.instance.get(eventId);
      processes.add(process);
      process.then((event) {
        if (event != null) { setHomeState!(() { dest.add(event); }); }
        else { trash.add(eventId); }
      });
    }

    for (var process in processes) { await process; }

    while(trash.isNotEmpty) { src.remove(trash.removeAt(0)); }
  }

  void loadEvents() async {
    var currentUser = await CurrentUser.instance;

    var load1 = loadEventsFrom(currentUser.events, events);
    var load2 = loadEventsFrom(currentUser.followingEvents, events);


    channelASIET = await ChannelsDatabase.instance.get("asiet");
    if (channelASIET == null) {
      channelASIET = Channel(
          id: "asiet",
          title: "ASIET",
          description: "ASIET Official Global Channel"
      );
      ChannelsDatabase.instance.save(channelASIET!);
    }

    var load3 = loadEventsFrom(channelASIET!.events, channelAsietEvents);

    await load1;
    await load2;
    await load3;
    currentUser.save();
    ChannelsDatabase.instance.save(channelASIET!);
  }

  void onAppInit() {
    scrollController = ScrollController();
    database = FirebaseDatabase.instance;
    loadEvents();

    events = List<Event>.empty(growable: true);
    channelAsietEvents = List<Event>.empty(growable: true);
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

  static DataProvider? _instance;

  static DataProvider get instance {
    _instance ??= DataProvider._();
    return _instance!;
  }
}
