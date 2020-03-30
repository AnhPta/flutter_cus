import 'package:app_customer/utils/variables.dart';
import 'package:flutter/material.dart';

class ContactPlaceButton extends StatelessWidget {
  final VoidCallback _onPressed;

  ContactPlaceButton({Key key, VoidCallback onPressed})
    : _onPressed = onPressed,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(30.0),
        ),
        color: colorAccent,
        child: Text(
          'Lưu lại',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _onPressed,
      ),
    );
  }
}
