import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_test/event.dart';
import 'package:project_test/trash/my_custom_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../color_schemes.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  var themeMode = ThemeMode.dark;
  var pageIndex = 0;
  var channelLength = 25 + Random().nextInt(25);
  var hovered = false;
  var focusedDay = DateTime.now();

  late ScrollController scrollController;
  late List<Event> events;
  ObjectContainer<void Function(DateTime, DateTime)> onDaySelected =
      ObjectContainer();

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset != 0 && !hovered) {
        setState(() => hovered = true);
      } else if (scrollController.offset == 0 && hovered) {
        setState(() => hovered = false);
      }
    });

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = isDarkMode(context) ? darkColorScheme : lightColorScheme;

    return MaterialApp(
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
      themeMode: themeMode,
      home: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        backgroundColor: currentTheme.background,
        body: (pageIndex == 0)
            ? schedulesPage(currentTheme, context)
            : channelsPage(currentTheme),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                themeMode =
                    isDarkMode(context) ? ThemeMode.light : ThemeMode.dark;
              });
            },
            label: (pageIndex == 0)
                ? const Text("New Event")
                : const Text("New Channel")),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.event), label: "Schedules"),
            NavigationDestination(
                icon: Icon(Icons.library_books), label: "Event Channels"),
            // NavigationDestination(
            //     icon: Icon(Icons.account_circle), label: "My Account")
          ],
          onDestinationSelected: (index) => setState(() {
            pageIndex = index;
            hovered = false;
          }),
          selectedIndex: pageIndex,
        ),
      ),
    );
  }

  Widget schedulesPage(ColorScheme currentTheme, BuildContext context) {
    var myCustomCalendar = MyCustomCalendar(
      currentTheme: currentTheme,
      scrollController: scrollController,
      duration: const Duration(milliseconds: 200),
      events: events,
      onDaySelected: onDaySelected,
    );

    var dayEvents = List.empty(growable: true);
    for (var event in events) {
      if (isSameDay(focusedDay, event.dateTime)) {
        dayEvents.add(event);
      }
    }

    return Column(
      children: [
        myCustomCalendar,
        Expanded(child: ListView.builder(itemBuilder: (context, index) {
          return null;
        }))
      ],
    );
  }

  Widget channelsPage(ColorScheme currentTheme) {
    var badgeCounts =
        List<int>.generate(channelLength, (index) => Random().nextInt(10));
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: hovered ? currentTheme.primary.withOpacity(0.08) : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.only(left: 16, right: 8)),
                hintText: "Search Channels",
                leading: const Icon(Icons.search),
                trailing: <Widget>[
                  GestureDetector(
                    child: const CircleAvatar(
                      backgroundImage: AssetImage("assets/cat.jpg"),
                    ),
                    onTap: () {},
                  )
                ],
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return <Widget>[];
            },
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: List<Widget>.generate(
                channelLength,
                (index) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(
                            255,
                            Random().nextInt(64),
                            Random().nextInt(96),
                            Random().nextInt(128)),
                        child: const Text("E"),
                      ),
                      title: Text("Channel$index"),
                      // subtitle: Text("Event${Random().nextInt(100)} by User"),
                      subtitleTextStyle: TextStyle(
                          fontSize: 12,
                          color: currentTheme.onSurface.withAlpha(150)),
                      trailing: (badgeCounts[index] < 5)
                          ? null
                          : Badge.count(
                              count: badgeCounts[index] ~/ 2,
                            ),
                      onTap: () => {},
                    )),
          ),
        ),
      ],
    );
  }

  bool isDarkMode(BuildContext context) {
    return themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }
}

class ObjectContainer<T> {
  late T object;
}
