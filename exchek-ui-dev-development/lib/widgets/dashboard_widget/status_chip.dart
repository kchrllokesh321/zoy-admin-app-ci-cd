import 'package:exchek/core/utils/exports.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Status:",
          style: theme.textTheme.bodySmall?.copyWith(
            color: Color(0xFF6D6D6D),
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 15),
          ),
        ),
        buildSizedboxW(12.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Theme.of(context).customColors.greenColor,
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).customColors.fillColor,
                    fontWeight: FontWeight.w400,
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 15, tablet: 15, desktop: 16),
                  ),
                ),
              ),
              Container(
                height: 26.0,
                width: 26.0,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).customColors.fillColor),
                child: CustomImageView(imagePath: Assets.images.svgs.icons.icThumb.path, height: 26.0, width: 26.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
