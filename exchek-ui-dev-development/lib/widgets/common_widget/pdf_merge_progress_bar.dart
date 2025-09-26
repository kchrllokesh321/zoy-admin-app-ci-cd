import 'package:exchek/core/utils/exports.dart';

class PdfMergeProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final String? status;
  final String helperText;

  const PdfMergeProgressBar({
    super.key,
    required this.progress,
    this.status,
    this.helperText = "Merging your PDF Please don't refresh or close this page.",
  });

  @override
  Widget build(BuildContext context) {
    final double safeProgress = progress.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).customColors.fillColor,
            border: Border.all(color: Theme.of(context).customColors.borderColor!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: safeProgress,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(8.0),
                      backgroundColor: const Color(0xFFF5F5F5),
                      color: Theme.of(context).customColors.primaryColor,
                    ),
                  ),
                  buildSizedboxW(12.0),
                  Text(
                    '${((safeProgress * 100).clamp(0, 100)).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              buildSizedBoxH(8.0),
              Row(
                children: [
                  CustomImageView(imagePath: Assets.images.svgs.icons.icInfoCircle.path, height: 12.0, width: 12.0),
                  buildSizedboxW(8.0),
                  Text(
                    helperText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).customColors.textdarkcolor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
