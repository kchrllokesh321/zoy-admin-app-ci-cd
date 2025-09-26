import 'package:exchek/core/responsive_helper/responsive_helper.dart';
import 'package:exchek/widgets/common_widget/image_view.dart';
import 'package:flutter/material.dart';

class CommonActionCard extends StatelessWidget {
  final String text;
  final String iconPath;
  final Color bgColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onTap;
  final double iconSize;
  final double textSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconBGSize;

  const CommonActionCard({
    super.key,
    required this.text,
    required this.iconPath,
    this.bgColor = const Color(0xFFFFF8C5),
    this.iconBgColor = const Color(0xFFFFE100),
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.onTap,
    this.iconSize = 18.0,
    this.textSize = 14.0,
    this.horizontalPadding = 12.0,
    this.verticalPadding = 12.0,
    this.iconBGSize = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          children: [
            Container(
              height: iconBGSize,
              width: iconBGSize,
              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: CustomImageView(imagePath: iconPath, height: iconSize, color: iconColor),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 16.0, desktop: 17.0),
                  color: textColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 20.0, color: textColor),
          ],
        ),
      ),
    );
  }
}
