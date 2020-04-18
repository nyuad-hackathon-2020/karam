import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final DocumentSnapshot snapshot;

  Category(this.snapshot);
  String get id => snapshot.documentID;
  String get name => snapshot.data['name'];
  String get imagePath => snapshot.data['img'];
}
