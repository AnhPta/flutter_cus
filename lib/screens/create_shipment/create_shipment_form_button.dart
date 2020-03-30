//import 'package:flutter/material.dart';
//
//class CreateShipmentButton extends StatelessWidget {
//  final VoidCallback _onPressed;
//  final String title;
//  Color _color;
//  Color _textColor;
//
//  CreateShipmentButton({
//    Key key,
//    VoidCallback onPressed,
//    this.title,
//    Color color,
//    Color textColor,
//  }) :
//    _onPressed = onPressed,
//    _color = color,
//    _textColor = textColor ?? Colors.black,
//    super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return  Padding(
//      padding: const EdgeInsets.only(left: 10),
//      child: ButtonTheme(
//        minWidth: 90.0,
//        height: 50.0,
//        child: RaisedButton(
//          onPressed: _onPressed,
//          child: Text(title),
//          color: _color,
//          textColor: _textColor,
//          elevation: 1,
//        ),
//      ),
//    );
//  }
//}
