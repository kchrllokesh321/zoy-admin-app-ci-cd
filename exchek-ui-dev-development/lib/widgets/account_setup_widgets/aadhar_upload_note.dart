import 'package:exchek/core/utils/exports.dart';

class UploadNote extends StatelessWidget {
  final List<String> notes;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double spacing;
  final String? title;

  const UploadNote({
    super.key,
    required this.notes,
    this.padding = const EdgeInsets.all(20.0),
    this.backgroundColor,
    this.spacing = 14.0,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.customColors.darkBlueColor,
      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 14.0, desktop: 14.0),
      fontWeight: FontWeight.w400,
      letterSpacing: 0.16,
    );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.customColors.lightBlueColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: theme.customColors.lightBlueBorderColor!),
        boxShadow: [
          BoxShadow(color: Color(0xFF100B27).withValues(alpha: 0.08), blurRadius: 16.0, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(imagePath: Assets.images.svgs.icons.icInfo.path, height: 24.0, width: 24.0),
          buildSizedboxW(16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "Upload Instructions",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.customColors.darkBlueColor,
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 14.0, desktop: 14.0),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.16,
                  ),
                ),
                Column(
                  children: List.generate(notes.length, (index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("•", style: textStyle),
                        buildSizedboxW(5.0),
                        Expanded(child: Text(notes[index], style: textStyle)),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
