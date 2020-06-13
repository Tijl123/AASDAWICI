import 'dart:io';

import 'package:activitiesshedule/models/activity_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  //list with testdata
  List<Activity> testschedule = <Activity>[
    Activity(
      startTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 7)
          .millisecondsSinceEpoch,
      endTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 7, 30)
          .millisecondsSinceEpoch,
      isComplete: 1,
      activityImage: 'assets/activities/morning_rise.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 7, 30)
          .millisecondsSinceEpoch,
      endTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 8, 30)
          .millisecondsSinceEpoch,
      isComplete: 1,
      activityImage: 'assets/activities/clean_room.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 8, 30)
          .millisecondsSinceEpoch,
      endTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 9)
          .millisecondsSinceEpoch,
      isComplete: 1,
      activityImage: 'assets/activities/breakfast.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 10)
          .millisecondsSinceEpoch,
      endTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 12)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/leisure_activities.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 12, 30)
          .millisecondsSinceEpoch,
      endTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 13)
          .millisecondsSinceEpoch,
      isComplete: 1,
      activityImage: 'assets/activities/dinner.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 13)
          .millisecondsSinceEpoch,
      endTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 15)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/daytime_sleep.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 15)
          .millisecondsSinceEpoch,
      endTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 15, 30)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/afternoon_snack.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 15, 30)
          .millisecondsSinceEpoch,
      endTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 17)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/leisure_activities.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 17, 30)
          .millisecondsSinceEpoch,
      endTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 18)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/supper.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 18, 30)
          .millisecondsSinceEpoch,
      endTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 22)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/free_time.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day, 22)
          .millisecondsSinceEpoch,
      endTime: new DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 22, 30)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/sleep.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1, 22)
          .millisecondsSinceEpoch,
      endTime: new DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - 1, 22, 30)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/sleep.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
    Activity(
      startTime: new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 22)
          .millisecondsSinceEpoch,
      endTime: new DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day + 1, 22, 30)
          .millisecondsSinceEpoch,
      isComplete: 0,
      activityImage: 'assets/activities/sleep.jpg',
      startColor: '#FF6464',
      endColor: '#FF1B1B',
    ),
  ];

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  //initializes database
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ActivityDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE Activity(id INTEGER PRIMARY KEY, mysqlId INTEGER, startTime INTEGER, endTime INTEGER, isComplete INTEGER, activityImage TEXT, startColor TEXT, endColor TEXT)");
      testschedule.forEach((activity) async {
        await db.insert("Activity", activity.toMap());
      });
    });
  }

  //returns all activities
  Future<List<Activity>> getAllActivities() async {
    final db = await database;
    var res = await db.query("Activity", orderBy: "startTime");
    List<Activity> list =
        res.isNotEmpty ? res.map((c) => Activity.fromMap(c)).toList() : [];
    return list;
  }

  //returns all activities between two dates
  Future<List<Activity>> getAllActivitiesWhereDate(DateTime start, DateTime end) async {
    final db = await database;
    var res = await db.query("Activity", where: "startTime >= ? and startTime < ?",
        whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch], orderBy: "startTime");
    List<Activity> list =
    res.isNotEmpty ? res.map((c) => Activity.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> insertActivity(Activity activity) async {
    final db = await database;
    //get the highest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Activity");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into Activity (id,mysqlid,startTime,endTime,isComplete,activityImage,startColor,endColor)"
            " VALUES (?,?,?,?,?,?,?,?)",
        [id, activity.mysqlId, activity.startTime, activity.endTime, activity.isComplete, activity.activityImage, activity.startColor, activity.endColor]);
    return raw;
  }

  //update an activity
  updateActivity(Activity activity) async {
    final db = await database;
    var res = await db.update("Activity", activity.toMap(),
        where: "id = ?", whereArgs: [activity.id]);
    return res;
  }

  //delete all activities
  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Activity");
  }
}
