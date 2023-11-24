import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_test/channel_page.dart';
import 'package:project_test/data_provider.dart';

class ChannelsPage extends StatefulWidget {
  final DataProvider dataProvider;
  final ColorScheme currentTheme;

  const ChannelsPage(
      {super.key, required this.dataProvider, required this.currentTheme});

  @override
  State<StatefulWidget> createState() => ChannelsPageState();
}

class ChannelsPageState extends State<ChannelsPage> {
  ScrollController get scrollController => widget.dataProvider.scrollController;
  // bool get hovered => widget.dataProvider.hovered;
  // set hovered(bool value) {
  //   widget.dataProvider.hovered = value;
  // }

  // void scrollEventListener() {
  //   if (scrollController.offset != 0 && !hovered) {
  //     setState(() => hovered = true);
  //   } else if (scrollController.offset == 0 && hovered) {
  //     setState(() => hovered = false);
  //   }
  // }

  // @override
  // void initState() {
  //   scrollController.addListener(scrollEventListener);

  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   scrollController.removeListener(scrollEventListener);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var badgeCounts = List<int>.generate(
        widget.dataProvider.channelLength, (index) => Random().nextInt(10));
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // color: widget.dataProvider.hovered
          //     ? widget.currentTheme.primary.withOpacity(0.08)
          //     : null,
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
          child: ListView(
            controller: widget.dataProvider.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: List<Widget>.generate(
                widget.dataProvider.channelLength,
                (index) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(
                            255,
                            Random().nextInt(64),
                            Random().nextInt(96),
                            Random().nextInt(128)),
                        child: const Text("E"),
                      ),
                      title: Text("Channel$index"),
                      subtitle: Text("Followers ${Random().nextInt(300)}"),
                      subtitleTextStyle: TextStyle(
                          fontSize: 12,
                          color: widget.currentTheme.onSurface.withAlpha(150)),
                      onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ChannelPage(
                            dataProvider: widget.dataProvider,
                          );
                        }))
                      },
                    )),
          ),
        ),
      ],
    );
  }
}
