import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:karam/business-objects/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'cart_item.dart';

class CartRepo {
  static Box<CartItem> items;
  static ValueListenable<Box<CartItem>> get itemsListenable =>
      items.listenable();
  static int get totalCartAmount =>
      items.values.fold(0, (counter, cartItem) => counter + cartItem.amount);

  static String getAbsoluteProductKey(Product product) =>
      '${product.parent.id}/products/${product.id}';
  static Future<CartItem> addToCart(Product product, [int amount]) async {
    if (amount == null) amount = 1;
    var actualId = getAbsoluteProductKey(product);
    var cartItem = items.get(actualId);
    if (cartItem == null) {
      await items.put(
        actualId,
        cartItem = CartItem(productId: product.id, storeId: product.parent.id)
          ..amount = amount,
      );
    } else {
      cartItem.amount += amount;
      await cartItem.save();
    }
    return cartItem;
  }
}
