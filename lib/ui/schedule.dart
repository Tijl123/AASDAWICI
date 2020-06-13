import 'dart:async';

import 'package:activitiesshedule/data/mysql_database.dart';
import 'package:activitiesshedule/data/sqlite_database.dart';
import 'package:activitiesshedule/models/activity_model.dart';
import 'package:activitiesshedule/ui/activity_list.dart';
import 'package:activitiesshedule/ui/initialization_dialog.dart';
import 'package:activitiesshedule/ui/overview_dialog.dart';
import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> with TickerProviderStateMixin {
  //list of days in Russian
  List<String> days = [
    'понедельник',
    'вторник',
    'среда',
    'Четверг',
    'пятница',
    'суббота',
    'Воскресенье'
  ];

  //icons linked to the weekdays
  List<Icon> icons = [
    Icon(Icons.brightness_3),
    Icon(Icons.school),
    Icon(Icons.star),
    Icon(Icons.lightbulb_outline),
    Icon(Icons.free_breakfast),
    Icon(Icons.weekend),
    Icon(Icons.brightness_7)
  ];

  List<DateTime> datesOfWeek = new List(7);
  TabController _tabController;
  Timer timer;

  @override
  void initState() {
    super.initState();

    //set settings of tab bar
    _tabController = new TabController(
        initialIndex: DateTime.now().weekday - 1, //selects the current day in the tab bar
        vsync: this,
        length: days.length //size of tab bar is equal to the amount of weekdays
    );

    //set variables to the current weekday, day, month and year
    int weekday = DateTime.now().weekday - 1;
    int day = DateTime.now().day;
    int month = DateTime.now().month;
    int year = DateTime.now().year;

    //loop to get the past days of the current week, gets current day in first loop
    while(weekday >= 0){
      if(day < 1){
        //if the previous day is of the past month, get the last day of last month
        var dateUtility = DateUtil();
        day = dateUtility.daysInMonth(DateTime.now().month - 1, DateTime.now().year);

        if(month == 1){
          //if previous month is of past year, set month to December and set year to the past year
          month = 12;
          year--;
        }
        else{
          //else set month to the past month
          month = DateTime.now().month - 1;
        }
      }
      //put full day at the right spot in the array
      datesOfWeek[weekday] = new DateTime(year, month, day);

      //go to previous day
      day--;
      weekday--;
    }

    //reset variables to the current weekday, day, month and year
    weekday = DateTime.now().weekday - 1;
    day = DateTime.now().day;
    month = DateTime.now().month;
    year = DateTime.now().year;

    //loop to get the future days of the current week
    while(weekday < 7){
      //get the last day of the current month
      var dateUtility = DateUtil();
      int maxDays = dateUtility.daysInMonth(DateTime.now().month, DateTime.now().year);

      if(day > maxDays){
        //if next day is of the next month, set day to 1
        day = 1;
        if(month == 12){
          //if next day is a new year, set month to 1 and set year to next year
          month = 1;
          year++;
        }
        else{
          //else set month to next month
          month = DateTime.now().month + 1;
        }
      }
      //put full day at the right spot in the array
      datesOfWeek[weekday] = new DateTime(year, month, day);

      //go to next day
      day++;
      weekday++;
    }

    //fetch activities every 60 seconds
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => checkForNewActivities());
  }

  void checkForNewActivities() async {
    var db = new Mysql();
    List<Activity> activities = new List();

    //requests all activities for the current user of this week from the mysql database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId');
    if(userId != null) {
      db.getConnection().then((conn) async {
        conn.query(
            'SELECT * FROM overview_activity WHERE userID_id = ?', [userId])
            .then((results) {
          //store every activity from the mysql database in the local database
          for (var row in results) {
            Activity activity = new Activity();
            DateTime startTime;
            DateTime endTime;
            activity.startColor = '#FF6464';
            activity.endColor = '#FF1B1B';
            activity.mysqlId = row[0];
            startTime = row[3];
            endTime = row[4];
            activity.startTime = startTime.millisecondsSinceEpoch;
            activity.endTime = endTime.millisecondsSinceEpoch;
            activity.activityImage = row[5].toString();
            activity.isComplete = row[6];
            activities.add(activity);
          }
          if(activities != null){
            DBProvider.db.deleteAll();
            activities.forEach((activity)  {
              DBProvider.db.insertActivity(activity);
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //builds custom tabmenu with days of the week
  @override
  Widget build(BuildContext context) {
    //disable landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    //shows a dialog if the app is used for the first time
    Future.delayed(Duration.zero, () => showDialogIfFirstUse(context));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(220.0), //sets height of tabbar
        child: AppBar(
          automaticallyImplyLeading: false, // hides leading widget and title becomes leading widget
          flexibleSpace:
            Column(children: <Widget>[
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 30),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return OverviewDialog();
                            });
                      });
                    },
                    //image that opens dialog box when tapped
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/smileys/happy.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10, left: 105),
                  child: FlutterAnalogClock(
                    dateTime: DateTime.now(),
                    isLive: true,
                    width: 130.0,
                    height: 130.0,
                  ),
                ),
              ]),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                //list of all tabs
                tabs: [
                  Tab(text: days[0], icon: icons[0]),
                  Tab(text: days[1], icon: icons[1]),
                  Tab(text: days[2], icon: icons[2]),
                  Tab(text: days[3], icon: icons[3]),
                  Tab(text: days[4], icon: icons[4]),
                  Tab(text: days[5], icon: icons[5]),
                  Tab(text: days[6], icon: icons[6]),
                ],
              ),
            ]),
          title: GestureDetector(
            onTap: () {
              setState(() {
                _tabController.animateTo(DateTime.now().weekday - 1); //go to the tab of the current day when tapping it
              });
            },
            child: Column(
              //set current day + icon as title
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                ),
                icons.elementAt(DateTime.now().weekday - 1),
                Text(days.elementAt(DateTime.now().weekday - 1)),
              ],
            ),
          ),
        ),
      ),
      //shows activities of the selected day
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TabBarView(
          controller: _tabController,
          //list of views for every day
          children: [
            ActivitiesListView(dateOfWeek: datesOfWeek[0]),
            ActivitiesListView(dateOfWeek: datesOfWeek[1]),
            ActivitiesListView(dateOfWeek: datesOfWeek[2]),
            ActivitiesListView(dateOfWeek: datesOfWeek[3]),
            ActivitiesListView(dateOfWeek: datesOfWeek[4]),
            ActivitiesListView(dateOfWeek: datesOfWeek[5]),
            ActivitiesListView(dateOfWeek: datesOfWeek[6]),
          ],
        ),
      ),
    );
  }

  //shows dialog as long as there is no ip address and user selected
  showDialogIfFirstUse(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstUse = prefs.getBool('firstUse');
    if (isFirstUse == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InitializationDialog();
        },
      );
    }
  }
}
