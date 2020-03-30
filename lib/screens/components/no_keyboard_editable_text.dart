import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoKeyboardEditableText extends EditableText {

  NoKeyboardEditableText({
    Key key,
    @required TextEditingController controller,
    @required TextStyle style,
    @required Color cursorColor,
    bool autofocus = false,
    Color selectionColor,
    ValueChanged<String> onChanged,
    textAlign = TextAlign.start,
  }): super(
      key: key,
      controller: controller,
      focusNode: NoKeyboardEditableTextFocusNode(),
      style: style,
      cursorColor: cursorColor,
      autofocus: autofocus,
      selectionColor: selectionColor,
      backgroundCursorColor: Colors.black,
      onChanged: onChanged,
      textAlign: textAlign,
  );

  @override
  EditableTextState createState() {
    return NoKeyboardEditableTextState();
  }
}

class NoKeyboardEditableTextState extends EditableTextState {
  @override
  void requestKeyboard() {
    super.requestKeyboard();
    //hide keyboard
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

class NoKeyboardEditableTextFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    // prevents keyboard from showing on first focus
    return false;
  }
}