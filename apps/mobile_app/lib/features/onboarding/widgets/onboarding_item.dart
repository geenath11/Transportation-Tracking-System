import 'package:flutter/material.dart';

class OnboardingItem {
  final IconData primaryIcon;
  final IconData secondaryIcon;

  final String title;
  final String description;

  const OnboardingItem({
    required this.primaryIcon,
    required this.secondaryIcon,
    required this.title,
    required this.description,
  });
}
