import 'package:exchek/core/utils/exports.dart';

class CustomTileWidget extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showTextField;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isShowTrailing;
  final bool isShowDone;
  final String? leadingImagePath;
  final bool showTrailingCheckbox;
  final Widget? titleWidget;
  final int? maxlength;

  const CustomTileWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.showTextField = false,
    this.controller,
    this.onChanged,
    this.isShowTrailing = false,
    this.isShowDone = false,
    this.leadingImagePath,
    this.showTrailingCheckbox = false,
    this.titleWidget,
    this.maxlength,
  });

  @override
  State<CustomTileWidget> createState() => _CustomTileWidgetState();
}

class _CustomTileWidgetState extends State<CustomTileWidget> {
  bool _isHovered = false;
  late FocusNode _focusNode;
  bool _isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isTextFieldFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = theme.customColors.fillColor;
    final primary = theme.customColors.primaryColor!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          if (widget.showTextField) {
            _focusNode.requestFocus();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 16.0 : 10.0, vertical: kIsWeb ? 20.0 : 15.0),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              width: 1.5,
              color:
                  (widget.isSelected || _isTextFieldFocused)
                      ? primary
                      : _isHovered
                      ? Theme.of(context).customColors.blueColor!.withValues(alpha: 0.2)
                      : Theme.of(context).customColors.boxBorderColor!,
            ),
            boxShadow:
                _isHovered || widget.isSelected || _isTextFieldFocused
                    ? [BoxShadow(color: theme.customColors.hoverShadowColor!.withValues(alpha: 0.8), blurRadius: 4)]
                    : [],
          ),
          child: Row(
            children: [
              if (widget.leadingImagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: CustomImageView(
                    imagePath: widget.leadingImagePath!,
                    height: ResponsiveHelper.getWidgetHeight(context, mobile: 30.0, tablet: 40.0, desktop: 40.0),
                    width: ResponsiveHelper.getWidgetHeight(context, mobile: 30.0, tablet: 40.0, desktop: 40.0),
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: ResponsiveHelper.getWidgetHeight(context, mobile: 30.0, tablet: 40.0, desktop: 40.0),
                  width: ResponsiveHelper.getWidgetHeight(context, mobile: 30.0, tablet: 40.0, desktop: 40.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        (widget.isSelected || _isTextFieldFocused)
                            ? Theme.of(context).customColors.boxBgColor
                            : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: CustomImageView(
                    imagePath: Assets.images.svgs.icons.icPersonalUser.path,
                    color: theme.customColors.blackColor,
                    height: ResponsiveHelper.getWidgetHeight(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
                  ),
                ),
              buildSizedboxW(12.0),

              Expanded(child: widget.titleWidget ?? _buildTitleWidget(theme)),

              if (widget.isShowTrailing)
                if (widget.showTrailingCheckbox)
                  CustomImageView(
                    imagePath:
                        widget.isSelected
                            ? Assets.images.svgs.icons.icCheckboxTick.path
                            : Assets.images.svgs.icons.icUncheckbox.path,
                    height: ResponsiveHelper.getWidgetHeight(context, mobile: 24.0, tablet: 26.0, desktop: 28.0),
                    width: ResponsiveHelper.getWidgetHeight(context, mobile: 24.0, tablet: 26.0, desktop: 28.0),
                    fit: BoxFit.fill,
                  )
                else
                  CustomImageView(
                    imagePath: Assets.images.svgs.icons.icArrowRight.path,
                    height: 24.0,
                    onTap: () {
                      widget.onTap();
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTitleWidget(ThemeData theme) {
    return widget.showTextField
        ? ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 150.0),
          child: TextField(
            focusNode: _focusNode,
            minLines: 1,
            maxLines: null,
            maxLength: widget.maxlength ?? 250,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: widget.controller,
            onChanged: widget.onChanged,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              counterText: "",
              hintText: Lang.of(context).lbl_type_here,
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                color: Theme.of(context).customColors.textdarkcolor,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
              fontWeight: FontWeight.w500,
            ),
          ),
        )
        : widget.isShowDone
        ? LayoutBuilder(
          builder: (context, constrainedBox) {
            return Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constrainedBox.maxWidth - 40.0),
                  child: Text(
                    widget.title,
                    style:
                        widget.isSelected
                            ? theme.textTheme.titleLarge?.copyWith(
                              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.16,
                              height: 1.16,
                            )
                            : theme.textTheme.headlineMedium?.copyWith(
                              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.16,
                              height: 1.16,
                            ),
                  ),
                ),
                buildSizedboxW(8.0),
                CustomImageView(imagePath: Assets.images.svgs.icons.icDone.path, height: 20.0, width: 20.0),
              ],
            );
          },
        )
        : Text(
          widget.title,
          style:
              widget.isSelected
                  ? theme.textTheme.titleLarge?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.16,
                    height: 1.16,
                  )
                  : theme.textTheme.headlineMedium?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.16,
                    height: 1.16,
                  ),
        );
  }
}
