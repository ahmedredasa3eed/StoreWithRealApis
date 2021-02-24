import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:movies/auth/login_screen.dart';
import 'package:movies/constants.dart';
import 'package:movies/models/exceptions.dart';
import 'package:movies/networking/category-helper.dart';
import 'package:movies/screens/favourite_screen.dart';
import 'package:movies/screens/products-screen.dart';
import 'package:movies/screens/shopping_cart_screen.dart';
import 'package:movies/widgets/slider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const route = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _showDialog(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("تنبيه"),
          content: Text(message),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("موافق")),
          ],
        );
      },
    );
  }

  var _internet = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnections();
  }

    checkInternetConnections() async{
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty && result[0].rawAddress.isEmpty) {
          _internet = false;
        }
      } on SocketException catch (_) {
        _internet = false;
        print('not connected');
      }
  }

  @override
  Widget build(BuildContext context) {

    final category = Provider.of<CategoryHelper>(context, listen: false);



    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.exit_to_app), onPressed: () async{
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.clear();
            Navigator.pushReplacementNamed(context, LoginScreen.route);
          }),
          title: Text("الرئيسية"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.pushNamed(context, FavouriteScreen.route);
              },
              icon: Icon(Icons.favorite_outlined),
            ),
            IconButton(
              onPressed: () async {
                Navigator.pushNamed(context, ShoppingCartScreen.route);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: !_internet ? Center(child: Text("الرجاء التحقق من اتصالك بام الانترنت .",style: TextStyle(fontSize:28),),) : Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(26)),
          ),
          child: Column(
            children: [
              ImageSlider(),
              Text(
                "الأقسام",
                style: kTitleStyle.copyWith(color: Colors.black),
              ),
              Text(
                "اختر القسم الذي تريده",
                style: kTitleStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
               FutureBuilder(
                future: category.fetchCategories(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      height: 500,
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ProductsScreen.route,arguments: [snapshot.data[index].id,snapshot.data[index].name]);
                              },
                              child: GridTile(
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data[index].image,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutDuration: Duration(milliseconds: 1000),
                                  fit: BoxFit.cover,
                                ),
                                footer: GridTileBar(
                                  backgroundColor: Colors.black87,
                                  title: Text(
                                    snapshot.data[index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
