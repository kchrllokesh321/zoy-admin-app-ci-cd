import 'package:exchek/core/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? web;

  const ResponsiveLayout({super.key, required this.mobile, this.tablet, this.desktop, this.web});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktop(context)) {
          return desktop ?? mobile;
        } else if (ResponsiveHelper.isTablet(context)) {
          return tablet ?? mobile;
        } else if (ResponsiveHelper.isMobile(context)) {
          return web ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveOrientationLayout extends StatelessWidget {
  final Widget portrait;
  final Widget? landscape;

  const ResponsiveOrientationLayout({super.key, required this.portrait, this.landscape});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return landscape ?? portrait;
        }
        return portrait;
      },
    );
  }
}
