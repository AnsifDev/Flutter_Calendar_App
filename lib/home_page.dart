import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/schedules_page.dart';
import 'package:project_test/upcoming_page.dart';

import 'event_edit_bottom_sheet.dart';
import 'channels_page.dart';
import 'color_schemes.dart';

class HomePage extends StatefulWidget{
  HomePage({super.key});

  final dataProvider = DataProvider.getInstance();

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = isDarkMode(context) ? darkColorScheme : lightColorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: (widget.dataProvider.hovered)
            ? currentTheme.primary.withOpacity(0.08)
            : null,
        systemOverlayStyle: (widget.dataProvider.hovered)
            ? (isDarkMode(context))
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark
            : null,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: currentTheme.background,
      body: (widget.dataProvider.pageIndex == 0)
          ? SchedulesPage(
          dataProvider: widget.dataProvider, currentTheme: currentTheme)
          : (widget.dataProvider.pageIndex == 2)
          ? ChannelsPage(currentTheme: currentTheme)
          : UpcomingPage(currentTheme: currentTheme),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton.extended(
            isExtended: !widget.dataProvider.hovered,
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  // return SingleChildScrollView(child: createEventView(context, null));
                  return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(child: EventEditBottomSheet())
                  );
                },
              );
            },
            label: (widget.dataProvider.pageIndex != 2)
                ? const Text("New Event")
                : const Text("New Channel"));
      }),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: "Schedules"),
          NavigationDestination(
              icon: Icon(Icons.upcoming), label: "Upcoming Events"),
          NavigationDestination(
              icon: Icon(Icons.chat), label: "Event Channels")
        ],
        onDestinationSelected: (index) => setState(() {
          widget.dataProvider.pageIndex = index;
          widget.dataProvider.hovered = false;
        }),
        selectedIndex: widget.dataProvider.pageIndex,
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    return widget.dataProvider.themeMode == ThemeMode.dark ||
        (widget.dataProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }
}