class Like {
  int nameId;
  bool wasShownMatch;

  Like({this.nameId, this.wasShownMatch});

  Map<String, dynamic> toJson() =>
      {
        'nameId': nameId,
        'wasShown': wasShownMatch
      };

  Like.fromJson(Map<String, dynamic> json) {
    nameId = json['nameId'];
    wasShownMatch = json['wasShown'];
  }
}
