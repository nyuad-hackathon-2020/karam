import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:karam/business-objects/order.dart';
import 'package:karam/common/quick_rounded_image.dart';
import 'package:karam/common/quick_text.dart';
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
          elements: orders, //.expand((order)=>MapEntry(order,order.)),
          groupBy: (order) => order.status ?? 0,
          itemBuilder: (context, order) {
            return Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(109, 38, 225, 0.09),
                border: Border.all(
                  color: Colors.black.withOpacity(0.17),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Image(
                      height: 50,
                      width: 50,
                      image: AssetImage('assets/logo.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Your Order (${order.id})\nhas ${order.countProducts} products',
                        style: TextStyle(color: Color(0xFF060606)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          groupSeparatorBuilder: (status) {
            var res = Order.getStatusString(status);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: QuickText(
                text: res,
                alignment: TextAlign.left,
                color: Colors.black,
              ),
            );
          },
        );
      },
    );
  }
}
