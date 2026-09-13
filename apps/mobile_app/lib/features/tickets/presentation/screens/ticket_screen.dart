import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/features/tickets/presentation/widgets/destination_button.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  String fromLocation = 'Badulla';
  String toLocation = 'Kandy';

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
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              DestinationButton(
                label: '   From   ',
                value: fromLocation,
                onTap: () {

                },
              ),
              const SizedBox(height: 16),
              DestinationButton(
                label: 'Where to',
                value: toLocation,
                onTap: () {

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}