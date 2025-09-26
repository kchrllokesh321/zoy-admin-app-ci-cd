import 'package:exchek/core/utils/exports.dart';

class CommanVerifiedInfoBox extends StatelessWidget {
  final String value;
  final bool showTrailingIcon;
  final EdgeInsetsGeometry? padding;

  const CommanVerifiedInfoBox({super.key, required this.value, this.showTrailingIcon = true, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Theme.of(context).customColors.fillColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Theme.of(context).customColors.greenColor!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showTrailingIcon) CustomImageView(imagePath: Assets.images.svgs.icons.icShieldTick.path, height: 20.0),
        ],
      ),
    );
  }
}
