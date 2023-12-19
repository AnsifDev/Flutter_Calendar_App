import 'package:firebase_database/firebase_database.dart';

abstract class DatabaseConnector<T extends DataObject> {
  final DatabaseReference _database;
  final Map<String, T> _cache = {};

  DatabaseConnector(String databaseId):
        _database = FirebaseDatabase.instance.ref(databaseId);

  Future<List<T>> getAll() async {
    var snapshots = await _database.get();
    var events = List<T>.empty(growable: true);
    for (var snapshot in snapshots.children) {
      events.add(_cache[snapshot.key!] = parseMap(snapshot.value as Map));
    }

    return events;
  }

  Future<T?> get(String id) async {
    if (_cache.containsKey(id)) {
      return _cache[id]!;
    } else {
      var snapshot = await _database.child(id).get();
      if (!snapshot.exists) return null;
      return _cache[id] = parseMap(snapshot.value as Map);
    }
  }

  String getNewId() { return _database.push().key!; }

  Future<bool> save(T dataObject) async {
    await _database.child(dataObject.id).set(dataObject.toMap());
    _cache[dataObject.id] = dataObject;
    return true;
  }

  Future<T?> delete(String id) async {
    await _database.child(id).remove();
    return _cache.remove(id);
  }

  T parseMap(Map map);
}

abstract class DataObject {
  final String id;

  DataObject({ required this.id });

  DataObject.fromMap(Map map): this(id: map['id']);

  Map toMap();
}
