import 'package:activitiesshedule/ui/schedule.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(new MaterialApp(
    home: new Schedule(),
  ));
}

//converts Hexcolors to Color-type
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
