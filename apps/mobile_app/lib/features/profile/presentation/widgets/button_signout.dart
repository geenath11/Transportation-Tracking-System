import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

class ButtonSignout extends StatelessWidget {
  static const _backgroundColor = Color(0xFFE53E3E);
  static const _iconBackgroundColor = Color(0x29FFFFFF);
  final VoidCallback onPressed;
  final double? width;
  final double height;

  const ButtonSignout({
    super.key,
    required this.onPressed,
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
          backgroundColor: _backgroundColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: _backgroundColor.withValues(alpha: 0.18),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
        ),
        child: Row(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: _iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(
                dimension: 34,
                child: Icon(Icons.logout, size: 19, color: Colors.white),
              ),
            ),
            const SizedBox(width: 18),
            Text(
              'Sign Out',
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
