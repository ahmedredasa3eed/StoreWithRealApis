import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies/helpers/database_helper.dart';
import 'package:movies/models/cart.dart';
import 'package:movies/models/exceptions.dart';
import 'package:movies/networking/cart_helper.dart';
import 'package:movies/networking/products_helper.dart';
import 'package:movies/screens/product_details.dart';
import 'package:movies/screens/shopping_cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  static const route = 'products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  void _showErrorDialog(String message) {
    showDialog(
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
                child: Text("Ok")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsHelper>(context, listen: false);

    final categoryData = ModalRoute.of(context).settings.arguments as List;
    final categoryId = categoryData[0];
    final categoryName = categoryData[1];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          actions: [
            IconButton(
              onPressed: () async {},
              icon: Icon(Icons.notifications),
            ),
            IconButton(
              onPressed: () async {
                Navigator.pushNamed(context, ShoppingCartScreen.route);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: FutureBuilder(
          future: products.fetchProductsByCategory(categoryId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitChasingDots(
                color: Colors.blue,
                size: 50.0,
              );
            }
            return Container(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                primary: true,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                    productId: snapshot.data[index].id,
                                    productName: snapshot.data[index].name)));
                      },
                      child: GridTile(
                        child: Stack(
                          children: [
                            Hero(
                              tag: snapshot.data[index].id,
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data[index].image,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fadeInCurve: Curves.easeIn,
                                fadeOutDuration: Duration(milliseconds: 1000),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Column(
                                children: [
                                  Consumer<ProductsHelper>(
                                    builder: (context, product, child) {
                                      return IconButton(
                                        icon: snapshot.data[index].favourite
                                            ? Icon(
                                                Icons.favorite_outlined,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.favorite_outlined,
                                                color: Colors.grey,
                                              ),
                                        onPressed: () async {

                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          try {
                                            final fav =
                                                await product.fetchFavourite(
                                                    snapshot.data[index].id
                                                        .toString(),
                                                    prefs.getString('userId'));
                                            snapshot.data[index].favourite =
                                                fav.favourite;
                                          } on FetchDataException catch (error) {
                                            final errorMessage = error;
                                            _showErrorDialog(
                                                errorMessage.toString());
                                          } catch (error) {
                                            final errorMessage = error;
                                            _showErrorDialog(
                                                errorMessage.toString());
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
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
            );
          },
        ),
      ),
    );
  }
}
