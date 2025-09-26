// import 'package:flutter/services.dart';

// class AadhaarInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
//     final buffer = StringBuffer();

//     for (int i = 0; i < digitsOnly.length; i++) {
//       buffer.write(digitsOnly[i]);
//       if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) {
//         buffer.write('-');
//       }
//     }

//     final formatted = buffer.toString();
//     return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
//   }
// }

import 'package:flutter/services.dart';

class GroupedInputFormatter extends TextInputFormatter {
  final List<int> groupSizes;
  final String separator;
  final bool digitsOnly;
  final bool toUpperCase;

  GroupedInputFormatter({
    required this.groupSizes,
    this.separator = ' ',
    this.digitsOnly = false,
    this.toUpperCase = false,
  });

  static String format({
    required String input,
    required List<int> groupSizes,
    String separator = ' ',
    bool digitsOnly = false,
    bool toUpperCase = false,
  }) {
    String raw = input;

    if (toUpperCase) raw = raw.toUpperCase();
    if (digitsOnly) {
      raw = raw.replaceAll(RegExp(r'\D'), '');
    } else {
      raw = raw.replaceAll(RegExp(r'\s+'), '');
    }

    final buffer = StringBuffer();
    int currentIndex = 0;

    for (int groupLength in groupSizes) {
      if (currentIndex + groupLength > raw.length) {
        buffer.write(raw.substring(currentIndex));
        break;
      }
      buffer.write(raw.substring(currentIndex, currentIndex + groupLength));
      currentIndex += groupLength;
      if (currentIndex < raw.length) {
        buffer.write(separator);
      }
    }

    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String raw = newValue.text;

    if (toUpperCase) raw = raw.toUpperCase();
    if (digitsOnly) {
      raw = raw.replaceAll(RegExp(r'\D'), '');
    } else {
      raw = raw.replaceAll(RegExp(r'\s+'), '');
    }

    final buffer = StringBuffer();
    int currentIndex = 0;

    for (int groupLength in groupSizes) {
      if (currentIndex + groupLength > raw.length) {
        buffer.write(raw.substring(currentIndex));
        break;
      }
      buffer.write(raw.substring(currentIndex, currentIndex + groupLength));
      currentIndex += groupLength;
      if (currentIndex < raw.length) {
        buffer.write(separator);
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}
