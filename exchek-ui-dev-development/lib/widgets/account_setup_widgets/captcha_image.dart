import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';

class Base64CaptchaField extends StatefulWidget {
  final String base64Image;
  const Base64CaptchaField({super.key, required this.base64Image});

  @override
  State<Base64CaptchaField> createState() => _Base64CaptchaFieldState();
}

class _Base64CaptchaFieldState extends State<Base64CaptchaField> {
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  @override
  void didUpdateWidget(covariant Base64CaptchaField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.base64Image != widget.base64Image) {
      _decodeImage();
    }
  }

  void _decodeImage() {
    _imageBytes = base64Decode(widget.base64Image.trim());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 48, child: Image.memory(_imageBytes, fit: BoxFit.fill));
  }
}
