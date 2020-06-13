import 'package:activitiesshedule/data/mysql_database.dart';
import 'package:activitiesshedule/ui/user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widget to confirm the ip address of the database server
class InitializationDialog extends StatefulWidget {
  @override
  _InitializationDialogState createState() => _InitializationDialogState();
}

class _InitializationDialogState extends State<InitializationDialog> {
  TextEditingController ipAddressController = new TextEditingController();
  var db = new Mysql();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('инициализация'),
      contentPadding: EdgeInsets.only(top: 10, left: 25, right: 25),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: SingleChildScrollView(
          child: Column(children: <Widget>[
              Text('Введите ip-адрес с сервера базы данных: '),
              TextField(
                controller: ipAddressController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Введите ip-адрес'),
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              //inserts ip address of the database in shared preferences
              prefs.setString('ipAddress', ipAddressController.text);
              //checks whether the given ip address is correct
              db.getConnection().then((conn) {
                //close dialog
                Navigator.of(context).pop();
                //opens dialog to select user
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UserDialog();
                  },
                );
                //reopens the dialog if the given ip address is not correct
              }).catchError((e) {
                //close dialog
                Navigator.of(context).pop();
                //opens dialog to select user
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return InitializationDialog();
                  },
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
