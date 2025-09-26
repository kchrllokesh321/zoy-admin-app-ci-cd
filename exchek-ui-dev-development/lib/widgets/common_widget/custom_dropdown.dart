import 'package:exchek/core/utils/exports.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T selectedItem;
  final Function(T) onChanged;
  final String Function(T) itemTextBuilder;
  final double? fontSize;
  final Color? textColor;
  final double? iconSize;
  final EdgeInsets? padding;
  final String? hintText;
  final bool isExpanded;
  final Color? iconColor;
  final double? maxMenuHeight;
  final double? menuWidth;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemTextBuilder,
    this.fontSize,
    this.textColor,
    this.iconSize,
    this.padding,
    this.hintText,
    this.isExpanded = false,
    this.iconColor,
    this.maxMenuHeight,
    this.menuWidth,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final GlobalKey<PopupMenuButtonState> _popupKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<T>(
      key: _popupKey,
      constraints: BoxConstraints(
        maxHeight: widget.maxMenuHeight ?? double.infinity,
        maxWidth: widget.menuWidth ?? double.infinity,
      ),
      itemBuilder:
          (context) =>
              widget.items.map((item) {
                return PopupMenuItem<T>(
                  value: item,
                  child: Text(
                    widget.itemTextBuilder(item),
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: widget.textColor ?? theme.customColors.blackColor,
                      fontSize:
                          widget.fontSize ??
                          ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
                    ),
                  ),
                );
              }).toList(),
      onSelected: widget.onChanged,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isExpanded)
              Expanded(
                child: Text(
                  widget.hintText ?? widget.itemTextBuilder(widget.selectedItem),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    color:
                        widget.hintText != null
                            ? (widget.textColor ?? theme.customColors.textdarkcolor)
                            : (widget.textColor ?? theme.customColors.blackColor),
                    fontSize:
                        widget.fontSize ??
                        ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
                  ),
                ),
              )
            else
              Text(
                widget.hintText ?? widget.itemTextBuilder(widget.selectedItem),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  color:
                      widget.hintText != null
                          ? (widget.textColor ?? theme.customColors.textdarkcolor)
                          : (widget.textColor ?? theme.customColors.blackColor),
                  fontSize:
                      widget.fontSize ??
                      ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
                ),
              ),
            buildSizedboxW(12.0),
            CustomImageView(
              imagePath: Assets.images.svgs.icons.icArrowForward.path,
              height: widget.iconSize ?? 20.0,
              width: widget.iconSize ?? 20.0,
              onTap: () {
                // Open the popup menu when arrow is clicked
                _popupKey.currentState?.showButtonMenu();
              },
              color: widget.iconColor ?? theme.customColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
