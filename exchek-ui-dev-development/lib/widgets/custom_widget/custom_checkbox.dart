import 'package:exchek/core/utils/exports.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child:
          value
              ? Center(
                child: CustomImageView(
                  imagePath: Assets.images.pngs.authentication.icCheckboxTick.path,
                  height: 24,
                  width: 24,
                ),
              )
              : Center(
                child: CustomImageView(
                  imagePath: Assets.images.pngs.authentication.icCheckboxUntick.path,
                  height: 24,
                  width: 24,
                ),
              ),
    );
  }
}
