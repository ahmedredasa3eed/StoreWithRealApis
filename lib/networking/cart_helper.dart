import 'package:flutter/material.dart';
import 'package:movies/helpers/database_helper.dart';
import 'package:movies/models/cart.dart';

class CartProvider with ChangeNotifier {

  List<Cart> _cartItems = [];

  List<Cart> get cartItems{
    return _cartItems;
  }

  Future<List<Cart>> getAllCartItems() async {
    final items =  await DbHelper.dbHelper.getAllCartItems();
    _cartItems = items;
    print("Cart Items : $_cartItems");
    notifyListeners();
    return items;
  }

    Future<void>deleteCartItemWithId(String id) async {
    await DbHelper.dbHelper.deleteCartItemWithId(id);
    notifyListeners();
  }

  double getTotalPrice() {
    try{
      var totalPrice = 0.0;
      final items =  _cartItems;
      for(var i in items){
        totalPrice += i.price * i.quantity;
        print("Total Price: $totalPrice");
        if(totalPrice == null) return 0.0;
        return totalPrice;
    }
    } catch(error){
      print(error);
    }
  }






}
