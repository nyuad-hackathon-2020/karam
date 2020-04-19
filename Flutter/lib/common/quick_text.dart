import 'package:flutter/material.dart';

class QuickText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign alignment;
  const QuickText({
    Key key,
    this.text,
    this.color = Colors.white,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w500,
    this.alignment = TextAlign.center,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Cantarell',
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        letterSpacing: 0.05,
        color: color,
      ),
      textAlign: alignment,
    );
  }
}
