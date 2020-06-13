import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

//class to make connection to the mysql database
class Mysql {
  //declare connection-settings
  static String host,
      user = 'tijl',
      password = 'p1zz4d00s',
      db = 'Activity_db';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    host = prefs.getString('ipAddress'); //host gets pulled from shared preferences
    var settings = new ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db
    );
    return await MySqlConnection.connect(settings);
  }
}