import 'package:flutter/material.dart';

class QucikConfirmCancelButton extends StatelessWidget {
  final String text;
  final void Function() onClick;
  final bool isConfirm;
  const QucikConfirmCancelButton(
      {Key key, this.text, this.onClick, this.isConfirm = true})
      : assert(isConfirm != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: Colors.black.withOpacity(0.17) 
        )
      ),
      color: isConfirm
          ? const Color(0xFFE0FFD1)
          : Color.fromRGBO(251, 98, 98, 0.78),
      child: Text(
        text,
        style: TextStyle(
            color: isConfirm ? const Color(0xFF38920F) : Colors.white),
      ),
      onPressed: onClick,
    );
  }
}
