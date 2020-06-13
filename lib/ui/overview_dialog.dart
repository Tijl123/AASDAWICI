import 'package:activitiesshedule/data/mysql_database.dart';
import 'package:activitiesshedule/data/sqlite_database.dart';
import 'package:activitiesshedule/main.dart';
import 'package:activitiesshedule/models/activity_model.dart';
import 'package:flutter/material.dart';

class OverviewDialog extends StatefulWidget {
  @override
  _OverviewDialogState createState() =>
      _OverviewDialogState();
}

class _OverviewDialogState extends State<OverviewDialog> {
  var db = new Mysql();
  List<String> users = new List();
  String selectedUser;

  void initState() {
    super.initState();

    //request all users from mysql database
    db.getConnection().then((conn) {
      String sql = 'SELECT * FROM overview_usera';
      conn.query(sql).then((results) {
        //for every row returned take the third value(username) and put it in the userslist
        for (var row in results) {
          setState(() {
            users.add(row[2].toString());
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime startOfDay = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
    DateTime endOfDay = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59);
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: HexColor('#06B200')
                    .withOpacity(0.6),
                offset: const Offset(1.1, 4.0),
                blurRadius: 8.0),
          ],
          gradient: LinearGradient(
            colors: <HexColor>[
              HexColor('#7BC17E'),
              HexColor('#06B200'),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 50, bottom: 12, right: 20, left: 20),
            child: StreamBuilder(
              stream:
              //get all the activities from the current day
              Stream.periodic(Duration(seconds: 1))
                  .asyncMap((i) => DBProvider.db.getAllActivitiesWhereDate(startOfDay,endOfDay)),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Activity>> snapshot) {
                if (snapshot.hasData) {
                  //gridview showing participation(smileys) of current day activities
                  return GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(
                        snapshot.data.length, (index) {
                      String imgString;
                      //declares imgString for every activity depending on if the user participated in it
                      snapshot.data[index].isComplete == 1
                          ? imgString = 'assets/smileys/happy.png' : imgString = 'assets/smileys/sad.png';
                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(imgString),
                      );
                    }),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator());
                }
              },
            ),
          ),
          //close button at top right corner of dialog box
          Positioned(
              top: 0.0,
              right: 0.0,
              child: CloseButton())
        ]),
      ),
    );
  }
}