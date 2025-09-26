import 'package:exchek/core/utils/exports.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final List<PopupMenuEntry<String>> items;
  final Widget child;
  final Offset? offset;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? menuPadding;
  final double? elevation;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Clip? clipBehavior;
  final ShapeBorder? shape;
  final Function(String)? onSelected;
  final String? initialValue;
  final bool? enableFeedback;
  final double? iconSize;
  final bool? useRootNavigator;

  const CustomPopupMenuButton({
    super.key,
    required this.items,
    required this.child,
    this.offset,
    this.padding,
    this.menuPadding,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.clipBehavior,
    this.shape,
    this.onSelected,
    this.initialValue,
    this.enableFeedback,
    this.iconSize,
    this.useRootNavigator,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: offset ?? Offset(0, 50),
      padding: padding ?? EdgeInsets.zero,
      menuPadding: menuPadding ?? EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      elevation: elevation ?? 8,
      color: backgroundColor ?? Theme.of(context).customColors.fillColor,
      shadowColor: shadowColor ?? Theme.of(context).customColors.shadowColor?.withValues(alpha: 0.25),
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => items,
      onSelected: onSelected,
      initialValue: initialValue,
      enableFeedback: enableFeedback ?? true,
      iconSize: iconSize,
      useRootNavigator: useRootNavigator ?? true,
      child: child,
    );
  }
}

// class HoverPopupMenuItem extends StatefulWidget {
//   final String text;
//   final VoidCallback? onTap;
//   final Color? backgroundColor;
//   final Color? hoverColor;
//   final TextStyle? textStyle;
//   final EdgeInsetsGeometry? padding;
//   final double? borderRadius;

//   const HoverPopupMenuItem({
//     Key? key,
//     required this.text,
//     this.onTap,
//     this.backgroundColor,
//     this.hoverColor,
//     this.textStyle,
//     this.padding,
//     this.borderRadius,
//   }) : super(key: key);

//   @override
//   State<HoverPopupMenuItem> createState() => _HoverPopupMenuItemState();
// }

// class _HoverPopupMenuItemState extends State<HoverPopupMenuItem> {
//   bool isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: MouseRegion(
//         onEnter: (_) {
//           if (mounted) {
//             setState(() => isHovered = true);
//           }
//         },
//         onExit: (_) {
//           if (mounted) {
//             setState(() => isHovered = false);
//           }
//         },
//         cursor: SystemMouseCursors.click,
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 200),
//           width: double.infinity,
//           padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//           decoration: BoxDecoration(
//             color:
//                 isHovered
//                     ? (widget.hoverColor ?? Theme.of(context).customColors.lightBoxBGColor?.withValues(alpha: 0.3))
//                     : (widget.backgroundColor ?? Colors.transparent),
//             borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
//           ),
//           child: Text(
//             widget.text,
//             style:
//                 widget.textStyle ??
//                 TextStyle(
//                   color: Theme.of(context).customColors.blackColor,
//                   fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Helper class to create popup menu items with hover effect
class PopupMenuHelper {
  static PopupMenuItem<String> createHoverMenuItem({
    required String text,
    required String value,
    Color? backgroundColor,
    Color? hoverColor,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    required BuildContext context,
  }) {
    return CustomHoverPopupMenuItem(
      text: text,
      value: value,
      backgroundColor: backgroundColor ?? Colors.transparent,
      hoverColor: hoverColor ?? Theme.of(context).customColors.lightBoxBGColor,
      textStyle: textStyle,
      itemPadding: padding,
      borderRadius: borderRadius ?? 0,
    );
  }

  static PopupMenuItem<String> createSimpleMenuItem({
    required String text,
    required String value,
    EdgeInsets? padding,
    TextStyle? textStyle,
  }) {
    return PopupMenuItem<String>(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      value: value,
      child: Text(text, style: textStyle),
    );
  }
}

// Custom PopupMenuItem with individual hover states
class CustomHoverPopupMenuItem extends PopupMenuItem<String> {
  final String text;
  final Color? backgroundColor;
  final Color? hoverColor;
  @override
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? itemPadding;
  final double? borderRadius;

  CustomHoverPopupMenuItem({
    super.key,
    required this.text,
    required String super.value,
    this.backgroundColor,
    this.hoverColor,
    this.textStyle,
    this.itemPadding,
    this.borderRadius,
  }) : super(
         padding: EdgeInsets.zero,
         child: _HoverContent(
           text: text,
           backgroundColor: backgroundColor,
           hoverColor: hoverColor,
           textStyle: textStyle,
           padding: itemPadding,
           borderRadius: borderRadius,
         ),
       );
}

class _HoverContent extends StatefulWidget {
  final String text;
  final Color? backgroundColor;
  final Color? hoverColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const _HoverContent({
    required this.text,
    this.backgroundColor,
    this.hoverColor,
    this.textStyle,
    this.padding,
    this.borderRadius,
  });

  @override
  State<_HoverContent> createState() => _HoverContentState();
}

class _HoverContentState extends State<_HoverContent> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (mounted) {
          setState(() => isHovered = true);
        }
      },
      onExit: (_) {
        if (mounted) {
          setState(() => isHovered = false);
        }
      },
      cursor: SystemMouseCursors.click,
      child: Container(
        width: double.infinity,
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color:
              isHovered
                  ? (widget.hoverColor ?? const Color(0xFFF3F4F6))
                  : (widget.backgroundColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
        ),
        child: Text(
          widget.text,
          style:
              widget.textStyle ??
              TextStyle(
                color: Theme.of(context).customColors.blackColor,
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
              ),
        ),
      ),
    );
  }
}
