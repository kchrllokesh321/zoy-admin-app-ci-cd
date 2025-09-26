import 'package:exchek/core/utils/exports.dart';

class GetHelpTextButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GetHelpTextButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isWebAndIsNotMobile(context)) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSizedBoxH(10.0),
        GestureDetector(
          onTap: onTap,
          child: Text(
            Lang.of(context).lbl_get_help,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 12.0, tablet: 13.0, desktop: 14.0),
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationThickness: 1.5,
            ),
          ),
        ),
        buildSizedBoxH(20.0),
      ],
    );
  }
}
