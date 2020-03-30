import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlockButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final List<String> _caption;
  final Color _color;
  final Color _backgroundColor;
  final IconData _icon;

  BlockButton(
      {Key key,
      VoidCallback onPressed,
      List<String> caption,
      Color color,
      Color backgroundColor,
      IconData icon})
      : _onPressed = onPressed,
        _caption = caption ?? [],
        _color = color ?? Colors.black,
        _backgroundColor = backgroundColor ?? Colors.grey[300],
        _icon = icon,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    if (_icon != null) {
      widgets.add(
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Icon(
              _icon,
              color: _color,
            ),
          )
        ),
      );
    }

    for (var i = 0; i < _caption.length; i++) {
      widgets.add(
        Flexible(
          child: Text(
            _caption[i],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: _color, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return InkWell(
      onTap: _onPressed,
      child: Container(
          margin: EdgeInsets.all(10),
          color: Colors.transparent,
          // This line set the transparent background
          child: Container(
            decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widgets,
              ),
            ),
          )),
    );
  }
}
