import 'package:flutter/material.dart';
import 'package:karam/business-objects/product.dart';
import 'package:karam/business-objects/restaurant.dart';

class RestaurantProductSearchResult {
  String get restaurantId => restaurant.id;
  final Restaurant restaurant;
  final List<Product> filteredProducts;

  RestaurantProductSearchResult({
    @required this.restaurant,
    @required this.filteredProducts,
  });
}
