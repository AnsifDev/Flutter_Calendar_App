import 'package:flutter/material.dart';
import 'package:project_test/channels_page.dart';
import 'package:project_test/color_schemes.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/schedules_page.dart';
import 'package:project_test/upcoming_page.dart';

void main() {
  runApp(Home(dataProvider: DataProvider()));
}

class Home extends StatefulWidget {
  final DataProvider dataProvider;

  const Home({super.key, required this.dataProvider});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    widget.dataProvider.onAppInit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = isDarkMode(context) ? darkColorScheme : lightColorScheme;

    return MaterialApp(
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
      themeMode: widget.dataProvider.themeMode,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          surfaceTintColor:
              (widget.dataProvider.pageIndex == 0) ? null : Colors.transparent,
        ),
        backgroundColor: currentTheme.background,
        body: (widget.dataProvider.pageIndex == 0)
            ? SchedulesPage(
                dataProvider: widget.dataProvider, currentTheme: currentTheme)
            : (widget.dataProvider.pageIndex == 2)
                ? ChannelsPage(
                    dataProvider: widget.dataProvider,
                    currentTheme: currentTheme,
                  )
                : UpcomingPage(
                    dataProvider: widget.dataProvider,
                    currentTheme: currentTheme),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                widget.dataProvider.themeMode =
                    isDarkMode(context) ? ThemeMode.light : ThemeMode.dark;
              });
            },
            label: (widget.dataProvider.pageIndex != 2)
                ? const Text("New Event")
                : const Text("New Channel")),
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
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    return widget.dataProvider.themeMode == ThemeMode.dark ||
        (widget.dataProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }

  Widget upcomingPage(ColorScheme currentTheme) {
    return Container();
  }
}
