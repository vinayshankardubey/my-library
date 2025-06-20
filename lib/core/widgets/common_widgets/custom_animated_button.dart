import 'package:flutter/material.dart';
import 'custom_text.dart';
class CustomAnimatedButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? child;
  final double scaleLowerBound;
  final Duration animationDuration;
  final String text;
  final Color? color;
  final double width;
  final bool isLoading;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Widget? preWidget;
  final BoxDecoration? decoration;
  final EdgeInsets? insidePadding;

  const CustomAnimatedButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.width = double.infinity,
    this.textStyle,
    this.borderRadius,
    this.preWidget,
    this.decoration,
    this.isLoading = false,
    this.scaleLowerBound = 0.9, // Minimum scale when pressed
    this.animationDuration = const Duration(milliseconds: 100),
    this.child,
    this.insidePadding
  });

  @override
  State<CustomAnimatedButton> createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _buttonScale = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..addListener(() {
      setState(() {
        _buttonScale = 1 - (_controller.value * (1 - widget.scaleLowerBound));
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.forward().then((onValue){
      _reverseAnimation();
      if(widget.onTap != null){
        widget.onTap!.call();
      }

    });
  }

  void _reverseAnimation() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _startAnimation(),
      child: Transform.scale(
        scale: _buttonScale,
        child: IntrinsicWidth(
          child: Container(
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust padding for better appearance
            decoration: widget.decoration ?? BoxDecoration(
              color: widget.color ?? Colors.black,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0,),
            ),
            alignment: Alignment.center,
            child:Padding(
              padding: widget.insidePadding??EdgeInsets.all( 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!widget.isLoading)widget.preWidget ?? const SizedBox(),
                  if(widget.isLoading)Center(child: const CircularProgressIndicator(color: Colors.white,)),
                  if(!widget.isLoading)CustomText(
                    text:  widget.text,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
