import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/networking/products_helper.dart';
import 'package:movies/screens/product_details.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {

  static const route = 'favourite-screen';

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("المفضلة"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<ProductsHelper>(context,listen: false).fetchFavouriteProucts("53");
          },
          child: FutureBuilder(
            future: Provider.of<ProductsHelper>(context,listen: false).fetchFavouriteProucts("53"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
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
                              MaterialPageRoute(builder: (context) => ProductDetailsScreen(productId: snapshot.data[index].id, productName: snapshot.data[index].name)));
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
                                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.add_shopping_cart),
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
      ),
    );
  }
}
