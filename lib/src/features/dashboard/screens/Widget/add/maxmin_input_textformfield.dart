import 'package:flutter/services.dart';

class NumberFormatter extends TextInputFormatter {
  final int maxValue;

  NumberFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.startsWith('0')) {
      return oldValue;
    } else {
      int value = int.tryParse(newValue.text) ?? 0;
      if (value > maxValue) {
        value = maxValue;
      }
      final newText = '$value';
      return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length));
    }
  }
}
