class Event {
  late String title;
  late DateTime dateTime;
  String? description;
  String? location;
  String? image;
  Channel? channel;
  List<String> tags = List.empty(growable: true);
  List<EventLink> links = List.empty(growable: true);

  Event(
      {String? title,
      DateTime? dateTime,
      this.description,
      this.channel,
      this.image,
      this.location}) {
    if (title != null) this.title = title;
    this.dateTime = dateTime ?? DateTime.now();
  }
}

class Channel {
  late String title;
  late String description;

  Channel(this.title);
}

class EventLink {
  late String title;
  late String link;

  EventLink(this.title, this.link);
}
