class Name {
  int id;
  String name;
  String nameDay;
  String description;
  String gender;
  int likes;
  int dislikes;
  double rating;

  Name(
      {this.id,
      this.name,
      this.nameDay,
      this.description,
      this.gender,
      this.likes,
      this.dislikes,
      this.rating});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameDay': nameDay,
        'description': description,
        'gender': gender,
        'likes': likes,
        'dislikes': dislikes,
        'rating': rating.toDouble(),
      };

  Name.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameDay = json['nameDay'].toString();
    description = json['description'];
    gender = json['gender'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    rating = json['rating']?.toDouble();
  }
}
