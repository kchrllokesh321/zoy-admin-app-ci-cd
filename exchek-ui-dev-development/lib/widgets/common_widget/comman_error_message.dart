import 'package:exchek/core/utils/exports.dart';

class CommanErrorMessage extends StatelessWidget {
  final String errorMessage;
  const CommanErrorMessage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8.0,
      children: [
        Icon(Icons.error_outline, color: Theme.of(context).customColors.errorColor, size: 18.0),
        Expanded(
          child: Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
              fontWeight: FontWeight.w400,
              color: Theme.of(context).customColors.errorColor,
            ),
          ),
        ),
      ],
    );
  }
}
