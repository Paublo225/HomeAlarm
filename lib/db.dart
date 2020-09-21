import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'model/trigger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';

class DatabaseProvider {
  static const String TRIG_TABLE = "trig";
  static const String COLUMN_ID = "id";
  static const String NAME = "name";
  static const String HOUR = "hour";
  static const String MINUTE = "minute";
  static const String ISENABLED = "isEnabled";
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> change() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(join(dbPath, 'alarmApp.db'), version: 1,
        onConfigure: (Database database) async {
      print("update $TRIG_TABLE");

      await database.execute("UPDATE $TRIG_TABLE"
          "SET $ISENABLED = 0"
          "WHERE $COLUMN_ID = 1;");
    });
  }

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'alarmApp.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating trigger table");

        await database.execute(
          "CREATE TABLE $TRIG_TABLE ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$NAME STRING,"
          "$HOUR INTEGER,"
          "$MINUTE INTEGER,"
          "$ISENABLED INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<Trigger>> getTrig() async {
    final db = await database;

    var trigger = await db
        .query(TRIG_TABLE, columns: [COLUMN_ID, NAME, HOUR, MINUTE, ISENABLED]);

    List<Trigger> triggerList = List<Trigger>();

    trigger.forEach((currentTrig) {
      Trigger tr = Trigger.fromMap(currentTrig);

      triggerList.add(tr);
    });

    return triggerList;
  }

  Future<int> getCount(int count) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $TRIG_TABLE');
    int result = Sqflite.firstIntValue(x);

    count = result;

    return count;
  }

  disorenable(Trigger tr) async {
    final db = await database;
    print("changed");
    Trigger isEnabled = Trigger(
        name: tr.name,
        hour: tr.hour,
        minute: tr.minute,
        isEnabled: tr.isEnabled);
    var res = await db.update(
      TRIG_TABLE,
      isEnabled.toMap(),
      where: "id = ?",
      whereArgs: [tr.id],
    );
    return res;
  }

  Future<Trigger> insert(Trigger tr) async {
    final db = await database;
    tr.id = await db.insert(TRIG_TABLE, tr.toMap());
    return tr;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TRIG_TABLE,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Trigger tr) async {
    final db = await database;

    var result = await db.update(
      TRIG_TABLE,
      tr.toMap(),
      where: "id = ?",
      whereArgs: [tr.id],
    );
    return result;
  }
}
