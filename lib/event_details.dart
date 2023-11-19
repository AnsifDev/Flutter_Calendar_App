import 'package:flutter/material.dart';
import 'package:project_test/event.dart';

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
            if (widget.event.image)
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  "assets/img_example.jpeg",
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
                      child: Row(children: [
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
                    const VerticalDivider(
                      width: 20,
                      indent: 5,
                      endIndent: 5,
                      color: Colors.white,
                    ),
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
            if (widget.event.owner != null)
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
                          widget.event.owner!,
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
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Chip(
                      label: const Text("Sports"),
                      backgroundColor: currentTheme.secondaryContainer,
                      side: BorderSide(color: currentTheme.secondary),
                      padding: const EdgeInsets.all(6),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Chip(
                      label: const Text("Cricket"),
                      backgroundColor: currentTheme.secondaryContainer,
                      side: BorderSide(color: currentTheme.secondary),
                      padding: const EdgeInsets.all(6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 6),
              child: Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: ActionChip(
                      label: const Text("Register Event"),
                      avatar: Icon(
                        Icons.link_rounded,
                        color: currentTheme.onSecondaryContainer,
                      ),
                      onPressed: () {},
                      backgroundColor: currentTheme.secondaryContainer,
                      side:
                          BorderSide(color: currentTheme.onSecondaryContainer),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: ActionChip(
                      label: const Text("Follow on Instagram"),
                      avatar: Icon(
                        Icons.link_rounded,
                        color: currentTheme.onSecondaryContainer,
                      ),
                      onPressed: () {},
                      backgroundColor: currentTheme.secondaryContainer,
                      side:
                          BorderSide(color: currentTheme.onSecondaryContainer),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: ActionChip(
                      label: const Text("Join WhatsApp Channel"),
                      avatar: Icon(
                        Icons.link_rounded,
                        color: currentTheme.onSecondaryContainer,
                      ),
                      onPressed: () {},
                      backgroundColor: currentTheme.secondaryContainer,
                      side:
                          BorderSide(color: currentTheme.onSecondaryContainer),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: const Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
