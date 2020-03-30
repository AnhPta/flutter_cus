import 'package:flutter/material.dart';
import 'package:app_customer/bloc/notify/bloc.dart';
import 'package:app_customer/utils/flushbar_helper.dart';
import 'package:flushbar/flushbar.dart';
class Helper {
  static Flushbar loadingBar = FlushbarHelper.createLoading(message: 'Đang tải dữ liệu vui lòng đợi');

  static void notifyListen(dynamic state, BuildContext context) {
    if (state is SuccessNotifyState) {
      FlushbarHelper.createSuccess(message: state.message)..show(context);
      return;
    }

    if (state is ErrorNotifyState) {
      FlushbarHelper.createError(message: state.message)..show(context);
      return;
    }

    if (state is WarningNotifyState) {
      FlushbarHelper.createWarning(message: state.message)..show(context);
      return;
    }

    if (state is InfoNotifyState) {
      FlushbarHelper.createInformation(message: state.message)..show(context);
      return;
    }

    if (state is LoadingNotifyState) {
      if (state.isLoading && !loadingBar.isShowing()) {
        loadingBar.show(context);
      } else {
        loadingBar.dismiss(true);
      }
      return;
    }
  }
}

class MoneyMaskedTextController extends TextEditingController {
  MoneyMaskedTextController(
    {double initialValue = 0,
      this.decimalSeparator = ',',
      this.thousandSeparator = '.',
      this.rightSymbol = '',
      this.leftSymbol = ' đ',
      this.precision = 2}) {
    _validateConfig();

    this.addListener(() {
      this.updateValue(this.numberValue);
      this.afterChange(this.text, this.numberValue);
    });

    this.updateValue(initialValue);
  }

  final String decimalSeparator;
  final String thousandSeparator;
  final String rightSymbol;
  final String leftSymbol;
  final int precision;

  Function afterChange = (String maskedValue, double rawValue) {};

  double _lastValue = 0;

  void updateValue(double value) {
    double valueToUse = value;

    if (value.toStringAsFixed(0).length > 12) {
      valueToUse = _lastValue;
    }
    else {
      _lastValue = value;
    }

    String masked = this._applyMask(valueToUse);

    if (rightSymbol.length > 0) {
      masked += rightSymbol;
    }

    if (leftSymbol.length > 0) {
      masked = leftSymbol + masked;
    }

    if (masked != this.text) {
      this.text = masked;

      var cursorPosition = super.text.length - this.rightSymbol.length;
      this.selection = new TextSelection.fromPosition(
        new TextPosition(offset: cursorPosition));
    }
  }

  double get numberValue {
    List<String> parts = _getOnlyNumbers(this.text).split('').toList(growable: true);

    parts.insert(parts.length - precision, '');

    return double.parse(parts.join());
  }

  _validateConfig() {
    bool rightSymbolHasNumbers = _getOnlyNumbers(this.rightSymbol).length > 0;

    if (rightSymbolHasNumbers) {
      throw new ArgumentError("rightSymbol must not have numbers.");
    }
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text;

    var onlyNumbersRegex = new RegExp(r'[^\d]');

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');

    return cleanedText;
  }

  String _applyMask(double value) {
    List<String> textRepresentation = value.toStringAsFixed(precision)
      .replaceAll('.', '')
      .split('')
      .reversed
      .toList(growable: true);

    if (precision == 0) {
      textRepresentation.insert(precision, '');
    } else {
      textRepresentation.insert(precision, decimalSeparator);
    }

    for (var i = precision + 4; true; i = i + 4) {
      if (textRepresentation.length > i) {
        textRepresentation.insert(i, thousandSeparator);
      }
      else {
        break;
      }
    }

    return textRepresentation.reversed.join('');
  }
}

