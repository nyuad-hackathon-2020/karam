import 'package:flutter/material.dart';
import 'package:karam/business-objects/product.dart';
import 'package:karam/common/utils.dart';

class SelectQuantityDialog extends StatefulWidget {
  final Product prod;
  const SelectQuantityDialog({Key key, this.prod}) : super(key: key);

  @override
  _SelectQuantityDialogState createState() => _SelectQuantityDialogState();
}

class _SelectQuantityDialogState extends State<SelectQuantityDialog> {
  int selectedAmount = 1;
  @override
  Widget build(BuildContext context) {
    return QuickDialog(
      titleText: widget.prod.name,
      confirmText: 'ADD TO CART',      
      onConfirm: () {
        Navigator.pop(context, selectedAmount);
      },
      onCancel: () {
        Navigator.pop(context, null);
      },
      content: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: QuickRoundedImage(
            imagePath: widget.prod.imagePath,
            fit: BoxFit.fitHeight,
          ),
        ),
        QuickText(
          text: 'Select Quantity',
          color: Colors.black,
        ),
        SelectNumber(
          max: widget.prod.available,
          amount: selectedAmount,
          changeAmount: (newAmount) {
            selectedAmount = newAmount;
          },
        ),
      ],
    );
  }
}
