import 'package:app_customer/utils/variables.dart';
import 'package:flutter/material.dart';

class RegistryButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegistryButton({Key key, VoidCallback onPressed})
    : _onPressed = onPressed,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: _onPressed,
      color: colorAccent,
      child: Text('Đăng ký', style: TextStyle(color: Colors.white, fontSize: 18),),
    );
  }
}
