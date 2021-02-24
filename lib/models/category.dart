
class Category {
  String id;
  String name;
  String image;

  Category({this.id, this.name, this.image});

  factory Category.fromJson(Map<String, dynamic> jsonData) {
    return Category(
      id: jsonData['id'],
      name: jsonData['name'],
      image: jsonData['image'],
    );
  }
}


