import 'package:flutter/material.dart';
import 'package:karam/common/quick_dialog.dart';
import 'package:karam/common/quick_text.dart';

class AfterOrderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuickDialog(
      titleText: 'Check out complete',
      onCancel: null,
      confirmText: 'OK',
      onConfirm: () {
        Navigator.pop(context);
      },
      content: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QuickText(
            color: Colors.black,
            text:
                'Thank you for placing your request. Once a pick-up time is scheduled, you will be notified!',
          ),
        )
      ],
    );
  }
}
