import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BreathingAnimation extends StatefulWidget {
  const BreathingAnimation({super.key});

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'assets/rive/breathing_animation.riv',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
