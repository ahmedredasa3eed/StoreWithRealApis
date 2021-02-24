class Sliders{
  String url;

  Sliders({this.url});

  factory Sliders.fromJson(Map<String,dynamic> jsonData){
    return Sliders(
      url : jsonData['sliders']["url"],
    );
  }
}