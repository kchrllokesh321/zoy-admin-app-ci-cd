import 'package:exchek/core/utils/exports.dart';

class HoverCloseButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double? size;
  final double? iconSize;
  final Color? hoverBackgroundColor;
  final Color? hoverIconColor;
  final String? iconPath;

  const HoverCloseButton({
    super.key,
    this.onTap,
    this.size = 50.0,
    this.iconSize = 24.0,
    this.hoverBackgroundColor,
    this.hoverIconColor,
    this.iconPath,
  });

  @override
  State<HoverCloseButton> createState() => _HoverCloseButtonState();
}

class _HoverCloseButtonState extends State<HoverCloseButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isHovered
                    ? (widget.hoverBackgroundColor ?? Theme.of(context).customColors.blackColor?.withValues(alpha: 0.1))
                    : Colors.transparent,
          ),
          child: CustomImageView(
            imagePath: widget.iconPath ?? Assets.images.svgs.icons.icClose.path,
            height: widget.iconSize,
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
