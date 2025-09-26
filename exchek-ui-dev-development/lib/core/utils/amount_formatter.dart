import 'package:flutter/services.dart';

class AmountFormatter extends TextInputFormatter {
  final int decimalPlaces;

  AmountFormatter({this.decimalPlaces = 2});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits and decimal point
    String text = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Ensure only one decimal point
    final decimalIndex = text.indexOf('.');
    if (decimalIndex != -1) {
      final beforeDecimal = text.substring(0, decimalIndex);
      final afterDecimal = text.substring(decimalIndex + 1);
      text = '$beforeDecimal.${afterDecimal.replaceAll('.', '')}';
    }

    // Limit decimal places
    if (decimalIndex != -1) {
      final afterDecimal = text.substring(decimalIndex + 1);
      if (afterDecimal.length > decimalPlaces) {
        text = text.substring(0, decimalIndex + 1 + decimalPlaces);
      }
    }

    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
