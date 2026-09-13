import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/features/tickets/presentation/widgets/destination_button.dart';
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
              DestinationButton(
                label: '   From   ',
                value: fromLocation,
                destinations: destinations,
                onSelected: (destination) {
                  setState(() {
                    fromLocation = destination;
                  });
                },
              ),
              const SizedBox(height: 16),
              DestinationButton(
                label: 'Where to',
                value: toLocation,
                destinations: destinations,
                onSelected: (destination) {
                  setState(() {
                    toLocation = destination;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}