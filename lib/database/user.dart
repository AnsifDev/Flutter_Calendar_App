import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_test/database/database_connector.dart';


class UsersDatabase extends DatabaseConnector<User> {
  UsersDatabase._():super("UsersPublic");

  @override
  User parseMap(Map map) => User.fromMap(map);

  @override
  Future<User?> delete(String id) async {
    if (id !=(await CurrentUser.instance).id) return null;
    return await super.delete(id);
  }

  static UsersDatabase? _instance;
  static UsersDatabase get instance {
    _instance ??= UsersDatabase._();
    return _instance!;
  }
}

class User extends DataObject {
  late final List<String> followingEvents;

  User({required super.id, List<String>? followingEvents}) {
    this.followingEvents = followingEvents ?? List<String>.empty(growable: true);
  }

  @override
  Map toMap() {
    return {
      'id': id,
      'followingEvents': followingEvents
    };
  }

  User.fromMap(Map map): this(
    id: map['id'],
    followingEvents: map['followingEvents'] == null? null:
      List<String>.generate(map['followingEvents'].length, (index) => map['followingEvents'][index] as String)
  );
}

class CurrentUser extends User {
  final events = List<String>.empty(growable: true);
  CurrentUser._({required super.id, required Map map}): super(
      followingEvents: map['followingEvents'] == null? null:
        List<String>.generate(map['followingEvents'].length, (index) => map['followingEvents'][index] as String));

  Future<bool> save() async {
    await FirebaseDatabase.instance.ref("Users/$id/Events").set(events);
    return await UsersDatabase.instance.save(this);
  }

  Future<User?> delete() async {
    await FirebaseDatabase.instance.ref("Users/$id/Events").remove();
    return await UsersDatabase.instance.delete(id);
  }

  static CurrentUser? _instance;
  static Future<CurrentUser> get instance async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if (_instance == null || _instance!.id != uid) {
      _instance = CurrentUser._(
          id: uid,
          map: (await UsersDatabase.instance.get(uid))?.toMap() ?? {}
      );
      var s = "Users/${_instance!.id}/Events";
      var snapshots = await FirebaseDatabase.instance.ref("Users/${_instance!.id}/Events").get();
      for(var snapshot in snapshots.children) {
        _instance!.events.add(snapshot.value as String);
      }
    }


    return _instance!;
  }
}