import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';

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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),

              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DestinationField(
                    key: ValueKey('from-$fromValue'),
                    hintText: 'Your Starting point',
                    value: fromValue,
                    destinations: destinations,
                    onSelected: onFromSelected,
                  ),

                  const SizedBox(height: 16),

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
              right: -12,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SwapButton(onTap: onSwap),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
