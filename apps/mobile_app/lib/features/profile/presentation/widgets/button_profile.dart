import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';

class ButtonProfile extends StatelessWidget {
  static const _defaultBackgroundColor = Color(0xFFEEF0FF);
  static const _defaultIconBackgroundColor = Color(0xFFDDE2FF);
  static const _textColor = Color(0xFF202124);
  static const _arrowColor = Color(0xFF4B4D55);

  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final double? width;
  final double height;

  const ButtonProfile({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.sizeOf(context).width * 0.87,
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? _defaultBackgroundColor,
          foregroundColor: AppColors.primary,
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.20),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: iconBackgroundColor ?? _defaultIconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: 34,
                  child: Icon(
                    icon,
                    size: 19,
                    color: iconColor ?? AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 18),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: _textColor,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: _arrowColor,
            ),
          ],
        ),
      ),
    );
  }
}
