import 'package:exchek/core/utils/exports.dart';

/// A customizable text input field that supports showing info messages instead of error messages
/// when AutovalidateMode.onUserInteraction is active.
///
/// Usage examples:
///
/// 1. Show info messages for all validation errors:
/// ```dart
/// CustomTextInputField(
///   context: context,
///   type: InputType.email,
///   controller: emailController,
///   hintLabel: "Enter your email",
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return "Email is required";
///     }
///     if (!value.contains('@')) {
///       return "Please enter a valid email";
///     }
///     return null;
///   },
///   autovalidateMode: AutovalidateMode.onUserInteraction,
///   showInfoInsteadOfError: true, // This will show info messages for all validation errors
/// )
/// ```
///
/// 2. Show info messages only for specific validation messages:
/// ```dart
/// CustomTextInputField(
///   context: context,
///   type: InputType.text,
///   controller: gstController,
///   validator: ExchekValidations.validateGST,
///   autovalidateMode: AutovalidateMode.onUserInteraction,
///   shouldShowInfoForMessage: ExchekValidations.createInfoMessageChecker([
///     "GST number must be exactly 15 characters long",
///     "Invalid GST number format",
///     "Invalid state code in GST number",
///     "Invalid PAN structure in GST number",
///     "Invalid GST format - 14th character must be Z",
///   ]),
/// )
/// ```
class CustomTextInputField extends StatefulWidget {
  final BuildContext context;
  final TextEditingController? controller;
  final String? hintLabel;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? suffixText;
  final bool? filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputType type;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final BoxConstraints? boxConstraints;
  final BoxConstraints? suffixBoxConstraints;
  final String? Function(String?)? validator;
  final bool? obscuredText;
  final String? obscuringCharacter;
  final int? maxLength;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final InputDecoration? inputDecoration;
  final bool? isDense;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final AutovalidateMode? autovalidateMode;
  final double? textStyleFontSize;
  final bool? enabled;
  final FocusNode? focusNode;
  final double? borderRadius;

  /// When true and autovalidateMode is onUserInteraction, shows info messages instead of error messages
  final bool? showInfoInsteadOfError;
  final List<String>? autofillHints;

  /// Function to determine if info message should be shown based on validation message.
  /// This allows conditional info message display based on specific validation errors.
  /// Return true to show info message, false to show error message.
  final bool Function(String?)? shouldShowInfoForMessage;

  const CustomTextInputField({
    super.key,
    required this.context,
    this.controller,
    this.hintLabel,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText = false,
    this.filled,
    this.fillColor,
    this.contentPadding,
    required this.type,
    this.hintStyle,
    this.textInputAction,
    this.boxConstraints,
    this.validator,
    this.obscuredText,
    this.obscuringCharacter,
    this.maxLength,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputDecoration,
    this.isDense = false,
    this.inputFormatters,
    this.suffixBoxConstraints,
    this.height,
    this.contextMenuBuilder,
    this.autovalidateMode,
    this.textStyleFontSize,
    this.enabled = true,
    this.focusNode,
    this.showInfoInsteadOfError = false,
    this.shouldShowInfoForMessage,
    this.borderRadius,
    this.autofillHints,
  });

  @override
  State<CustomTextInputField> createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  bool _isHovered = false;
  String? _currentValidationMessage;

  bool get _shouldShowInfoMessage {
    if (widget.autovalidateMode != AutovalidateMode.onUserInteraction) {
      return false;
    }

    // If a custom function is provided, use it
    if (widget.shouldShowInfoForMessage != null) {
      return widget.shouldShowInfoForMessage!(_currentValidationMessage);
    }
    // Fallback to the static flag
    return widget.showInfoInsteadOfError == true;
  }

  Color get _messageColor {
    return _shouldShowInfoMessage
        ? (Theme.of(context).customColors.darkBlueColor ?? Theme.of(context).customColors.primaryColor!)
        : Theme.of(context).customColors.errorColor!;
  }

