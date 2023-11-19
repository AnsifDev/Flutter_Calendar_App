import 'package:flutter/material.dart';
import 'package:project_test/info_chips.dart';
import 'package:project_test/trash/main1.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCustomListView extends StatefulWidget {
  const MyCustomListView({
    super.key,
    required this.scrollController,
    required this.events,
    required this.currentTheme,
    required this.objectContainer,
  });

  final ScrollController scrollController;
  final List events;
  final ColorScheme currentTheme;
  final ObjectContainer<void Function(DateTime, DateTime)> objectContainer;

  @override
  State<MyCustomListView> createState() => _MyCustomListViewState();
}

class _MyCustomListViewState extends State<MyCustomListView> {
  var focusedDay = DateTime.now();

  @override
  void initState() {
    widget.objectContainer.object = (p0, p1) => setState(() {
          focusedDay = p0;
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dayEvents = List.empty(growable: true);
    for (var event in widget.events) {
      if (isSameDay(focusedDay, event.dateTime)) {
        dayEvents.add(event);
      }
    }

    return ListView.builder(
      controller: widget.scrollController,
      itemCount: dayEvents.length,
      itemBuilder: (BuildContext listContext, int index) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
                enableDrag: true,
                showDragHandle: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Event1",
                              style: TextStyle(fontSize: 22),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("From ASIET"),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                              child: const Text(
                                "Category: Sports",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                              child: const Text(
                                "Registration",
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                });
          },
          child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (dayEvents[index].image)
                    Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Image.asset(
                          "assets/img_example.jpeg",
                          fit: BoxFit.cover,
                          height: 250,
                        ),
                        InfoChips(
                            currentTheme: widget.currentTheme,
                            owner: dayEvents[index].owner,
                            showTime: true,
                            dateTime: dayEvents[index].dateTime)
                      ],
                    ),
                  ListTile(
                      title: Row(
                        children: [
                          Flexible(
                              child: Text(dayEvents[index].title,
                                  overflow: TextOverflow.ellipsis)),
                          if (!dayEvents[index].image)
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              child: InfoChips(
                                currentTheme: widget.currentTheme,
                                owner: dayEvents[index].owner,
                                inline: true,
                                showTime: true,
                                dateTime: dayEvents[index].dateTime,
                              ),
                            )
                        ],
                      ),
                      trailing: OutlinedButton(
                          onPressed: () => {},
                          child: Text(dayEvents[index].owner == null
                              ? "Remove"
                              : "Unfollow")))
                ],
              )),
        );
      },
    );
  }
}
