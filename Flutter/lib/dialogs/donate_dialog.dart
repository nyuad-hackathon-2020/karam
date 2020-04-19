import 'dart:io';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:karam/common/utils.dart';

class DonateDialog extends StatefulWidget {
  const DonateDialog({Key key}) : super(key: key);

  @override
  _DonateDialogState createState() => _DonateDialogState();
}

class _DonateDialogState extends State<DonateDialog> {
  String productImageURL = "";

  final String restID = "PnFt6Lqisc0Ncjlgthnw";

  int selectedAmount = 1;
  DateTime selectedDate;

  TextEditingController nameController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();

  uploadImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image == null) {
      return null;
    }

    final StorageTaskSnapshot downloadURL =
        await FirebaseStorage.instance.ref().child("products/" + basename(image.path)).putFile(image).onComplete;

    final String url = (await downloadURL.ref.getDownloadURL());

    setState(() {
      productImageURL = url;
    });
  }

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
          "img": productImageURL.isEmpty ? "" : productImageURL,
        }).then((onValue) {
          Navigator.pop(context);
        });
      },
      onCancel: () {
        Navigator.pop(context, null);
      },
      content: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: productImageURL.isNotEmpty
              ? QuickRoundedImage(
                  imagePath: productImageURL,
                  fit: BoxFit.fitHeight,
                )
              : FlatButton(
                  child: Icon(Icons.add_a_photo),
                  onPressed: () {
                    uploadImage();
                  },
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
