import 'package:activitiesshedule/data/sqlite_database.dart';
import 'package:activitiesshedule/models/activity_model.dart';
import 'package:activitiesshedule/ui/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ActivitiesListView extends StatefulWidget {
  const ActivitiesListView({Key key, this.dateOfWeek}) : super(key: key);

  final DateTime dateOfWeek;

  @override
  _ActivitiesListViewState createState() => _ActivitiesListViewState();
}

class _ActivitiesListViewState extends State<ActivitiesListView> {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _positionListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 302, //height is height of the screen minus the height of the tab bar(220) and minus 82
      width: MediaQuery.of(context).size.width, //width is equal to the width of the screen
      child: StreamBuilder(
        stream: Stream.periodic(Duration(seconds: 1)).asyncMap((i) =>
            DBProvider.db.getAllActivitiesWhereDate(widget.dateOfWeek, widget.dateOfWeek.add(new Duration(days: 1)))),
        builder:
            (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
          if (snapshot.hasData) {
            int initialIndex = 0;
            bool stop = false;
            //looks up what the current activity is and put it as initial index in the listview
            //gives the right colorschemes to all the activities of the selected day and updates it in the local database
            for (var i = 0; i < snapshot.data.length; i++) {
              if (snapshot.data[i].endTime > DateTime.now().millisecondsSinceEpoch
                  && stop == false
                  && widget.dateOfWeek.day == DateTime.now().day) {
                initialIndex = i;
                snapshot.data[i].startColor = '#7BC17E';
                snapshot.data[i].endColor = '#06B200';
                DBProvider.db.updateActivity(snapshot.data[i]);
                stop = true;
              } else if (stop == false && widget.dateOfWeek.day <= DateTime.now().day) {
                snapshot.data[i].startColor = '#738AE6';
                snapshot.data[i].endColor = '#5C5EDD';
                DBProvider.db.updateActivity(snapshot.data[i]);
              }
            }
            //listview with all the activities
            return ScrollablePositionedList.builder(
                padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
                itemScrollController: _scrollController,
                itemPositionsListener: _positionListener,
                initialScrollIndex: initialIndex,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ActivitiesView(activityData: snapshot.data[index],);
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}