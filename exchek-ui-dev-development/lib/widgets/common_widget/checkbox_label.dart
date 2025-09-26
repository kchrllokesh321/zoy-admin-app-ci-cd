import 'package:exchek/core/utils/exports.dart';

class CustomCheckBoxLabel extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onChanged;
  final String? tooltipMessage;
  final bool isShowInfoIcon;

  const CustomCheckBoxLabel({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onChanged,
    this.tooltipMessage,
    this.isShowInfoIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              isSelected
                  ? Container(
                    height: 18.0,
                    width: 18.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Theme.of(context).customColors.primaryColor,
                    ),
                    child: Icon(Icons.done, color: Theme.of(context).customColors.fillColor, size: 16.0),
                  )
                  : Container(
                    height: 18.0,
                    width: 18.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Theme.of(context).customColors.dividerColor!),
                    ),
                  ),
              buildSizedboxW(4.0),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth - 50),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 14.0, desktop: 16.0),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.16,
                    height: 1.6,
                  ),
                ),
              ),
              if (isShowInfoIcon) ...[
                buildSizedboxW(4.0),
                Tooltip(
                  constraints: BoxConstraints(maxWidth: 300.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).customColors.blackColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 12.0, tablet: 14.0, desktop: 14.0),
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).customColors.fillColor,
                  ),
                  message: tooltipMessage ?? "",
                  child: CustomImageView(
                    imagePath: Assets.images.svgs.icons.icInfoCircle.path,
                    height: 12.0,
                    width: 12.0,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
