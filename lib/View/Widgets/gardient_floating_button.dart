import 'package:flutter/material.dart';

class GradientFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  GradientFloatingButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(16.0),
          elevation: 0,
        ),
        onPressed: () => onPressed(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
