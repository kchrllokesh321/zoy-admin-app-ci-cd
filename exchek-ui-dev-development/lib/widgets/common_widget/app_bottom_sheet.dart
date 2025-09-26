import 'dart:ui';
import 'package:exchek/core/utils/exports.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  const CustomBottomSheetWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).customColors.fillColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: child,
      ),
    );
  }
}
