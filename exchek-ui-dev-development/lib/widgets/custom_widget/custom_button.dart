import 'package:exchek/core/utils/exports.dart';
import 'package:flutter/cupertino.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.margin,
    this.onPressed,
    this.buttonStyle,
    this.alignment,
    this.buttonTextStyle,
    this.isDisabled = false,
    this.height,
    this.width,
    this.iconSpacing,
    this.isLoading = false,
    this.secondary = false,
    this.borderRadius,
    this.tooltipMessage,
    required this.text,
    this.isShowTooltip = false,
    this.padding,
  });

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final Alignment? alignment;
  final TextStyle? buttonTextStyle;
  final bool isDisabled;
  final double? height;
  final double? width;
  final double? iconSpacing;
  final bool isLoading;
  final String text;
  final bool secondary;
  final double? borderRadius;
  final String? tooltipMessage;
  final bool isShowTooltip;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final button = Container(
      height: height ?? 48.0,
      width: width ?? MediaQuery.of(context).size.width,
      margin: margin,
      decoration: decoration,
      child: ElevatedButton(
        style:
            buttonStyle ??
            ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? ResponsiveHelper.getWidgetSize(context, mobile: 10, tablet: 10, desktop: 10),
                ),
              ),
              padding:
                  padding ??
                  EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getWidgetSize(context, mobile: 12, tablet: 12, desktop: 12),
                    vertical: ResponsiveHelper.getWidgetHeight(context, mobile: 12, tablet: 12, desktop: 12),
                  ),
              textStyle: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: 0.16),
            ),
        onPressed:
            isDisabled
                ? null
                : () {
                  HapticFeedback.lightImpact();
                  if (onPressed != null) onPressed!();
                },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null) leftIcon!,
            if (leftIcon != null && iconSpacing != null) SizedBox(width: iconSpacing),
            if (isLoading)
              CupertinoActivityIndicator(color: Theme.of(context).customColors.fillColor)
            else
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style:
                      secondary
                          ? Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                            letterSpacing: 0.16,
                          )
                          : buttonTextStyle ??
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Theme.of(context).colorScheme.onPrimary,
                                letterSpacing: 0.16,
                              ),
                ),
              ),
            if (rightIcon != null && iconSpacing != null) SizedBox(width: iconSpacing),
            if (rightIcon != null) rightIcon!,
          ],
        ),
      ),
    );

    if (isShowTooltip && isDisabled) {
      return Tooltip(
        margin: const EdgeInsets.only(top: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).customColors.blackColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        message: tooltipMessage ?? "",
        child: button,
      );
    }

    return button;
  }
}
