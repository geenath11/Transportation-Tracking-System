import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';

class ButtonProfile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? width;
  final double height;

  const ButtonProfile({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.backgroundColor,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.sizeOf(context).width * 0.9,
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFFE2E3FC),
          foregroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 18),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
