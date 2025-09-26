import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:exchek/core/utils/exports.dart';

class AppLoaderWidget extends StatelessWidget {
  final double size;
  final Color? color;
  final double? strokeWidth;

  const AppLoaderWidget({super.key, this.size = 40.0, this.color, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(child: SpinKitFadingCircle(color: color ?? Theme.of(context).customColors.primaryColor, size: size));
  }
}

// Usage example:

/// Basic usage
// AppLoaderWidget()

// With custom size
// AppLoaderWidget(size: 30.0)

// With custom color
// AppLoaderWidget(color: Colors.blue)

// With both custom size and color
// AppLoaderWidget(
//   size: 30.0,
//   color: Colors.blue,
// )
