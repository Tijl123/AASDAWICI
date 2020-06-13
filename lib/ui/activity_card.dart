import 'package:activitiesshedule/data/mysql_database.dart';
import 'package:activitiesshedule/data/sqlite_database.dart';
import 'package:activitiesshedule/main.dart';
import 'package:activitiesshedule/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';

class ActivitiesView extends StatefulWidget {
  const ActivitiesView({Key key, this.activityData}) : super(key: key);

  final Activity activityData;

  @override
  _ActivitiesViewState createState() => _ActivitiesViewState();
}

class _ActivitiesViewState extends State<ActivitiesView> {
  @override
  Widget build(BuildContext context) {
    String imgString;
    widget.activityData.isComplete == 1
        ? imgString = 'assets/smileys/happy.png' : imgString = 'assets/smileys/sad.png';
    return SizedBox(
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
            //layout of the card itself
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: HexColor(this.widget.activityData.endColor)
                          .withOpacity(0.6),
                      offset: const Offset(1.1, 4.0),
                      blurRadius: 8.0),
                ],
                gradient: LinearGradient(
                  colors: <HexColor>[
                    HexColor(this.widget.activityData.startColor),
                    HexColor(this.widget.activityData.endColor),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 55, bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //image of the activity
                    SizedBox(
                      height: 210,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child:
                            Image.asset(this.widget.activityData.activityImage),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      //check-off button(smiley) of the activity
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            //makes sure you can only check-off the activity between 10 minutes before the activity and 10 minutes after the activity
                            if (this.widget.activityData.endTime >
                                    DateTime.now().millisecondsSinceEpoch -
                                        600000 &&
                                this.widget.activityData.startTime <
                                    DateTime.now().millisecondsSinceEpoch +
                                        600000) {
                              this.widget.activityData.isComplete = 1;
                              //update activity in local database
                              DBProvider.db
                                  .updateActivity(this.widget.activityData);
                              //update activity in mysql database
                              var db = new Mysql();
                              db.getConnection().then((conn) {
                                String sql = "UPDATE overview_activity SET isComplete = 1 WHERE id = " + this.widget.activityData.mysqlId.toString();
                                conn.query(sql);
                              });
                            }
                          });
                        },
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(imgString),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //analog clock with start time of the activity (top left)
          Positioned(
            top: 0,
            left: 0,
            child: FlutterAnalogClock(
              dateTime: DateTime.fromMillisecondsSinceEpoch(
                  this.widget.activityData.startTime),
              dialPlateColor: Colors.greenAccent.shade700,
              showSecondHand: false,
              isLive: false,
              width: 80.0,
              height: 80.0,
            ),
          ),
          //analog clock with end time of the activity (top right)
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width - 115,
            child: FlutterAnalogClock(
              dateTime: DateTime.fromMillisecondsSinceEpoch(
                  this.widget.activityData.endTime),
              dialPlateColor: Colors.red,
              showSecondHand: false,
              isLive: false,
              width: 80.0,
              height: 80.0,
            ),
          )
        ],
      ),
    );
  }
}
