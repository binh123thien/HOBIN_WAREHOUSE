import 'package:flutter/services.dart';

class MaxValueTextInputFormatter extends TextInputFormatter {
  final num maxValue;

  MaxValueTextInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    num newValueNum = num.tryParse(newValue.text) ?? 0.0;
    if (newValueNum > maxValue) {
      newValueNum =
          maxValue; // Set the value to max if it's greater than the max value
      final newString = newValueNum.toStringAsFixed(0); // Format as needed
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length),
      );
    }

    return newValue;
  }
}
