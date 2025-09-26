import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:google_fonts/google_fonts.dart';

class AppToast {
  static void show({
    required String message,
    ToastificationType type = ToastificationType.success,
    Duration duration = const Duration(seconds: 3),
    bool showProgressBar = false,
  }) {
    toastification.show(
      type: type,
      showProgressBar: showProgressBar,
      style: ToastificationStyle.flatColored,
      title: Text(message, style: GoogleFonts.montserrat(fontSize: 15.0, fontWeight: FontWeight.w500), maxLines: 10),
      autoCloseDuration: duration,
    );
  }
}
