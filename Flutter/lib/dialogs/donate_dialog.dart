import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karam/common/utils.dart';

class DonateDialog extends StatefulWidget {
  const DonateDialog({Key key}) : super(key: key);

  @override
  _DonateDialogState createState() => _DonateDialogState();
}

class _DonateDialogState extends State<DonateDialog> {
  final String restID = "PnFt6Lqisc0Ncjlgthnw";

  int selectedAmount = 1;
  DateTime selectedDate;

  TextEditingController nameController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    datePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return QuickDialog(
      titleText: "Donate Item",
      confirmText: "DONE",
      onConfirm: () {
        Firestore.instance.collection("restaurants/$restID/products").document().setData({
          "name": nameController.text,
          "expiry_date": selectedDate,
          "available": selectedAmount,
          "img": "",
        }); //.then(() => Navigator.pop(context));

        print("done");
      },
      onCancel: () {
        Navigator.pop(context, null);
      },
      content: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: QuickRoundedImage(
            fit: BoxFit.fitHeight,
          ),
        ),
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name *',
          ),
          validator: (String value) {
            return value.isEmpty ? "Required" : "";
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Quantity: ",
          style: TextStyle(color: Colors.black),
        ),
        SelectNumber(
          max: 10,
          amount: selectedAmount,
          changeAmount: (newAmount) {
            selectedAmount = newAmount;
          },
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: () async {
              selectedDate = await showDatePicker(
                  context: context, initialDate: now, firstDate: now, lastDate: now.add(Duration(days: 7)));

              datePickerController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: datePickerController,
                decoration: const InputDecoration(
                  labelText: 'Avalable Until *',
                ),
                validator: (String value) {
                  return value.isEmpty ? "Required" : "";
                },
              ),
            )),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
