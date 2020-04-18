import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firestore_ui/animated_firestore_grid.dart';
import 'package:flutter/material.dart';
import 'package:karam/business-objects/cart.dart';
import 'package:karam/business-objects/category.dart';
import 'package:karam/business-objects/product.dart';
import 'package:karam/business-objects/restaurant.dart';
import 'package:karam/business-objects/restaurant_product_search_result.dart';

class ProductSearch extends StatefulWidget {
  final String searchFilter;
  final void Function(String newFilter) changeFilter;

  const ProductSearch({Key key, @required this.searchFilter, this.changeFilter})
      : super(key: key);
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: widget.searchFilter == null || widget.searchFilter.length == 0,
      builder: (context) {
        //show full grid
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FirestoreAnimatedGrid(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              query: Firestore.instance.collection('categories').snapshots(),
              itemBuilder: (context, document, animation, index) {
                var category = Category(document);
                return FadeTransition(
                  opacity: animation,
                  child: InkWell(
                    onTap: () {
                      widget.changeFilter(category.name);
                    },
                    child: _DrawImageWithTextCard(
                      imagePath: category.imagePath,
                      text: category.name,
                    ),
                  ),
                );
              }),
        );
      },
      fallback: (context) {
        //show grouped grid
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<Map<String, RestaurantProductSearchResult>>(
            stream: Firestore.instance
                .collection('restaurants')
                .snapshots()
                .map<Iterable<Restaurant>>((snapshot) => snapshot.documents
                    .map<Restaurant>((doc) => Restaurant(doc)))
                .asyncMap<Map<String, RestaurantProductSearchResult>>(
              (allRests) async {
                Map<String, RestaurantProductSearchResult> searchResults = {};
                for (var rest in allRests) {
                  var allProds = (await rest.products.getDocuments())
                      .documents
                      .map((f) => Product(f))
                      .where((x) =>
                          DateTime.now().isBefore(x.expiryDate) &&
                          x.available > 0 &&
                          x.name
                              .toLowerCase()
                              .contains(widget.searchFilter.toLowerCase()))
                      .toList();

                  if (allProds.length > 0)
                    searchResults[rest.id] = RestaurantProductSearchResult(
                        filteredProducts: allProds, restaurant: rest);
                }
                return searchResults;
              },
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text(snapshot.error.toString());

              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) return CircularProgressIndicator();

              //get a list of products
              var filteredRests = snapshot.data.values.toList();

              //TODO, sort based on how close to the user
              return ListView.builder(
                itemCount: filteredRests.length * 2,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var actualIndex = (index / 2).floor();
                  var searchResult = filteredRests[actualIndex];
                  var rest = searchResult.restaurant;
                  var prods = searchResult.filteredProducts;
                  if (index % 2 == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        rest.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: prods.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      var prod = prods[index];
                      return InkWell(
                        onTap: () async {
                          await Cart.addToCart(prod);
                        },
                        child: _DrawImageWithTextCard(
                          text: prod.name,
                          imagePath: prod.imagePath == null ||
                                  prod.imagePath.length == 0
                              ? null
                              : prod.imagePath,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _DrawImageWithTextCard extends StatelessWidget {
  final String text;
  final String imagePath;

  const _DrawImageWithTextCard({
    Key key,
    @required this.text,
    @required this.imagePath,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imagePath != null
                    ? CacheImage('gs://karam-nyuad.appspot.com/$imagePath')
                    : AssetImage('assets/food_plate.jpg'),
              ),
            ),
          )),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.6),
                    Colors.transparent
                  ],
                  stops: [0, 0.25, 1],
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
