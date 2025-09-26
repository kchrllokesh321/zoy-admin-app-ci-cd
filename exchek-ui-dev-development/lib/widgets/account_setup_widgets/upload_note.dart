import 'package:exchek/core/utils/exports.dart';

class CustomUploadNote extends StatelessWidget {
  final List<String> nots;
  const CustomUploadNote({super.key, required this.nots});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(nots.length, (index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "•",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).customColors.blackColor,
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 15.0, tablet: 16.0, desktop: 16.0),
                fontWeight: FontWeight.w400,
              ),
            ),
            buildSizedboxW(5.0),
            Expanded(
              child: Text(
                nots[index],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).customColors.blackColor,
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 15.0, tablet: 16.0, desktop: 16.0),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.16,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
