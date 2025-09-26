import 'package:exchek/core/utils/exports.dart';

class ButtonThemeHelper {
  static ButtonStyle borderElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      elevation: 6,
      shadowColor: Theme.of(context).customColors.shadowColor?.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(color: Theme.of(context).customColors.primaryColor!, width: 1),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getWidgetSize(context, mobile: 16, tablet: 20, desktop: 20),
        vertical: ResponsiveHelper.getWidgetHeight(context, mobile: 12, tablet: 14, desktop: 14),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
    );
  }

  static ButtonStyle outlineBorderElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      shadowColor: Theme.of(context).customColors.shadowColor?.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Theme.of(context).customColors.primaryColor!, width: 1),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getWidgetSize(context, mobile: 16, tablet: 20, desktop: 20),
        vertical: ResponsiveHelper.getWidgetHeight(context, mobile: 12, tablet: 14, desktop: 14),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
      backgroundColor: Theme.of(context).customColors.fillColor,
      overlayColor: Colors.transparent,
    );
  }

  static ButtonStyle authElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getWidgetSize(context, mobile: 16, tablet: 20, desktop: 20),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Theme.of(context).customColors.fillColor,
      ),
    );
  }

  static ButtonStyle textButtonStyle(BuildContext context) {
    return ButtonStyle(
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: ResponsiveHelper.getWidgetSize(context, mobile: 16, tablet: 20, desktop: 20)),
      ),
      elevation: WidgetStatePropertyAll(0.0),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        return Colors.transparent;
      }),
      overlayColor: WidgetStatePropertyAll(Theme.of(context).customColors.primaryColor?.withValues(alpha: 0.1)),
      foregroundColor: WidgetStatePropertyAll(Theme.of(context).customColors.primaryColor),
      textStyle: WidgetStatePropertyAll(
        Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }
}
