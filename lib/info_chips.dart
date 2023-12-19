import 'package:flutter/material.dart';

import 'main.dart';

class InfoChips extends StatelessWidget {
  final bool inline;
  final String? owner;
  final DateTime dateTime;
  final bool showTime;
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

  InfoChips({
    super.key,
    required this.currentTheme,
    this.inline = false,
    this.showTime = false,
    this.owner,
    required this.dateTime,
  });

  final ColorScheme currentTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (owner != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            constraints: BoxConstraints(maxWidth: inline ? 80 : 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: currentTheme.secondaryContainer,
            ),
            child: Text(
              "From $owner",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10, color: currentTheme.onSecondaryContainer),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(vertical: inline ? 0 : 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: currentTheme.tertiaryContainer,
          ),
          child: Text(
            showTime
                ? "Event at ${getFormattedTime(dateTime)}"
                : "on ${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}",
            style: TextStyle(
                fontSize: 10, color: currentTheme.onTertiaryContainer),
          ),
        ),
      ],
    );
  }
}
