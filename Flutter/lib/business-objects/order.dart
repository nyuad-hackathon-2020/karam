import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final DocumentSnapshot snapshot;

  Order(this.snapshot);

  DocumentReference get buyer => snapshot.data['buyer'];
  int get status => snapshot.data['status'];
  Map<String, dynamic> get content => snapshot['content'];

  Map<String, dynamic> getRestaurantOrders(String restaurantId) =>
      content[restaurantId];
  int getProductAmount(String restaurantId, String productId) =>
      getRestaurantOrders(restaurantId)[productId];
}
