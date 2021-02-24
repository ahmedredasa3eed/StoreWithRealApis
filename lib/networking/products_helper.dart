import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/exceptions.dart';
import 'package:movies/models/product.dart';
import 'package:movies/models/favorite.dart';

class ProductsHelper with ChangeNotifier{

  Future<List<Product>> fetchProductsByCategory(String id) async {
    try {
      final url = "http://tufahatin.com/mobile/main/get_products?category_id=$id";

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = json.decode(data);
        ProductList productList = ProductList.formJson(jsonData);
        List<Product> loadedProducts = productList.products.map((product) => Product.fromJson(product)).toList();
        notifyListeners();
        return loadedProducts;
      } else {
        print("Status Code = ${response.statusCode}");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<Favourite> fetchFavourite(String productId, String userId) async {
    final url = "http://tufahatin.com/mobile/global/add_favourite?user_id=$userId&id=$productId";
    final response = await http.get(url);
    if(response.statusCode == 200){
      String data = response.body;
      var jsonData = json.decode(data);

      if(jsonData['status'] == false){
        throw FetchDataException("error add to favourite");
      }

      Favourite favourite = Favourite.fromJson(jsonData);
      notifyListeners();
      return favourite;

    }
    else{
      print ("Response Code : ${response.statusCode}");
    }

  }

  Future<Product> fetchProductById(String productId) async {
    try {
      final url = "http://tufahatin.com/mobile/main/get_products?id=$productId";

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = json.decode(data);
        ProductList productList = ProductList.formJson(jsonData);
        List<Product> loadedProducts = productList.products.map((product) => Product.fromJson(product)).toList();
        notifyListeners();
        return loadedProducts.first;
      } else {
        print("Status Code = ${response.statusCode}");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<String> addToCart(String productId, String userId, int quantity ) async {

    try{
      final url = "http://tufahatin.com/mobile/main/add_cart?product_id=$productId&user_id=$userId&quantity=$quantity";
      final response = await http.get(url);
      if(response.statusCode == 200){
        if(response.body.isNotEmpty){
          String data = response.body;
          var jsonData = json.decode(data);
          if(jsonData['status']){
            return jsonData['message'];
          }
        }
      }
      else{
        print("Status Code : ${response.statusCode}");
      }
    }catch(error){
      throw error;
    }

  }

  Future<List<Product>>fetchFavouriteProucts(String userId) async {
    try {
      final url = "http://tufahatin.com/mobile/global/get_favourite?user_id=$userId";

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = json.decode(data);
        ProductList productList = ProductList.formJson(jsonData);
        List<Product> loadedProducts = productList.products.map((product) => Product.fromJson(product)).toList();
        notifyListeners();
        return loadedProducts;
      } else {
        print("Status Code = ${response.statusCode}");
      }
    } catch (error) {
      print(error);
    }
  }


}
