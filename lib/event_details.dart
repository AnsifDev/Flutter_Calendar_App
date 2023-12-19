import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_test/database/channel.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/database/event.dart';
import 'package:project_test/database/user.dart';
import 'package:url_launcher/url_launcher.dart';

import 'event_edit_bottom_sheet.dart';
import 'main.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  final void Function(Event)? onRemove;
  final void Function(Event)? onSave;

  const EventDetails({super.key, required this.event, this.onRemove, this.onSave});

  @override
  State<StatefulWidget> createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetails> {
  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  late final Event event;
  Channel? channel;
  CurrentUser? currentUser;
  final scrollController = ScrollController();
  bool bottom = false;

  @override
  void initState() {
    super.initState();

    event = widget.event;
    if (event.channel != null) {
      ChannelsDatabase.instance
          .get(event.channel!)
          .then((value) => setState(() { channel = value; }));
    }

    CurrentUser.instance.then((value) => currentUser = value);

    scrollController.addListener(() {
      var change = scrollController.position.atEdge && scrollController.position.pixels != 0;
      if (change != bottom) setState(() { bottom = change; });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() { bottom = scrollController.position.maxScrollExtent == 0; });
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context).colorScheme;
    var owner = event.channel == null || channel != null && channel!.admins.contains(FirebaseAuth.instance.currentUser!.uid);
    var scroller = SingleChildScrollView(
      controller: scrollController,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                event.title,
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            if (event.imageUrl != null)
              Container(
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  event.imageUrl!,
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
                    Expanded(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 36,
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getFormattedTime(event.dateTime)),
                                Text("${months[event.dateTime.month - 1]} ${event.dateTime.day}, ${event.dateTime.year}"),
                              ],
                            )
                          ]),
                    ),
                    if (event.location != null)
                      const VerticalDivider(
                        width: 20,
                        indent: 5,
                        endIndent: 5,
                        color: Colors.white,
                      ),
                    if (event.location != null)
                      Expanded(
                        child: Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(children: [
                            const Icon(
                              Icons.place,
                              size: 32,
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(event.location!),
                          ]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (channel != null)
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
                          channel!.title,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  if (DataProvider.instance.pageIndex != 2) OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        DataProvider.instance.setHomeState!(() {
                          DataProvider.instance.pageIndex = 2;
                        });
                      },
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
                List<Widget>.generate(event.tags.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Chip(
                      label: Text(event.tags[index]),
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
                  List<Widget>.generate(event.links.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: ActionChip(
                        label: Text(event.links[index].title),
                        avatar: Icon(
                          Icons.link_rounded,
                          color: currentTheme.onSecondaryContainer,
                        ),
                        onPressed: () {
                          launchUrl(Uri.parse(event.links[index].link));
                        },
                        backgroundColor: currentTheme.secondaryContainer,
                        side: BorderSide(color: currentTheme.onSecondaryContainer),
                      ),
                    );
                  })),
            ),
            if (event.description != null)
              Container(
                margin: const EdgeInsets.all(8),
                child: Text(
                  event.description!,
                  textAlign: TextAlign.justify,
                ),
              ),
          ],
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(child: scroller),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: Theme.of(context).colorScheme.primary.withOpacity(
              bottom? 0: 0.08),
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 6),
          child: Row(
            children: [
              if (owner)
                Expanded(child: OutlinedButton(onPressed: () {
                  Navigator.pop(context);
                  if (widget.onRemove != null) widget.onRemove!(event);
                  DataProvider.instance.setHomeState!(() {
                    EventsDatabase.instance.delete(event.id);
                    DataProvider.instance.events.remove(event);
                    if (event.channel != null) DataProvider.instance.channelAsietEvents.remove(event);
                  });
                }, child: const Text("Remove"))),
              if (owner) const SizedBox.square(dimension: 8,),
              if (event.channel != null)
                Expanded(child: (currentUser != null && currentUser!.followingEvents.contains(event.id))? OutlinedButton(
                    onPressed: () {
                      DataProvider.instance.setHomeState!(() {
                        DataProvider.instance.events.remove(event);
                        currentUser!.followingEvents.remove(event.id);
                        currentUser!.save();
                      });
                    },
                    child: const Text("Unfollow")
                ): FilledButton(onPressed: () {
                  DataProvider.instance.setHomeState!(() {
                    DataProvider.instance.events.add(event);
                    currentUser!.followingEvents.add(event.id);
                    currentUser!.save();
                  });
                }, child: const Text("Follow"))),
              if (event.channel != null) const SizedBox.square(dimension: 8,),
              if (owner) Expanded(child: FilledButton(onPressed: () {
                showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  showDragHandle: false,
                  isDismissible: false,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return EventEditBottomSheet(event: event, onSave: widget.onSave,);
                  },
                );
              }, child: const Text("Edit")))
            ],
          )
        )
      ],
    );
  }
}
