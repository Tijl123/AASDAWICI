class Activity {
  Activity({this.id, this.mysqlId, this.startTime, this.endTime, this.isComplete, this.activityImage, this.startColor, this.endColor});

  int id;
  int mysqlId;
  int startTime;
  int endTime;
  int isComplete;
  String activityImage;
  String startColor;
  String endColor;


  factory Activity.fromMap(Map<String, dynamic> json) => new Activity(
      id: json["id"],
      mysqlId: json["mysqlId"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      activityImage: json["activityImage"],
      startColor: json["startColor"],
      endColor: json["endColor"],
      isComplete: json["isComplete"]
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mysqlId': mysqlId,
      'startTime': startTime,
      'endTime': endTime,
      'activityImage': activityImage,
      'startColor': startColor,
      'endColor': endColor,
      'isComplete': isComplete
    };
  }

}
