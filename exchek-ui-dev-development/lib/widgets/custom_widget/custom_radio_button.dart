import 'package:exchek/core/utils/exports.dart';

class CustomRadioButton extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final bool isDisabled;

  const CustomRadioButton({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged(value),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            groupValue == value
                ? Container(
                  height: 18.0,
                  width: 18.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).customColors.primaryColor!, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).customColors.primaryColor!,
                    ),
                  ),
                )
                : Container(
                  height: 18.0,
                  width: 18.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF343A3E), width: 1.5),
                  ),
                ),
            buildSizedboxW(8.0),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                  fontWeight: FontWeight.w400,
                  height: 1.22,
                  color: isDisabled ? Theme.of(context).customColors.textdarkcolor?.withValues(alpha: 0.5) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
