import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_test/data_provider.dart';
import 'database/event.dart';
import 'main.dart';

class EventEditBottomSheet extends StatefulWidget {
  EventEditBottomSheet({super.key, Event? event, this.channel, this.onSave}) {
    updateMode = event != null;
    this.event = event ?? Event(channel: channel, id: EventsDatabase.instance.getNewId());
  }

  final dataProvider = DataProvider.instance;
  late final Event event;
  late final bool updateMode;
  final String? channel;
  final void Function(Event)? onSave;

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
  late Event event;
  String? imageUrl;
  var saveButtonEnabled = false;
  var uploading = false;
  
  @override
  void initState() {
    super.initState();
    eventName = TextEditingController();
    eventName.addListener(() {
      setState(() {
        saveButtonEnabled = eventName.text.isNotEmpty;
      });
    });
    description = TextEditingController();
    location = TextEditingController();
    event = widget.event;

    eventName.text = event.title;
    description.text = event.description ?? "";
    location.text = event.location ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24),
        child: SingleChildScrollView(child: Column(
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
                            if (imageUrl != null) FirebaseStorage.instance.ref("EventImages/${event.id}").delete();
                          },
                          child: const Text("Cancel"))),
                  const SizedBox.square(
                    dimension: 10,
                  ),
                  Expanded(
                      child: FilledButton(
                          onPressed: saveButtonEnabled && !uploading? () {
                            if (widget.onSave != null) widget.onSave!(event);
                            widget.dataProvider.setHomeState!(() {
                              if (eventName.text.isNotEmpty) event.title = eventName.text;
                              if (description.text.isNotEmpty) event.description = description.text;
                              if (location.text.isNotEmpty) event.location = location.text;
                              if (!widget.updateMode && event.channel == null) widget.dataProvider.events.add(event);
                              if (imageUrl != null) event.imageUrl = imageUrl;
                              EventsDatabase.instance.save(event);
                            });
                            Navigator.pop(context);
                          }: null,
                          child: Text(uploading? "Uploading": "Save"))),
                ],
              ),
            ),
          ],
        ))
    );
  }

  Widget buildTitleField(BuildContext context, TextEditingController eventName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              if (event.imageUrl == null && imageUrl == null && !uploading) IconButton(
                  onPressed: () {
                    FilePicker.platform.pickFiles().then((value) {
                      if (value != null) {
                        File file = File(value.files.single.path!);
                        var fileRef = FirebaseStorage.instance.ref('EventImages/${event.id}');
                        setState(() { uploading = true; });
                        fileRef.putFile(file).snapshotEvents.listen((transferSnapshot) {
                          switch (transferSnapshot.state) {
                            // case TaskState.running:
                              // final progress =
                              //     100.0 * (transferSnapshot.bytesTransferred / transferSnapshot.totalBytes);
                              // break;
                            case TaskState.error:
                              setState(() { uploading = false; });
                              break;
                            case TaskState.success:
                            // Handle successful uploads on complete
                              fileRef.getDownloadURL().then((value) {
                                setState(() {
                                  imageUrl = value;
                                  uploading = false;
                                });
                              });
                              break;
                            default: break;
                          }
                        });
                      }
                    });
                  }, icon: const Icon(Icons.image_outlined))
            ],
          ),
          if (event.imageUrl != null || imageUrl != null) InputChip(
            label: const Text("Event Display Image"),
            onDeleted: () {
              setState(() {
                FirebaseStorage.instance.ref("EventImages/${event.id}").delete();
                event.imageUrl = imageUrl = null;
              });
            },)
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
                      event.dateTime = DateTime(
                          value.year,
                          value.month,
                          value.day,
                          event.dateTime.hour,
                          event.dateTime.minute);
                    });
                  }
                });
              },
              child: Text(
                "${months[event.dateTime.month - 1]} ${event.dateTime.day}, ${event.dateTime.year}",
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
                    event.dateTime = DateTime(
                        event.dateTime.year,
                        event.dateTime.month,
                        event.dateTime.day,
                        value.hour,
                        value.minute);
                  });
                }
              });
            },
            child: Text(getFormattedTime(event.dateTime),
                style: const TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
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
                        event.tags.add(tagName.text);
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
            children: List<Widget>.generate(event.tags.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InputChip(
                  label: Text(event.tags[index]),
                  onDeleted: () {
                    setState(() {
                      event.tags.removeAt(index);
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
                        event.links
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
            children: List<Widget>.generate(event.links.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InputChip(
                  label: Text(event.links[index].title),
                  onDeleted: () {
                    setState(() {
                      event.links.removeAt(index);
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