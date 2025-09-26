import 'package:exchek/core/utils/exports.dart';

class PasswordInputField extends StatelessWidget {
  final String label;
  final bool obscure;
  final VoidCallback toggle;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const PasswordInputField({
    super.key,
    required this.label,
    required this.obscure,
    required this.toggle,
    required this.controller,
    this.focusNode,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final customColors = theme.customColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xffD4D7E3), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xffD4D7E3), width: 1.5),
            ),
            errorMaxLines: 2,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xff4E55F4), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xffFF5D5F), width: 1.5),
            ),
            fillColor: Theme.of(context).customColors.fillColor,
            filled: true,
            suffixIconConstraints: BoxConstraints(maxWidth: 70.0),
            suffixIcon: Center(
              child: InkWell(
                mouseCursor: SystemMouseCursors.click,
                onTap: toggle,
                child: CustomImageView(
                  imagePath: obscure ? Assets.images.svgs.icons.icEyeSlash.path : Assets.images.svgs.icons.icEye.path,
                  height: 17.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
