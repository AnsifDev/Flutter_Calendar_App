import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_test/event.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  const EventDetails({super.key, required this.event});

  @override
  State<StatefulWidget> createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context).colorScheme;
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.event.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.event.image != null)
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  widget.event.image!,
                  fit: BoxFit.fitWidth,
                ),
              ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: currentTheme.secondaryContainer),
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 36,
                            ),
                            SizedBox.square(
                              dimension: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("10:30 AM"),
                                Text("18 Nov 2023"),
                              ],
                            )
                          ]),
                    ),
                    if (widget.event.location != null)
                      const VerticalDivider(
                        width: 20,
                        indent: 5,
                        endIndent: 5,
                        color: Colors.white,
                      ),
                    if (widget.event.location != null)
                      Expanded(
                        child: Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: const Row(children: [
                            Icon(
                              Icons.place,
                              size: 32,
                            ),
                            SizedBox.square(
                              dimension: 10,
                            ),
                            Text("ADP LAB"),
                          ]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (widget.event.channel != null)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: currentTheme.tertiaryContainer),
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.only(
                    top: 6, bottom: 6, left: 6, right: 32),
                child: Row(children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: currentTheme.tertiary),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Text(
                          "From Channel",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          widget.event.channel!.title,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          foregroundColor: currentTheme.tertiary,
                          side: BorderSide(color: currentTheme.tertiary)),
                      child: const Text("Open"))
                ]),
              ),
            Container(
              margin: const EdgeInsets.only(top: 6),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children:
                    List<Widget>.generate(widget.event.tags.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Chip(
                      label: Text(widget.event.tags[index]),
                      backgroundColor: currentTheme.secondaryContainer,
                      side: BorderSide(color: currentTheme.secondary),
                      padding: const EdgeInsets.all(6),
                    ),
                  );
                }),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 6),
              child: Wrap(
                  children:
                      List<Widget>.generate(widget.event.links.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: ActionChip(
                    label: Text(widget.event.links[index].title),
                    avatar: Icon(
                      Icons.link_rounded,
                      color: currentTheme.onSecondaryContainer,
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse(widget.event.links[index].link));
                    },
                    backgroundColor: currentTheme.secondaryContainer,
                    side: BorderSide(color: currentTheme.onSecondaryContainer),
                  ),
                );
              })),
            ),
            if (widget.event.description != null)
              Container(
                margin: const EdgeInsets.all(8),
                child: Text(
                  widget.event.description!,
                  textAlign: TextAlign.justify,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
