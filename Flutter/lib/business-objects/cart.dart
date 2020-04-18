import 'package:hive/hive.dart';
import 'package:karam/business-objects/product.dart';

class Cart {
  static Box<int> items;
  static int get totalCartAmount =>
      items.values.fold(0, (counter, amount) => counter + amount);

  static Future<int> addToCart(Product product) async {
    var count = items.get(product.id);
    if (count == null) {
      await items.put(product.id, 1);
      return 1;
    } else {
      await items.put(product.id, count + 1);
      return count + 1;
    }
  }
}
