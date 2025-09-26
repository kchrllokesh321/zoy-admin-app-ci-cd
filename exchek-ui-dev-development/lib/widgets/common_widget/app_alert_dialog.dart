import 'package:exchek/core/utils/exports.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onConfirmButtonPressed;
  final VoidCallback? onCancelButtonPressed;
  final String confirmButtonText;
  final String? cancelButtonText;
  final bool singleButton;
  final bool? isLoading;
  final bool? isredius;
  final double? imageheight;
  final double? imagewidth;
  final double? width;
  final BoxFit? fit;
  final Widget? child;
  final bool isclosebuttonshow;

  const CustomAlertDialog({
    super.key,
    this.imagePath,
    required this.title,
    required this.subtitle,
    this.onConfirmButtonPressed,
    required this.confirmButtonText,
    this.cancelButtonText,
    this.singleButton = false,
    this.isLoading,
    this.isredius = false,
    this.onCancelButtonPressed,
    this.imageheight,
    this.imagewidth,
    this.width,
    this.fit,
    this.child,
    this.isclosebuttonshow = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(40),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      content: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(isredius == true ? 0 : 16.0)),
                child: CustomImageView(
                  imagePath: imagePath,
                  height: imageheight ?? 60,
                  width: imagewidth,
                  fit: fit ?? BoxFit.cover,
                ),
              ),
              if (isclosebuttonshow)
                CustomImageView(
                  imagePath: Assets.images.svgs.icons.icClose.path,
                  height: 24,
                  fit: fit ?? BoxFit.cover,
                  alignment: Alignment.topRight,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              if (isclosebuttonshow) buildSizedBoxH(16),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              buildSizedBoxH(16),
              subtitle == ""
                  ? const SizedBox.shrink()
                  : Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
              child ?? SizedBox.shrink(),
              buildSizedBoxH(16),
              if (singleButton)
                CustomElevatedButton(isDisabled: isLoading!, onPressed: onConfirmButtonPressed, text: confirmButtonText)
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        height: 45,
                        buttonStyle: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
                        isDisabled: isLoading!,
                        buttonTextStyle: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 16.0),
                        onPressed: onCancelButtonPressed ?? () => Navigator.pop(context),
                        text: cancelButtonText ?? Lang.of(context).lbl_Cancel,
                      ),
                    ),
                    buildSizedboxW(16),
                    Expanded(
                      child: CustomElevatedButton(
                        height: 45,
                        onPressed: onConfirmButtonPressed,
                        text: confirmButtonText,
                        isLoading: isLoading!,
                        isDisabled: isLoading!,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
