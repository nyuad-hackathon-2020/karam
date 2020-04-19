import 'package:flutter/material.dart';
import 'package:karam/common/quick_dialog.dart';
import 'package:karam/common/quick_text.dart';

class AfterDonateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuickDialog(
      titleText: 'Giveaway confirmed!',
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
                  "Thank you for placing your food giveaway request. Once someone requests this item, you will be notified."),
        )
      ],
    );
  }
}
