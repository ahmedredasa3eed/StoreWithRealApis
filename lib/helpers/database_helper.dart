import 'package:movies/models/cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';


class DbHelper {
  DbHelper.privateConstructor();
  static final DbHelper dbHelper = DbHelper.privateConstructor();
  Future <Database> _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'shoppingCart.db');
    final Future<Database> database = openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE cartItems (id TEXT, name TEXT, price REAL, image TEXT , quantity INTEGER)");
        });
    return database;
  }

  addCartItem(Cart cart) async {
    final db = await database;
    var row = await db.insert("cartItems", cart.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
    return row;
  }

  Future<List<Cart>> getAllCartItems() async {
    try{
      final db = await database;
      var result = await db.query('cartItems');
      List<Cart> list = result.map((e) => Cart.fromJson(e)).toList();
      return list;
    } catch (error){
      print(error);
    }


  }

  Future<bool> getCartItemWithId(String id) async {
    try{
      final db = await database;
      var result = await db.query("cartItems", where: "id=?", whereArgs: [id]);
      return result.isEmpty ? false : true;
    } catch (error){
      print(error);
    }

  }



  deleteCartItemWithId(String id )async{
    try{
      final db = await database;
      var result = db.delete("cartItems",where:"id=?",whereArgs:[id]);
      print('$id');
      print('$result');
      return result;
    } catch(error){
      print(error);
    }

  }
  deleteAllCartItems()async{
    final db = await database;
    db.delete("cartItems");
  }

  updateCartItem(Cart cart)async{
    try{
      final db = await database;
      var result = db.update("cartItems", cart.toMap(),where: "id=?",whereArgs: [cart.id]);
      print('$result');
      return result;
    } catch(error){
      print(error);
    }


  }
}
