import 'package:exchek/core/utils/exports.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: height ?? ResponsiveHelper.getScreenWidth(context),
        height: width ?? ResponsiveHelper.getScreenHeight(context) * 0.35,
        child: WaveWidget(
          config: CustomConfig(
            gradients: [
              [
                Theme.of(context).customColors.primaryColor!.withValues(alpha: 0.1),
                Theme.of(context).customColors.primaryColor!.withValues(alpha: 0.1),
              ],
              [Theme.of(context).customColors.primaryColor!, Theme.of(context).customColors.primaryColor!],
            ],
            durations: const [12000, 8000],
            heightPercentages: const [0.20, 0.25],
          ),
          waveAmplitude: 20,
          backgroundColor: Colors.transparent,
          size: const Size(double.infinity, double.infinity),
        ),
      ),
    );
  }
}
