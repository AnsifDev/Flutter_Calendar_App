import 'package:flutter/material.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/event.dart';
import 'package:project_test/event_card.dart';
import 'package:project_test/event_details.dart';

class UpcomingPage extends StatefulWidget {
  final DataProvider dataProvider;
  final ColorScheme currentTheme;

  const UpcomingPage(
      {super.key, required this.dataProvider, required this.currentTheme});

  @override
  State<StatefulWidget> createState() => UpcomingPageState();
}

class UpcomingPageState extends State<UpcomingPage> {
  @override
  Widget build(BuildContext context) {
    List<Event> dayEvents =
        widget.dataProvider.getEventsFromDate(widget.dataProvider.focusedDay);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                elevation: const MaterialStatePropertyAll(4),
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.only(left: 16, right: 8)),
                hintText: "Search Events",
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
            child: (dayEvents.isEmpty)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                              color: widget.currentTheme.onSurface
                                  .withOpacity(0.6),
                              fontWeight: FontWeight.bold),
                        )
                      ])
                : ListView.builder(
                    controller: widget.dataProvider.scrollController,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  margin: const EdgeInsets.only(bottom: 32),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      EventDetails(event: dayEvents[index])
                                    ],
                                  ),
                                );
                              });
                        },
                        child: EventCard(
                          event: dayEvents[index],
                          showTime: false,
                        ),
                      );
                    }))
      ],
    );
  }
}
