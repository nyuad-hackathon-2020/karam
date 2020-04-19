import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final DocumentSnapshot snapshot;

  Order(this.snapshot);

  String get id => snapshot.documentID;

  int get countProducts => content.values.fold<int>(
      0,
      (counter, rest) =>
          (rest as Map<String, dynamic>).values.fold<int>(
              0, (counter2, productCount) => productCount + counter2) +
          counter);

  DocumentReference get buyer => snapshot.data['buyer'];
  int get status => snapshot.data['status'];

  static String getStatusString(int status) {
    switch (status) {
      case 0:
        return 'Pending Items';
      case 1:
        return 'In Progress';
      case 2:
        return 'Approved';
      default:
        return 'Unknown';
    }
  }

  Map<String, dynamic> get content => snapshot['content'];

  Map<String, dynamic> getRestaurantOrders(String restaurantId) =>
      content[restaurantId];

  int getProductAmount(String restaurantId, String productId) =>
      getRestaurantOrders(restaurantId)[productId];
}
