import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:karam/business-objects/order.dart';
import 'package:karam/common/waiting.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('orders')
          .where('buyer', isEqualTo: 'userid')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text(snapshot.error);
        if (!snapshot.hasData) return Waiting();

        var orders = snapshot.data.documents.map((f) => Order(f)).toList();
        return GroupedListView<Order, int>(
          elements: orders,
          groupBy: (order) => order.status ?? 0,
          groupSeparatorBuilder: (status){
            String res;
            switch (status) {
              case 0:
                res = 'Pending Items';
                break;
              default:
            }
          },
        );
      },
    );
  }
}
