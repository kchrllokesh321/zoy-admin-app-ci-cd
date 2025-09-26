import 'package:exchek/core/utils/exports.dart';

class StepperSlider<T> extends StatelessWidget {
  const StepperSlider({
    super.key,
    required this.currentStep,
    required this.steps,
    required this.title,
    this.isShowTitle = true,
    this.isFullSlider = false,
  });

  final T currentStep;
  final List<T> steps;
  final String title;
  final bool isShowTitle;
  final bool isFullSlider;

  @override
  Widget build(BuildContext context) {
    final int stepIndex = steps.indexOf(currentStep);
    final int totalStep = steps.length;
    final double progress = (stepIndex + 1) / totalStep;

    return Column(
      children: [
        if (!isShowTitle) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 23, desktop: 24),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.24,
                  ),
                ),
              ),
              buildSizedboxW(20.0),
              Text(
                "${stepIndex + 1}/$totalStep",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 22, tablet: 23, desktop: 24),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                ),
              ),
            ],
          ),
          buildSizedBoxH(25.0),
        ],
        Stack(
          children: [
            LinearProgressIndicator(
              value: progress,
              minHeight: isFullSlider ? 7 : 10,
              backgroundColor: Theme.of(context).customColors.lightBorderColor,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent), // Hide default color
              borderRadius: isFullSlider ? BorderRadius.circular(0) : BorderRadius.circular(10),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: ClipRRect(
                    borderRadius:
                        isFullSlider ? BorderRadius.circular(0) : BorderRadius.horizontal(right: Radius.circular(10)),
                    child: Container(
                      height: isFullSlider ? 7 : 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF8892FF), Theme.of(context).colorScheme.primary]),
                        borderRadius:
                            isFullSlider
                                ? BorderRadius.horizontal(right: Radius.circular(10))
                                : BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
