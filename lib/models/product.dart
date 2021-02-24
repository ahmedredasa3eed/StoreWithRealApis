
class Product{
  String id;
  String name;
  String description;
  String image;
  String price;
  String categoryId;
  bool favourite;

  Product({this.id, this.name, this.description, this.image, this.price,
    this.categoryId, this.favourite = false});

  factory Product.fromJson(Map<String,dynamic> jsonData){
    return Product(
      id: jsonData['id'],
      name: jsonData['name'],
      description: jsonData['description'],
      image: jsonData['image'],
      price: jsonData['price'],
      categoryId: jsonData['category_id'],
      favourite: jsonData['favourite'],
    );
  }
}

class ProductList{
   List<dynamic> products;

  ProductList({this.products});

  factory ProductList.formJson(Map<String,dynamic> jsonData){
    return ProductList(
      products : jsonData['products'],
    );
  }
}