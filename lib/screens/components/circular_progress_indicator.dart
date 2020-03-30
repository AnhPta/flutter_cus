import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  final Color _color;

  CircularLoader({
    Key key,
    Color color,
  }) :
      _color = color,
      super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 23,
          height: 23,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(_color),
          ),
        ),
      ),
    );
  }
}
