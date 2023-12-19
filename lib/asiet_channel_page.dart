import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/schedules_page.dart';

import 'database/channel.dart';

class ASIETChannelPage extends StatefulWidget {
  ASIETChannelPage({super.key});

  final DataProvider dataProvider = DataProvider.instance;

  @override
  State<StatefulWidget> createState() => ASIETChannelPageState();
}

class ASIETChannelPageState extends State<ASIETChannelPage> {
  late final Channel channelASIET;

  @override
  void initState() {
    super.initState();

    // var channelsDB = ChannelsDatabase.instance;
    // channelsDB.get("asiet").then((c) {
    //   channelASIET = c!;
    //   for (var eventId in channelASIET.events) {
    //     EventsDatabase.instance.get(eventId).then((event) => setState(() {
    //       if (event != null) events.add(event);
    //     }));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                elevation: const MaterialStatePropertyAll(4),
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.only(left: 16, right: 8)),
                hintText: "Search Channels",
                leading: const Icon(Icons.search),
                trailing: <Widget>[
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                    ),
                    onTap: () {
                      showDialog(context: context, builder: (BuildContext c) {
                        return AlertDialog(
                          title: const Text("Profile Page Under Development"),
                          content: const Text("The profile page will be available shortly. Do you wanna logout?"),
                          actions: [
                            MaterialButton(onPressed: () {
                              Navigator.pop(c);
                            }, child: const Text("Cancel")),
                            MaterialButton(onPressed: () {
                              Navigator.pop(c);
                              GoogleSignIn().signOut();
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacementNamed(context, '/auth');
                            }, child: const Text("Logout"),),
                          ],
                        );
                      }, );
                    },
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
        Expanded(child: EventsListView(events: widget.dataProvider.channelAsietEvents, emptyMsg: "No Events So far"))
      ],
    );
  }
}
