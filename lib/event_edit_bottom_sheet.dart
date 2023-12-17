import 'package:flutter/material.dart';
import 'package:project_test/data_provider.dart';
import 'event.dart';

class EventEditBottomSheet extends StatefulWidget {

  EventEditBottomSheet({super.key, Event? event}) {
    updateMode = event != null;
    DataProvider.getInstance().eventEditBottomSheetEvent ??= event ?? Event();
    this.event = DataProvider.getInstance().eventEditBottomSheetEvent!;
  }

  final dataProvider = DataProvider.getInstance();
  late final Event event;
  late final bool updateMode;

  @override
  State<StatefulWidget> createState() => EventEditBottomSheetState();
}

class EventEditBottomSheetState extends State<EventEditBottomSheet> {
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

  late TextEditingController eventName;
  late TextEditingController description;
  late TextEditingController location;


  @override
  void initState() {
    eventName = TextEditingController();
    description = TextEditingController();
    location = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTitleField(context, eventName),
        const Divider(),
        buildDateTimeField(context),
        buildLocationField(context, location),
        const Divider(),
        Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: buildTagInputFiled(context)),
        const Divider(),
        Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: buildLinkInputField(context)),
        const Divider(),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: description,
              maxLines: 5,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Description"),
            )),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"))),
              const SizedBox.square(
                dimension: 10,
              ),
              Expanded(
                  child: FilledButton(
                      onPressed: () {
                        setState(() {
                          widget.event.title = eventName.text;
                          if (description.text.isNotEmpty) {
                            widget.event.description = description.text;
                          }
                          if (!widget.updateMode) {
                            widget.dataProvider.events.add(widget.event);
                          }
                          if (location.text.isNotEmpty) {
                            widget.event.location = location.text;
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save"))),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTitleField(BuildContext context, TextEditingController eventName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                    controller: eventName,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Event Name',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.image_outlined))
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDateTimeField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.event),
          const SizedBox.square(
            dimension: 12,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.parse("2024-12-31"))
                    .then((value) {
                  if (value != null) {
                    setState(() {
                      widget.event.dateTime = DateTime(
                          value.year,
                          value.month,
                          value.day,
                          widget.event.dateTime.hour,
                          widget.event.dateTime.minute);
                    });
                  }
                });
              },
              child: Text(
                "${months[widget.event.dateTime.month - 1]} ${widget.event.dateTime.day}, ${widget.event.dateTime.year}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox.square(
            dimension: 12,
          ),
          GestureDetector(
            onTap: () {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((value) {
                if (value != null) {
                  setState(() {
                    widget.event.dateTime = DateTime(
                        widget.event.dateTime.year,
                        widget.event.dateTime.month,
                        widget.event.dateTime.day,
                        value.hour,
                        value.minute);
                  });
                }
              });
            },
            child: Text(getFormattedTime(widget.event.dateTime),
                style: const TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }

  String getFormattedTime(DateTime dateTime) {
    var halfNotation = dateTime.hour < 12 ? "AM" : "PM";
    var hour = dateTime.hour % 12;
    var formattedTime =
        "${hour < 10 && hour != 0 ? "0" : ""}${hour == 0 ? 12 : hour}:${dateTime.minute} $halfNotation";
    return formattedTime;
  }

  Widget buildLocationField(BuildContext context, TextEditingController location) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.place),
          const SizedBox.square(
            dimension: 12,
          ),
          Expanded(
              child: TextField(
                controller: location,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Location"),
              )),
        ],
      ),
    );
  }

  Widget buildTagInputFiled(BuildContext context) {
    var tagName = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.tag_sharp),
              const SizedBox.square(
                dimension: 12,
              ),
              Expanded(child: TextField(
                controller: tagName,
                decoration:
                const InputDecoration(border: InputBorder.none, hintText: "Tags"),
              )),
              IconButton(
                  onPressed: () {
                    if (tagName.text.isNotEmpty) {
                      setState(() {
                        widget.event.tags.add(tagName.text);
                        tagName.text = "";
                      });
                    }
                  },
                  icon: const Icon(Icons.done))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            alignment: WrapAlignment.start,
            children: List<Widget>.generate(widget.event.tags.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InputChip(
                  label: Text(widget.event.tags[index]),
                  onDeleted: () {
                    setState(() {
                      widget.event.tags.removeAt(index);
                    });
                  },
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  Widget buildLinkInputField(BuildContext context) {
    var linkTitle = TextEditingController();
    var linkAddress = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.link),
              const SizedBox.square(
                dimension: 12,
              ),
              Expanded(child: TextField(
                controller: linkTitle,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Link Title"),
              )),
              Expanded(child: TextField(
                controller: linkAddress,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Link Address"),
              )),
              IconButton(
                  onPressed: () {
                    if (linkTitle.text.isNotEmpty &&
                        linkAddress.text.isNotEmpty) {
                      setState(() {
                        widget.event.links
                            .add(EventLink(linkTitle.text, linkAddress.text));
                        linkTitle.text = linkAddress.text = "";
                      });
                    }
                  },
                  icon: const Icon(Icons.done))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            alignment: WrapAlignment.start,
            children: List<Widget>.generate(widget.event.links.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InputChip(
                  label: Text(widget.event.links[index].title),
                  onDeleted: () {
                    setState(() {
                      widget.event.links.removeAt(index);
                    });
                  },
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}