import 'package:flutter/material.dart';
import 'package:movies/auth/login_screen.dart';
import 'package:movies/auth/signup-screen.dart';
import 'package:movies/models/cart.dart';
import 'package:movies/networking/cart_helper.dart';
import 'package:movies/networking/category-helper.dart';
import 'package:movies/networking/products_helper.dart';
import 'package:movies/screens/favourite_screen.dart';
import 'package:movies/screens/home_screen.dart';
import 'package:movies/screens/product_details.dart';
import 'package:movies/screens/products-screen.dart';
import 'package:movies/screens/shopping_cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductsHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),

      ],
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
        routes: {
          LoginScreen.route: (context) => LoginScreen(),
          SignUpScreen.route: (context) => SignUpScreen(),
          HomeScreen.route: (context) => HomeScreen(),
          ProductsScreen.route: (context) => ProductsScreen(),
          ProductDetailsScreen.route: (context) => ProductDetailsScreen(),
          FavouriteScreen.route: (context) => FavouriteScreen(),
          ShoppingCartScreen.route: (context) => ShoppingCartScreen(),
        },
      ),
    );
  }
}

