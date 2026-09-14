import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';
import 'package:transportation_tracking_system/features/tickets/presentation/widgets/route_selector_card.dart';
import '../widgets/date_selecting.dart';
import '../widgets/routes_info_card.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  String fromLocation = '';
  String toLocation = '';
  DateTime? selectedDate;
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ticket Booking',
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 5),
                DateSelector(
                  onDateSelected: (date) {
                    setState(() => selectedDate = date);
                  },
                ),
                const SizedBox(height: 5),
                RouteInfoCard(
                  routeFrom: fromLocation.isEmpty ? 'Badulla' : fromLocation,
                  routeTo: toLocation.isEmpty ? 'Kandy' : toLocation,
                  distanceKm: '115 km',
                  date: selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : 'Select date',
                  trips: const [
                    TripInfo(
                      busType: 'Normal',
                      routeNumber: '99',
                      departureTime: '08:30',
                      departureCity: 'Badulla',
                      arrivalTime: '12:00',
                      arrivalCity: 'Kandy',
                    ),
                    TripInfo(
                      busType: 'Normal',
                      routeNumber: '99',
                      departureTime: '10:00',
                      departureCity: 'Badulla',
                      arrivalTime: '13:30',
                      arrivalCity: 'Kandy',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