  void _updateValidationMessage() {
    if (widget.autovalidateMode == AutovalidateMode.onUserInteraction && widget.validator != null) {
      final currentValue = widget.controller?.text;
      final newValidationMessage = widget.validator?.call(currentValue);
      if (_currentValidationMessage != newValidationMessage) {
        setState(() {
          _currentValidationMessage = newValidationMessage;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize validation message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateValidationMessage();
    });
  }

  @override
  void didUpdateWidget(CustomTextInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update validation message when widget properties change
    if (oldWidget.controller != widget.controller ||
        oldWidget.validator != widget.validator ||
        oldWidget.autovalidateMode != widget.autovalidateMode) {
      _updateValidationMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextFormField(
        cursorColor: Theme.of(context).customColors.blackColor,
        cursorWidth: 1.2,
        clipBehavior: Clip.antiAlias,
        controller: widget.controller,
        focusNode: widget.focusNode,
        autofillHints: widget.autofillHints,
        keyboardType: _getKeyboardType(),
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        validator: widget.validator,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize:
              widget.textStyleFontSize ?? ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
          fontWeight: FontWeight.w400,
        ),
        obscureText: widget.obscuredText ?? false,
        obscuringCharacter: widget.obscuringCharacter ?? '•',
        maxLength: widget.maxLength,
        enabled: widget.enabled ?? true,
        onChanged: (value) {
          widget.onChanged?.call(value);
          _updateValidationMessage();
        },
        onFieldSubmitted: widget.onFieldSubmitted,
        inputFormatters: widget.inputFormatters,
        decoration:
            widget.inputDecoration ??
            InputDecoration(
              counterText: '',
              hintStyle:
                  widget.hintStyle ??
                  Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize:
                        widget.textStyleFontSize ??
                        ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
                    color: Theme.of(context).customColors.textdarkcolor,
                    fontWeight: FontWeight.w400,
                  ),
              hintText: widget.hintLabel,
              label:
                  widget.label != null
                      ? Text(
                        widget.label!,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize:
                              widget.textStyleFontSize ??
                              ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
                          color: Theme.of(context).customColors.secondaryTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                      : null,
              contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              prefixIcon:
                  widget.prefixIcon != null
                      ? SizedBox(
                        height: ResponsiveHelper.getWidgetHeight(context, mobile: 22, tablet: 24, desktop: 26),
                        width: ResponsiveHelper.getWidgetSize(context, mobile: 22, tablet: 24, desktop: 26),
                        child: widget.prefixIcon,
                      )
                      : null,
              prefixIconConstraints: widget.boxConstraints,
              suffixIconConstraints: widget.suffixBoxConstraints,
              fillColor: widget.fillColor ?? Theme.of(context).customColors.fillColor,
              filled: true,
              errorMaxLines: 2,
              suffixIcon:
                  widget.suffixText == true
                      ? widget.suffixIcon
                      : (widget.suffixIcon != null
                          ? SizedBox(
                            height: ResponsiveHelper.getWidgetHeight(context, mobile: 22, tablet: 24, desktop: 26),
                            width: ResponsiveHelper.getWidgetSize(context, mobile: 22, tablet: 24, desktop: 26),
                            child: widget.suffixIcon,
                          )
                          : null),
              isDense: widget.isDense ?? false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
                borderSide: BorderSide(
                  color:
                      _isHovered
                          ? Theme.of(context).customColors.hoverBorderColor!
                          : Theme.of(context).customColors.borderColor!,
                  width: 1.5,
                ),
              ),
              enabledBorder:
                  _isHovered
                      ? OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 12.0)),
                        borderSide: BorderSide(color: Theme.of(context).customColors.hoverBorderColor!, width: 1.5),
                      )
                      : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
                        borderSide: BorderSide(color: Theme.of(context).customColors.borderColor!, width: 1.5),
                      ),
              focusedBorder:
                  _isHovered
                      ? OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 12.0)),
                        borderSide: BorderSide(color: Theme.of(context).customColors.hoverBorderColor!, width: 1.5),
                      )
                      : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
                        borderSide: BorderSide(color: Theme.of(context).customColors.primaryColor!, width: 1.5),
                      ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
                borderSide: BorderSide(
                  color:
                      _shouldShowInfoMessage
                          ? (_isHovered
                              ? Theme.of(context).customColors.hoverBorderColor!
                              : Theme.of(context).customColors.borderColor!)
                          : Theme.of(context).customColors.redColor!,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
                borderSide: BorderSide(
                  color:
                      _shouldShowInfoMessage
                          ? Theme.of(context).customColors.primaryColor!
                          : Theme.of(context).customColors.redColor!,
                  width: 1.5,
                ),
              ),
            ),
        contextMenuBuilder: widget.contextMenuBuilder ?? _defaultContextMenuBuilder,
        autovalidateMode: widget.autovalidateMode,
        cursorErrorColor: Theme.of(context).customColors.primaryColor,
        errorBuilder: (context, errorText) {
          final resolvedPadding = (widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 20.0)).resolve(
            Directionality.of(context),
          );

          // final iconData =  ? Icons.info_outline : Icons.error_outline;

          return Container(
            transform: Matrix4.translationValues(-resolvedPadding.left, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8.0,
              children: [
                Icon(Icons.error_outline, color: _messageColor, size: 18.0),
                Expanded(
                  child: Text(
                    errorText,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize:
                          widget.textStyleFontSize ??
                          ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
                      fontWeight: FontWeight.w400,
                      color: _messageColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
    if (defaultTargetPlatform == TargetPlatform.iOS && SystemContextMenu.isSupported(context)) {
      return SystemContextMenu.editableText(editableTextState: editableTextState);
    }
    return AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState);
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.phoneNumber:
        return TextInputType.phone;
      case InputType.digits:
        return TextInputType.number;
      case InputType.decimalDigits:
        return const TextInputType.numberWithOptions(decimal: true);
      case InputType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }
}
