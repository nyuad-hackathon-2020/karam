import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:karam/business-objects/cart-repo.dart';
import 'package:karam/business-objects/cart_item.dart';
import 'package:karam/business-objects/product.dart';
import 'package:karam/business-objects/restaurant.dart';
import 'package:karam/common/quick_dialog.dart';
import 'package:karam/common/quick_rounded_image.dart';
import 'package:karam/common/quick_text.dart';
import 'package:karam/common/waiting.dart';

class CartDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<CartItem>>(
      valueListenable: CartRepo.itemsListenable,
      builder: (context, _, __) {
        var cartItems = CartRepo.items.toMap();
        return QuickDialog(
          titleText: 'Your Cart',
          content: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView(
                children: cartItems
                    .map<String, Widget>(
                      (dKey, cartItem) {
                        var key = dKey as String;
                        return MapEntry(
                          key,
                          //Restaurant Listener
                          StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('restaurants')
                                .document(cartItem.storeId)
                                .snapshots(),
                            builder: (context, aRestSnapshot) {
                              if (aRestSnapshot.error != null)
                                return Text(aRestSnapshot.error.toString());
                              if (aRestSnapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !aRestSnapshot.hasData) return Waiting();

                              var restSnapShot = aRestSnapshot.data;
                              var rest = Restaurant(restSnapShot);
                              //Product listener
                              return StreamBuilder<DocumentSnapshot>(
                                stream: restSnapShot.reference
                                    .collection('products')
                                    .document(cartItem.productId)
                                    .snapshots(),
                                builder: (context, aProdSnapshot) {
                                  if (aProdSnapshot.error != null)
                                    return Text(aProdSnapshot.error.toString());
                                  if (aProdSnapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      !aProdSnapshot.hasData) return Waiting();

                                  var prodSnapShot = aProdSnapshot.data;
                                  var prod = Product(prodSnapShot, rest);
                                  return _DrawCartItem(
                                    prod: prod,
                                    amount: cartItem.amount,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    )
                    .values
                    .toList(),
              ),
            )
          ],
          onConfirm: () async {
            var cart = CartRepo.items.values;
            Map<String, dynamic> order = {
              'content': Map<String, dynamic>(),
              'buyer': 'userid',
            };
            for (var cartItem in cart) {
              var store =
                  order['content'][cartItem.storeId] as Map<String, dynamic>;
              if (store == null) {
                order['content'][cartItem.storeId] =
                    store = (Map<String, dynamic>());
                store['status'] = 0;
              }
              store[cartItem.productId] = cartItem.amount;
            }

            //add order object
            var ref = await Firestore.instance.collection('orders').add(order);
            //add to active orders too
            for (var restKeys
                in (order['content'] as Map<String, dynamic>).keys) {
              var rest = await Firestore.instance
                  .collection('restaurants')
                  .document(restKeys)
                  .get();
              var curActive =
                  List<DocumentReference>.from(rest.data['active_orders']);
              curActive.add(ref);
              await rest.reference
                  .setData({'active_orders': curActive}, merge: true);
            }

            await CartRepo.items.clear();
            Navigator.pop(context, ref);
          },
          onCancel: () {
            Navigator.pop(context);
          },
          confirmText: 'CHECK OUT',
          cancelText: 'GO BACK',
        );
      },
    );
  }
}

class _DrawCartItem extends StatelessWidget {
  final Product prod;
  final int amount;
  const _DrawCartItem({Key key, this.prod, this.amount}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var sizePerImage = size.width * 0.25;
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: sizePerImage,
            height: sizePerImage,
            child: QuickRoundedImage(
              imagePath: prod.imagePath,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              QuickText(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black,
                text: '${amount.toString()} x ${prod.name}',
              ),
              Row(
                children: [
                  QuickText(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: Colors.black,
                    text: 'From: ',
                  ),
                  QuickText(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                    text: prod.parent.name,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
