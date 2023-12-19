import 'package:flutter/material.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/database/event.dart';
import 'package:project_test/database/user.dart';
import 'package:project_test/info_chips.dart';

import 'database/channel.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final bool showTime;
  final DataProvider dataProvider = DataProvider.instance;
  final void Function()? onRemove;

  EventCard(
      {super.key,
      required this.event,
      this.showTime = true,
      this.onRemove});

  @override
  State<StatefulWidget> createState() => EventCardState();
}

class EventCardState extends State<EventCard> {
  late final Event event;
  Channel? channel;
  CurrentUser? currentUser;
  
  @override
  void initState() {
    super.initState();

    event = widget.event;
    if (event.channel != null) {
      ChannelsDatabase.instance
        .get(event.channel!)
          .then((value) => setState(() { channel = value; }));
    }

    CurrentUser.instance.then((value) => setState(() { currentUser = value; }));
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (event.imageUrl != null)
            Stack(
              fit: StackFit.passthrough,
              children: [
                Image.network(
                  event.imageUrl!,
                  fit: BoxFit.cover,
                ),
                InfoChips(
                    currentTheme: currentTheme,
                    owner: channel?.title,
                    showTime: widget.showTime,
                    dateTime: event.dateTime)
              ],
            ),
          ListTile(
            title: Row(
              children: [
                Flexible(
                  child: Text(event.title, overflow: TextOverflow.ellipsis)
                ),
                if (event.imageUrl == null)
                  Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: InfoChips(
                      currentTheme: currentTheme,
                      owner: channel?.title,
                      inline: true,
                      showTime: widget.showTime,
                      dateTime: event.dateTime,
                    ),
                  )
              ],
            ),
            trailing: event.channel == null? OutlinedButton(
              onPressed: () {
                if (widget.onRemove != null) widget.onRemove!();
                widget.dataProvider.setHomeState!(() {
                  widget.dataProvider.events.remove(event);
                  EventsDatabase.instance.delete(event.id);
                });
              },
              child: const Text("Remove")
            ): (currentUser != null && currentUser!.followingEvents.contains(event.id))? OutlinedButton(
              onPressed: () {
                widget.dataProvider.setHomeState!(() {
                  widget.dataProvider.events.remove(event);
                  currentUser!.followingEvents.remove(event.id);
                  currentUser!.save();
                });
              },
              child: const Text("Unfollow")
            ): FilledButton.tonal(onPressed: () {
              widget.dataProvider.setHomeState!(() {
                widget.dataProvider.events.add(event);
                currentUser!.followingEvents.add(event.id);
                currentUser!.save();
              });
            }, child: const Text("Follow"))
          )


        ],
      ));
  }
}
