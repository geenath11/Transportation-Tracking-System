import 'package:flutter/material.dart';
import 'destination_field.dart';
import 'swap_button.dart';

class RouteSelectorCard extends StatelessWidget {
  final String fromValue;
  final String toValue;
  final List<String> destinations;
  final ValueChanged<String> onFromSelected;
  final ValueChanged<String> onToSelected;
  final VoidCallback onSwap;

  const RouteSelectorCard({
    super.key,
    required this.fromValue,
    required this.toValue,
    required this.destinations,
    required this.onFromSelected,
    required this.onToSelected,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 188,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          decoration: BoxDecoration(
            color: const Color(0xFF0D56FF),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              DestinationField(
                key: ValueKey('from-$fromValue'),
                hintText: 'Your Starting point',
                value: fromValue,
                destinations: destinations,
                onSelected: onFromSelected,
              ),
              const SizedBox(height: 20),
              DestinationField(
                key: ValueKey('to-$toValue'),
                hintText: 'Your Destination',
                value: toValue,
                destinations: destinations,
                onSelected: onToSelected,
              ),
            ],
          ),
        ),
        Positioned(
          right: -14,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
              ),
              child: SwapButton(onTap: onSwap),
            ),
          ),
        ),
      ],
    );
  }
}
