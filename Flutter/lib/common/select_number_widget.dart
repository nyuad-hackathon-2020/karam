import 'package:flutter/material.dart';

class SelectNumber extends StatefulWidget {
  final int amount;
  final int max;
  final void Function(int newAmount) changeAmount;

  const SelectNumber({Key key, this.amount, this.changeAmount, @required this.max})
      : super(key: key);
  @override
  _SelectNumberState createState() => _SelectNumberState();
}

class _SelectNumberState extends State<SelectNumber> {
  int currentAmount;
  @override
  void initState() {
    super.initState();
    currentAmount = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF8BDE64), //TODAY I LEARNT YOU CAN DO THAT!
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(
              Icons.remove,
              color: Colors.white,
            ),
            onPressed: () {
              if (currentAmount == 1) return;
              setState(() {
                --currentAmount;
              });
              widget.changeAmount(currentAmount);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.22))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                currentAmount.toString(),
              ),
            ),
          ),
        ),
        Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF8BDE64),
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              if (currentAmount == widget.max) return;
              setState(() {
                ++currentAmount;
              });
              widget.changeAmount(currentAmount);
            },
          ),
        ),
      ],
    );
  }
}
