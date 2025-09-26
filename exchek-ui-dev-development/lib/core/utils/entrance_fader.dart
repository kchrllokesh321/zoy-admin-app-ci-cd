import 'package:flutter/material.dart';

enum SlideDirection { leftToRight, rightToLeft, topToBottom, bottomToTop }

class EntranceFader extends StatefulWidget {
  /// Child to be animated on entrance
  final Widget child;

  /// Delay after which the animation will start
  final Duration delay;

  /// Duration of entrance animation
  final Duration duration;

  /// Direction of the slide animation
  final SlideDirection slideDirection;

  /// Distance to slide (default is 100 pixels)
  final double slideDistance;

  const EntranceFader({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 400),
    this.slideDirection = SlideDirection.rightToLeft,
    this.slideDistance = 100.0,
  });

  @override
  EntranceFaderState createState() {
    return EntranceFaderState();
  }
}

class EntranceFaderState extends State<EntranceFader> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _dxAnimation;
  Animation? _dyAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Calculate offset based on slide direction
    Offset startOffset = _getStartOffset();
    _dxAnimation = Tween(begin: startOffset.dx, end: 0.0).animate(_controller!);
    _dyAnimation = Tween(begin: startOffset.dy, end: 0.0).animate(_controller!);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller!.forward();
      }
    });
  }

  Offset _getStartOffset() {
    switch (widget.slideDirection) {
      case SlideDirection.leftToRight:
        return Offset(-widget.slideDistance, 0.0);
      case SlideDirection.rightToLeft:
        return Offset(widget.slideDistance, 0.0);
      case SlideDirection.topToBottom:
        return Offset(0.0, -widget.slideDistance);
      case SlideDirection.bottomToTop:
        return Offset(0.0, widget.slideDistance);
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder:
          (context, child) => Opacity(
            opacity: _controller!.value,
            child: Transform.translate(offset: Offset(_dxAnimation!.value, _dyAnimation!.value), child: widget.child),
          ),
    );
  }
}
