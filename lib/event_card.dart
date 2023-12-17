import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/event.dart';
import 'package:project_test/info_chips.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final bool showTime;
  final DataProvider dataProvider = DataProvider.getInstance();

  EventCard(
      {super.key,
      required this.event,
      this.showTime = true});

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
            if (widget.event.image != null)
              Stack(
                fit: StackFit.passthrough,
                children: [
                  Image.network(
                    widget.event.image!,
                    fit: BoxFit.cover,
                  ),
                  InfoChips(
                      currentTheme: currentTheme,
                      owner: widget.event.channel?.title,
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
                    if (widget.event.image == null)
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: InfoChips(
                          currentTheme: currentTheme,
                          owner: widget.event.channel?.title,
                          inline: true,
                          showTime: widget.showTime,
                          dateTime: widget.event.dateTime,
                        ),
                      )
                  ],
                ),
                trailing: OutlinedButton(
                    onPressed: () => {
                          if (widget.event.channel == null)
                            {
                              widget.dataProvider.setHomeState!(
                                () {
                                  widget.dataProvider.events
                                      .remove(widget.event);
                                },
                              )
                            }
                        },
                    child: Text(
                        widget.event.channel == null ? "Remove" : "Unfollow")))
          ],
        ));
  }
}
