import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final DocumentSnapshot snapshot;

  Product(this.snapshot);
  String get id=>snapshot.documentID;
  String get name => snapshot.data[''];

}