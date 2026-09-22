import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  final double? width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;

  const AppButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height = 56,
    this.borderRadius = 15,
    this.backgroundColor = const Color(0xFF0D5BD7),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: child,
      ),
    );
  }
}