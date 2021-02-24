import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies/helpers/database_helper.dart';
import 'package:movies/models/cart.dart';
import 'package:movies/models/product.dart';
import 'package:movies/networking/products_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const route = 'product-details-screen';

  final String productId;
  final String productName;

  ProductDetailsScreen({this.productId, this.productName});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int count = 1;

  Future<Product> _productDetails;

  @override
  void initState() {
    super.initState();
    _productDetails = Provider.of<ProductsHelper>(context, listen: false).fetchProductById(widget.productId);
  }

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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.productName),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: _productDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitChasingDots(
                        color: Colors.blue,
                        size: 50.0,
                      ),
                    );
                  }
                  Product loadedProduct = snapshot.data;
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Hero(
                          tag: snapshot.data.id,
                          child: CachedNetworkImage(
                            imageUrl: loadedProduct.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fadeInCurve: Curves.easeIn,
                            fadeOutDuration: Duration(milliseconds: 1000),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                loadedProduct.name,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "${loadedProduct.price} رس ",
                              textAlign: TextAlign.end,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                              "الكمية المطلوبة",
                              style: TextStyle(
                                fontSize: 19,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  child: MaterialButton(
                                    color: Colors.green,
                                    shape: CircleBorder(),
                                    onPressed: () {
                                      setState(() {
                                        count++;
                                      });
                                    },
                                    child: Icon(Icons.add),
                                  ),
                                ),
                                Text("$count"),
                                Container(
                                  child: MaterialButton(
                                    color: Colors.red,
                                    shape: CircleBorder(),
                                    onPressed: () {
                                      setState(() {
                                        if (count <= 1) {
                                          count = 1;
                                        }
                                        count--;
                                      });
                                    },
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "إضافة إلى السلة",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () async {
                            try {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              final userId = preferences.getString('userId');
                              final result = await Provider.of<ProductsHelper>(context, listen: false).addToCart(widget.productId, userId, count);
                              _showDialog(result);
                              //TO Do Save to database here
                              final foundCartResult = await DbHelper.dbHelper
                                  .getCartItemWithId(widget.productId);
                              if (foundCartResult == false) {
                                int rowAdded =
                                    await DbHelper.dbHelper.addCartItem(
                                  Cart(
                                    id: widget.productId,
                                    name: snapshot.data.name,
                                    price: double.parse(snapshot.data.price),
                                    quantity: count,
                                    image: snapshot.data.image,
                                  ),
                                );
                                print(result.toString());
                                print("Row Added $rowAdded");
                              } else {
                                final rowUpdated =
                                    await DbHelper.dbHelper.updateCartItem(Cart(
                                  id: widget.productId,
                                  name: snapshot.data.name,
                                  price: double.parse(snapshot.data.price),
                                  quantity: count+ count,
                                  image: snapshot.data.image,
                                ));
                                print("Row Updated : $rowUpdated");
                              }
                            } catch (error) {
                              print(error);
                            }
                          },
                        ),
                      ),
                    ],
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
