import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final DocumentSnapshot snapshot;

  Restaurant(this.snapshot);

  String get id => snapshot.documentID;
  String get name => snapshot.data['name'];
  DateTime get createdAt => (snapshot.data['created_at'] as Timestamp).toDate();
  String get cuisine => snapshot.data['cuisine'];
  int get score => snapshot.data['score'];
  GeoPoint get location => snapshot.data['location'];

  CollectionReference get products => snapshot.reference.collection('products');
  CollectionReference get orders => snapshot.reference.collection('orders');
}
