//this code is an alternative for the sqlite database, the code still needs some adjustments to be in a working condition

/*import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Moor works by source gen. This file will all the generated code.
part 'moor_database.g.dart';

List<Activity> testshedule = <Activity>[
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7, 30),
      activityImage: 'assets/activities/morning_rise.jpg',
      activity: 'Breakfast',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7, 30),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 30),
      activityImage: 'assets/activities/clean_room.jpg',
      activity: 'Lunch',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 30),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
      activityImage: 'assets/activities/breakfast.jpg',
      activity: 'Snack',
      //startColor: '#FE95B6',
      //endColor: '#FF5287',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
      activityImage: 'assets/activities/leisure_activities.jpg',
      activity: 'Dinner',
      //startColor: '#6F72CA',
      //endColor: '#1E1466',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 30),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13),
      activityImage: 'assets/activities/dinner.jpg',
      activity: 'Breakfast',
      //startColor: '#FA7D82',
      //endColor: '#FFB295',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 15),
      activityImage: 'assets/activities/daytime_sleep.jpg',
      activity: 'Lunch',
      //startColor: '#738AE6',
      //endColor: '#5C5EDD',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 15),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 15, 30),
      activityImage: 'assets/activities/afternoon_snack.jpg',
      activity: 'Snack',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 15, 30),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17),
      activityImage: 'assets/activities/leisure_activities.jpg',
      activity: 'Dinner',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17, 30),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18),
      activityImage: 'assets/activities/supper.jpg',
      activity: 'Dinner',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 30),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 22),
      activityImage: 'assets/activities/free_time.jpg',
      activity: 'Breakfast',
      smiley: 'assets/smileys/sad.png'
  ),
  Activity(
      startTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 22),
      endTime: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 22, 30),
      activityImage: 'assets/activities/sleep.jpg',
      activity: 'Lunch',
      smiley: 'assets/smileys/sad.png'
  ),
];

@DataClassName('Activity')
class Activities extends Table {
  // autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get activity => text()();
  TextColumn get activityImage => text()();
  DateTimeColumn get startTime => dateTime().nullable()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get smiley => text()();
// Booleans are not supported as well, Moor converts them to integers
// Simple default values are specified as Constants
//BoolColumn get completed => boolean().withDefault(Constant(false))();
}

// This annotation tells the code generator which tables this DB works with
@UseMoor(tables: [Activities], daos: [ActivityDao])
// _$AppDatabase is the name of the generated class
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  final dao = Provider.of<ActivityDao>(context);
  // Bump this when changing tables and columns.
  // Migrations will be covered in the next part.
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseDao(tables: [Activities])
class ActivityDao extends DatabaseAccessor<AppDatabase> with _$ActivityDaoMixin {
  final AppDatabase db;
  // Called by the AppDatabase class
  ActivityDao(this.db) : super(db);

  Future<List<Activity>> getAllActivities() => select(activities).get();
  Stream<List<Activity>> watchAllActivities() => select(activities).watch();
  Future insertActivity(Insertable<Activity> activity) => into(activities).insert(activity);
  Future updateActivity(Insertable<Activity> activity) => update(activities).replace(activity);
  Future deleteActivity(Insertable<Activity> activity) => delete(activities).delete(activity);

}*/