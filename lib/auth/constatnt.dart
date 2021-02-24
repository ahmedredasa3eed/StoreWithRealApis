import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constant{

  static String token;
  static String userId;

  void getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  void getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('userId');
  }

}