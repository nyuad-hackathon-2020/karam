import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firestore_ui/animated_firestore_grid.dart';
import 'package:flutter/material.dart';

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
        return FirestoreAnimatedGrid(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          query: Firestore.instance.collection('categories').snapshots(),
          itemBuilder: (context, document, animation, index) {
            return FadeTransition(
              opacity: animation,
              child: InkWell(
                onTap: () {
                  
                },
                child: Card(
                  child: Text(
                    document.data.toString(),
                  ),
                ),
              ),
            );
          },
          //query: Firestore.instance,
        );
      },
      fallback: (context) {
        //show grouped grid
        return Container();
      },
    );
  }
}
