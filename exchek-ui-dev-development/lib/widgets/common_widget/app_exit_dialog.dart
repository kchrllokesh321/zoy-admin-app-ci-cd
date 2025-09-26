import 'package:exchek/core/utils/exports.dart';

Future<void> showExitConfirmationDialog(BuildContext context) async {
  final shouldExit = await showDialog<bool>(
    context: context,
    builder:
        (context) => Dialog(
          backgroundColor: Theme.of(context).customColors.fillColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          insetPadding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Exit App',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
                buildSizedBoxH(20.0),
                Text(
                  'Are you sure you want to exit?',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Theme.of(context).customColors.secondaryTextColor,
                  ),
                ),
                buildSizedBoxH(20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        buttonStyle: ButtonThemeHelper.textButtonStyle(context),
                        text: "Cancel",
                        buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Theme.of(context).customColors.primaryColor,
                        ),
                        onPressed: () {
                          GoRouter.of(context).pop(false);
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomElevatedButton(
                        text: "Exit",
                        borderRadius: 50.0,
                        buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          GoRouter.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
  );

  if (shouldExit == true) {
    exit(0);
  }
}
