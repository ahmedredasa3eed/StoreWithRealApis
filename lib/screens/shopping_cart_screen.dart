import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/cart.dart';
import 'package:movies/networking/cart_helper.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  static const route = 'shopping-cart-screen';

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {

  Future<List<Cart>> _cartDetails;

  var totalPrice = 0.0;

  @override
  void initState(){
    super.initState();
    _cartDetails = Provider.of<CartProvider>(context,listen: false).getAllCartItems();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("سلة المشتريات"),
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: _cartDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Consumer<CartProvider>(builder: (context, cart, child) {
                  return cart.cartItems.length <= 0
                      ? Center(
                    child: Text("سلة المشتريات فارغة"),
                  )
                      : Container(
                    width: double.infinity,
                    height: 200,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<CartProvider>(context,listen: false).getAllCartItems();
                      },
                      child: ListView.builder(
                          itemCount: cart.cartItems.length,
                          itemBuilder: (context, index) {

                            return (cart.cartItems.length == 0) ? Center(child: Text("سلة المشتريات فارغة"),): Column(
                              children: [
                                Dismissible(
                                  onDismissed: (dismissDirection) async {
                                    final productId = cart.cartItems[index].id;
                                    await CartProvider().deleteCartItemWithId(productId);
                                  },
                                  key: UniqueKey(),
                                  background : Container(
                                    alignment: Alignment.centerRight,
                                    color: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Icon(
                                      Icons.delete_forever,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.startToEnd,
                                  child: ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl: cart.cartItems[index].image,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      fadeInCurve: Curves.easeIn,
                                      fadeOutDuration: Duration(milliseconds: 1000),
                                    ),
                                    title: Text(
                                      cart.cartItems[index].name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Text(
                                        "السعر : ${cart.cartItems[index].price}"),
                                    trailing: FittedBox(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: MaterialButton(
                                              height: 16,
                                              color: Colors.green,
                                              shape: CircleBorder(),
                                              onPressed: () {
                                                setState(() {
                                                  cart.cartItems[index].quantity++;
                                                });
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                          Text("${cart.cartItems[index].quantity}"),
                                          Container(
                                            child: MaterialButton(
                                              height: 16,
                                              color: Colors.red,
                                              shape: CircleBorder(),
                                              onPressed: () {
                                                setState(() {
                                                  cart.cartItems[index].quantity--;
                                                });
                                              },
                                              child: Icon(Icons.remove),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 16,),
            Container(
              height: 40,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.2),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text("ملخص الطلب",style: TextStyle(fontSize:18),),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('المبلغ الإجمالي',style: TextStyle(fontSize:18),),
                  Text("${Provider.of<CartProvider>(context).getTotalPrice()}",style: TextStyle(fontSize:18),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
