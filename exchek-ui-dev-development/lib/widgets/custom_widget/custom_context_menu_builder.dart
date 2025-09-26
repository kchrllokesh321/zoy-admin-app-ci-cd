import 'package:flutter/material.dart';

Widget customContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems:
        editableTextState.contextMenuButtonItems.where((item) => item.type != ContextMenuButtonType.paste).toList(),
  );
}
