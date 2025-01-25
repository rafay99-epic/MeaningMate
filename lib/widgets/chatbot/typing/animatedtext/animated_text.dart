import 'package:flutter/material.dart';

class AnimatedTypingText extends StatefulWidget {
  const AnimatedTypingText({super.key});

  @override
  State<AnimatedTypingText> createState() => _AnimatedTypingTextState();
}

class _AnimatedTypingTextState extends State<AnimatedTypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = IntTween(begin: 0, end: 3).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final dots = '.' * (_animation.value + 1);
        return Text(
          'LingoBot is thinking$dots',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
