import 'package:exchek/core/utils/exports.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;

  const CustomErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_ErrorIcon(), SizedBox(height: 16), _ErrorText(errorMessage: errorMessage, context: context)],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.error, size: 48, color: Theme.of(context).colorScheme.error);
  }
}

class _ErrorText extends StatelessWidget {
  final String errorMessage;
  final BuildContext context;

  const _ErrorText({required this.errorMessage, required this.context});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
