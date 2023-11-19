import 'package:flutter/material.dart';
import 'package:project_test/event.dart';
import 'package:project_test/info_chips.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final bool showTime;

  const EventCard({super.key, required this.event, this.showTime = true});

  @override
  State<StatefulWidget> createState() => EventCardState();
}

class EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context).colorScheme;
    return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.event.image)
              Stack(
                fit: StackFit.passthrough,
                children: [
                  Image.asset(
                    "assets/img_example.jpeg",
                    fit: BoxFit.cover,
                  ),
                  InfoChips(
                      currentTheme: currentTheme,
                      owner: widget.event.owner,
                      showTime: widget.showTime,
                      dateTime: widget.event.dateTime)
                ],
              ),
            ListTile(
                title: Row(
                  children: [
                    Flexible(
                        child: Text(widget.event.title,
                            overflow: TextOverflow.ellipsis)),
                    if (!widget.event.image)
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: InfoChips(
                          currentTheme: currentTheme,
                          owner: widget.event.owner,
                          inline: true,
                          showTime: widget.showTime,
                          dateTime: widget.event.dateTime,
                        ),
                      )
                  ],
                ),
                trailing: OutlinedButton(
                    onPressed: () => {},
                    child: Text(
                        widget.event.owner == null ? "Remove" : "Unfollow")))
          ],
        ));
  }
}
