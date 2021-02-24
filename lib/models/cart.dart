
class Cart{
  String id;
  String name;
  String image;
  double price;
  int quantity;


  Cart({this.id, this.name, this.image, this.price, this.quantity});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'image': image, 'price': price, 'quantity':quantity};

  factory Cart.fromJson(Map<String,dynamic> jsonData){
    return Cart(
      id: jsonData['id'],
      name: jsonData['name'],
      image: jsonData['image'],
      price: jsonData['price'],
      quantity: jsonData['quantity'],
    );
  }
}
