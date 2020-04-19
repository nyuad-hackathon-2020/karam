import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karam/business-objects/restaurant.dart';

class Product {
  final DocumentSnapshot snapshot;
  final Restaurant parent;
  Product(this.snapshot, this.parent);

  String get id => snapshot.documentID;
  String get name => snapshot.data['name'];
  int get available => snapshot.data['available'];
  String get imagePath => snapshot.data['img'];
  DateTime get expiryDate =>
      (snapshot.data['expiry_date'] as Timestamp).toDate();
  int get price => snapshot.data['price'];
}
