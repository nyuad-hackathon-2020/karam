
import 'package:hive/hive.dart';
part 'cart_item.g.dart';
@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  final String storeId;
  @HiveField(1)
  final String productId;
  @HiveField(2)
  int amount;
  CartItem({this.productId, this.storeId});
}