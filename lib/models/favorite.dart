class Favourite{

  bool favourite;
  String message;
  bool status;

  Favourite({this.favourite, this.message, this.status});

  factory Favourite.fromJson(Map<String,dynamic> jsonData){
    return Favourite(
      favourite: jsonData['favourite'],
      message: jsonData['message'],
      status: jsonData['status'],
    );
  }
}