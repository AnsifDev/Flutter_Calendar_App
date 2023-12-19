import 'package:project_test/database/database_connector.dart';

class ChannelsDatabase extends DatabaseConnector<Channel> {
  ChannelsDatabase._(): super("Channels");

  @override
  Channel parseMap(Map<dynamic, dynamic> map) => Channel.fromMap(map);

  static ChannelsDatabase? _instance;
  static ChannelsDatabase get instance {
    _instance ??= ChannelsDatabase._();
    return _instance!;
  }
}

class Channel extends DataObject {
  late String title;
  String? description;
  late final List<String> followers;
  late final List<String> events;
  late final List<String> admins;

  Channel({
    String? title,
    this.description,
    List<String>? followers,
    List<String>? events,
    List<String>? admins,
    required super.id
  }) {
    if (title != null) this.title = title;
    this.followers = followers ?? List<String>.empty(growable: true);
    this.events = events ?? List<String>.empty(growable: true);
    this.admins = admins ?? List<String>.empty(growable: true);
  }

  @override
  Map toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'followers': followers,
      'events': events,
      'admins': admins,
    };
  }

  Channel.fromMap(Map map): this(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      followers: map['followers'] == null? null: List<String>.generate(map['followers'].length, (index) => map['followers'][index] as String),
      events: map['events'] == null? null: List<String>.generate(map['events'].length, (index) => map['events'][index] as String),
      admins: map['admins'] == null? null: List<String>.generate(map['admins'].length, (index) => map['admins'][index] as String),
    );
}
