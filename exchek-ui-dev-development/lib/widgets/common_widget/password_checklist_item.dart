import 'package:exchek/core/themes/custom_color_extension.dart';
import 'package:flutter/material.dart';

class PasswordChecklistItem extends StatelessWidget {
  final String text;
  final bool isValid;
  final double? fontsize;
  final double? iconSize;

  const PasswordChecklistItem(this.text, this.isValid, {super.key, this.fontsize, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.customColors;
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.check_circle_outline,
          color: isValid ? customColors.greenColor : customColors.hintTextColor,
          size: iconSize ?? 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isValid ? customColors.blackColor : customColors.darktextcolor,
              fontSize: fontsize ?? 14,
            ),
          ),
        ),
      ],
    );
  }
}
