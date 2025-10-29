import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedBusIcon extends StatefulWidget {
  const AnimatedBusIcon({super.key});

  @override
  State<AnimatedBusIcon> createState() => _AnimatedBusIconState();
}

class _AnimatedBusIconState extends State<AnimatedBusIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -4 * (1 - _controller.value)),
          child: child,
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF01406D),
        ),
        child: const Icon(Icons.directions_bus_sharp, color: Colors.white, size: 50),
      ),
    );
  }
}
