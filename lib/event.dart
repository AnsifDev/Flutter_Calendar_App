class Event {
  late String _title;
  late bool _image;
  late DateTime _dateTime;
  late String? _owner;

  bool get image {
    return _image;
  }

  String get title {
    return _title;
  }

  DateTime get dateTime {
    return _dateTime;
  }

  String? get owner {
    return _owner;
  }

  bool isOwner() {
    return _owner == null;
  }

  Event(
      {required String title,
      required DateTime dateTime,
      bool image = false,
      String? owner}) {
    _title = title;
    _image = image;
    _dateTime = dateTime;
    _owner = owner;
  }
}
