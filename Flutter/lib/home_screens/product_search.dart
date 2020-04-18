import 'dart:developer';

import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_ui/animated_firestore_grid.dart';
import 'package:flutter/material.dart';
import 'package:karam/business-objects/product.dart';

class ProductSearch extends StatefulWidget {
  final String searchFilter;

  const ProductSearch({Key key, @required this.searchFilter}) : super(key: key);
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
                    onTap: () {},
                    child: Card(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: FadeInImage(
                              placeholder: AssetImage('assets/food_plate.jpg'),
                              fit: BoxFit.cover,
                              image: CacheImage(
                                  'gs://karam-nyuad.appspot.com/${category.imagePath}'),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
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
                              category.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
      fallback: (context) {
        //show grouped grid
        return Container();
      },
    );
  }
}
