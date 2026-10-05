import 'package:flutter/material.dart';

class SwapButton extends StatelessWidget {
  final VoidCallback onTap;

  const SwapButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.swap_vert_rounded,
            color: Color(0xFF0D56FF),
            size: 30,
          ),
        ),
      ),
    );
  }
}
