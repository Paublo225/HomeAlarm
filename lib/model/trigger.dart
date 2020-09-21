import '../db.dart';

class Trigger {
  int id;
  String name;
  int weekdays;
  int hour;
  int minute;
  bool isEnabled;
  List<bool> listBoll = [true, true, true];
  Trigger(
      {this.id,
      this.name,
      this.weekdays,
      this.hour,
      this.minute,
      this.isEnabled,
      this.listBoll});

  List<bool> boool(bool shit) {
    listBoll.add(shit);
    return listBoll;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.NAME: name,
      DatabaseProvider.HOUR: hour,
      DatabaseProvider.MINUTE: minute,
      DatabaseProvider.ISENABLED: isEnabled ? 1 : 0
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Trigger.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.NAME];
    hour = map[DatabaseProvider.HOUR];
    minute = map[DatabaseProvider.MINUTE];
    isEnabled = map[DatabaseProvider.ISENABLED] == 1;
  }
}
