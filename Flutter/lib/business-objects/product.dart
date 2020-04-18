import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final DocumentSnapshot snapshot;

  Product(this.snapshot);

  String get id => snapshot.documentID;
  String get name => snapshot.data['name'];
  int get available => snapshot.data['available'];
  String get imagePath => snapshot.data['imagePath'];
  DateTime get expiryDate =>
      (snapshot.data['expiry_date'] as Timestamp).toDate();
  int get price => snapshot.data['price'];
}
