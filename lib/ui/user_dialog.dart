import 'package:activitiesshedule/data/mysql_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDialog extends StatefulWidget {
  @override
  _UserDialogState createState() =>
      _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
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
    return AlertDialog(
      title: Text('инициализация'),
      contentPadding: EdgeInsets.only(top: 10, left: 25, right: 25),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: SingleChildScrollView(
          child: Column(children: <Widget>[
            Text('пользователь: '),
            DropdownButton(
              hint: Text('выберите пользователя'),
              value: selectedUser,
              //updates selected user when changed
              onChanged: (newValue) {
                setState(() {
                  selectedUser = newValue;
                });
              },
              items: users.map((String user) {
                return DropdownMenuItem<String>(
                  value: user,
                  child: Text(user),
                );
              }).toList(),
            ),
          ])
      ),
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.30,
          child: RaisedButton(
            child: Text(
              'подтверди',
              style: TextStyle(color: Colors.white),
            ),
            color: Color(0xFF121A21),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () async {
              //when confirmed the dialog will not show again
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('firstUse', false);
              //inserts user in shared preferences
              prefs.setInt('userId', users.indexOf(selectedUser) + 1);
              //close dialog
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}