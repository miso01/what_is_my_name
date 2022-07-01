class Advertisement {
  String imageUrl;
  String webUrl;
  bool isSvg;

  Advertisement({this.imageUrl, this.webUrl, this.isSvg});

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'webUrl': webUrl,
        'isSvg': isSvg,
      };

  Advertisement.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    webUrl = json['webUrl'];
    isSvg = json['isSvg'];
  }
}
