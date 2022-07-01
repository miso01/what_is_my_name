class Connection {
  int dateCreated;
  String firstUserId;
  String secondUserId;

  Connection({this.dateCreated, this.firstUserId, this.secondUserId});

  Map<String, dynamic> toJson() => {
        'dateCreated': dateCreated,
        'firstUserId': firstUserId,
        'secondUserId': secondUserId,
      };

  Connection.fromJson(Map<String, dynamic> json) {
    dateCreated = json['dateCreated'];
    firstUserId = json['firstUserId'];
    secondUserId = json['secondUserId'];
  }
}
