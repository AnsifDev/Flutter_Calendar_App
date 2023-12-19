import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_test/database/channel.dart';
import 'package:project_test/database/database_connector.dart';
import 'package:project_test/database/user.dart';

class EventsDatabase extends DatabaseConnector<Event> {
  EventsDatabase._(): super("Events");

  @override
  Event parseMap(Map<dynamic, dynamic> map) => Event.fromMap(map);

  @override
  Future<bool> save(Event dataObject) async {
    if (dataObject.channel == null) {
      var user = await CurrentUser.instance;
      user.events.add(dataObject.id);
      user.save();
    } else {
      var channel = await ChannelsDatabase.instance.get(dataObject.channel!);
      if (channel == null) return false;
      channel.events.add(dataObject.id);
      ChannelsDatabase.instance.save(channel);
    }
    return await super.save(dataObject);
  }

  @override
  Future<Event?> delete(String id) async {
    var event = await super.delete(id);
    if (event == null) return null;
    if (event.imageUrl != null) await FirebaseStorage.instance.ref("EventImages/$id").delete();
    if (event.channel == null) {
      var user = await CurrentUser.instance;
      user.events.remove(id);
      user.save();
      await FirebaseDatabase.instance.ref('Users/${FirebaseAuth.instance.currentUser!.uid}/Events/$id').remove();
    } else {
      var channel = await ChannelsDatabase.instance.get(event.channel!);
      if (channel == null) return event;
      channel.events.remove(id);
      ChannelsDatabase.instance.save(channel);
    }
    return event;
  }

  static EventsDatabase? _instance;
  static EventsDatabase get instance {
    _instance ??= EventsDatabase._();
    return _instance!;
  }
}

class Event extends DataObject {
  late String title;
  late DateTime dateTime;
  String? description;
  String? location;
  String? imageUrl;
  String? channel;
  late final List<String> tags;
  late final List<EventLink> links;

  Event({
    String? title,
    DateTime? dateTime,
    this.description,
    this.location,
    this.imageUrl,
    this.channel,
    List<String>? tags,
    List<EventLink>? links,
    required super.id
  }) {
    this.title = title ?? "";
    this.dateTime = dateTime ?? DateTime.now();
    this.tags = tags ?? List.empty(growable: true);
    this.links = links ?? List.empty(growable: true);
  }

  Event.fromMap(Map map) : this(
        title:  map['name'],
        description:  map['description'],
        location:  map['location'],
        dateTime:  DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
        tags: map['tags'] == null? null: List<String>.generate(map['tags'].length, (index) => map['tags'][index] as String),
        links: map['links'] == null? null: List<EventLink>.generate(map['links'].length, (index) => EventLink.fromMap(map['links'][index] as Map)),
        imageUrl: map['imageUrl'],
        channel: map['channel'],
        id: map['id']
    );

  @override
  Map toMap() {
    return {
      'name': title,
      'description': description,
      'location': location,
      'tags': tags,
      'links': List<Map>.generate(links.length, (i) => links[i].toMap()),
      'dateTime': dateTime.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
      'channel': channel,
      'id': id
    };
  }
}

class EventLink {
  late String title;
  late String link;

  EventLink(this.title, this.link);

  EventLink.fromMap(Map map): this(map['title'], map['address']);

  Map toMap() {
    return {
      'address': link,
      'title': title
    };
  }
}
