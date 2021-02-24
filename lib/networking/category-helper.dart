import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/category.dart';
import 'package:movies/models/category_list.dart';
import 'package:movies/models/exceptions.dart';

class CategoryHelper with ChangeNotifier {

  Future <List<Category>> fetchCategories() async {
    try {
      final url = "http://tufahatin.com/mobile/main/get_category";

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = json.decode(data);

        CategoryList categoryList = CategoryList.fromJson(jsonData);
        List<Category> loadedCategories = categoryList.categories.map((e) => Category.fromJson(e)).toList();

        notifyListeners();
        return loadedCategories;
      }
      else{
        print("Status Code = ${response.statusCode}");
      }

    } on InternetException catch (error) {
      throw error;
    } catch (error){
      throw error;
    }
  }

}
