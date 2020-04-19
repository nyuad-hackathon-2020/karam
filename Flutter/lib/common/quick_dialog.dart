import 'package:flutter/material.dart';
import 'utils.dart';

class QuickDialog extends StatelessWidget {
  final String titleText;
  final List<Widget> content;
  final void Function() onConfirm;
  final String confirmText;
  final EdgeInsetsGeometry contentPadding;
  final void Function() onCancel;
  final String cancelText;

  const QuickDialog({
    Key key,
    this.contentPadding = const EdgeInsets.all(5),
    @required this.titleText,
    @required this.content,
    @required this.onConfirm,
    this.confirmText = 'CONFIRM',
    @required this.onCancel,
    this.cancelText = 'CANCEL',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: contentPadding,
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFF95C41),
                const Color(0xFFF95C41).withOpacity(0.75),
                const Color(0xFFFF43952),
              ],
            ),
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Center(
          child: QuickText(
            text: titleText,
            color: Colors.white,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...content,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (onConfirm != null)
                QucikConfirmCancelButton(
                  text: confirmText,
                  isConfirm: true,
                  onClick: onConfirm,
                ),
              if (onCancel != null)
                QucikConfirmCancelButton(
                  text: cancelText,
                  isConfirm: false,
                  onClick: onCancel,
                )
            ],
          )
        ],
      ),
    );
  }
}
