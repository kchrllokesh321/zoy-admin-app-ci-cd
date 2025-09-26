import 'package:flutter/material.dart';

class TextFieldUtils {
  /// Sets focus to a text field and positions cursor at the end
  /// This is a common utility that can be used everywhere
  ///
  /// [context] - The build context
  /// [focusNode] - The focus node to request focus (can be null)
  /// [controller] - The text controller to set cursor position
  static void focusAndMoveCursorToEnd({
    required BuildContext context,
    FocusNode? focusNode,
    required TextEditingController controller,
  }) {
    if (!context.mounted || focusNode == null) return;

    void setCursorToEnd() {
      if (context.mounted) {
        FocusScope.of(context).requestFocus(focusNode);
        // Move cursor to the end of the text
        final textLength = controller.text.length;
        controller.selection = TextSelection.fromPosition(TextPosition(offset: textLength));
      }
    }

    // Try multiple times to ensure cursor positioning works
    WidgetsBinding.instance.addPostFrameCallback((_) => setCursorToEnd());
    Future.delayed(Duration(milliseconds: 50), setCursorToEnd);
    Future.delayed(Duration(milliseconds: 100), setCursorToEnd);
  }
}
