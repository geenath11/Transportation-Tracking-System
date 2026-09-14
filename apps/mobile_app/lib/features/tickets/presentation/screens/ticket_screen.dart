import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/features/tickets/presentation/widgets/route_selector_card.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  String fromLocation = '';
  String toLocation = '';

  final List<String> destinations = [
    'Badulla',
    'Kandy',
    'Colombo',
    'Ella',
    'Nuwara Eliya',
    'Bandarawela',
    'Mahiyanganaya',
    'Diyatalawa',
  ];

  void _swapLocations() {
    setState(() {
      final temp = fromLocation;
      fromLocation = toLocation;
      toLocation = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ticket Booking',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              RouteSelectorCard(
                fromValue: fromLocation,
                toValue: toLocation,
                destinations: destinations,
                onFromSelected: (destination) {
                  setState(() => fromLocation = destination);
                },
                onToSelected: (destination) {
                  setState(() => toLocation = destination);
                },
                onSwap: _swapLocations,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
