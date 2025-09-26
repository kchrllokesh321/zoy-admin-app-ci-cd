import 'package:exchek/core/utils/textfiled_focus_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextFieldUtils.focusAndMoveCursorToEnd', () {
    testWidgets('requests focus and positions cursor at the end', (tester) async {
      final controller = TextEditingController(text: 'Hello');
      final focusNode = FocusNode();
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return TextField(controller: controller, focusNode: focusNode);
              },
            ),
          ),
        ),
      );

      TextFieldUtils.focusAndMoveCursorToEnd(context: capturedContext, focusNode: focusNode, controller: controller);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(focusNode.hasFocus, isTrue);
      expect(controller.selection.baseOffset, controller.text.length);
      expect(controller.selection.extentOffset, controller.text.length);
    });

    testWidgets('returns early when focusNode is null', (tester) async {
      final controller = TextEditingController(text: 'Hello');
      controller.selection = const TextSelection.collapsed(offset: 0);
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      TextFieldUtils.focusAndMoveCursorToEnd(context: capturedContext, focusNode: null, controller: controller);

      await tester.pump(const Duration(milliseconds: 200));

      expect(controller.selection.baseOffset, 0);
      expect(controller.selection.extentOffset, 0);
    });
  });
}
