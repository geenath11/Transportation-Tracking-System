import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';
import 'package:transportation_tracking_system/core/widgets/custom_button.dart';
import 'package:transportation_tracking_system/features/search/presentation/widgets/route_selector_card.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/date_selecting.dart';
import '../widgets/ticket_card.dart';
import '../controller/search_controller.dart';
import '../widgets/ticket_confirmation_sheet.dart';
import 'package:intl/intl.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TicketSearchController ticketSearchController =
      TicketSearchController.instance;

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

  @override
  void initState() {
    super.initState();

    ticketSearchController.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    ticketSearchController.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _swapLocations() {
    setState(() {
      final temp = fromLocation;
      fromLocation = toLocation;
      toLocation = temp;
    });

    ticketSearchController.swapLocations();
  }

  Future<void> _searchTickets() async {
    await ticketSearchController.searchTickets();
  }

  void _showTicketConfirmation(TicketModel ticket, DateTime? selectedDate) {
    final String formattedDate = selectedDate != null
        ? DateFormat('EEEE, d MMMM').format(selectedDate)
        : 'Date not selected';

    showModalBottomSheet(

      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TicketConfirmationSheet(
          departureCity: ticket.departureCity,
          arrivalCity: ticket.arrivalCity,
          departureTime: ticket.departureTime,
          arrivalTime: ticket.arrivalTime,
          busType: ticket.busType,
          adultPrice: ticket.adultPrice,
          childPrice: ticket.childPrice,
          date: formattedDate,
        );
      },
    );
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
                  'Route Selection',
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 15),

                RouteSelectorCard(
                  fromValue: fromLocation,
                  toValue: toLocation,
                  destinations: destinations,

                  onFromSelected: (destination) {
                    setState(() {
                      fromLocation = destination;
                    });

                    ticketSearchController.setFromLocation(destination);
                  },

                  onToSelected: (destination) {
                    setState(() {
                      toLocation = destination;
                    });

                    ticketSearchController.setToLocation(destination);
                  },

                  onSwap: _swapLocations,
                ),

                const SizedBox(height: 5),

                DateSelector(
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });

                    ticketSearchController.setSelectedDate(date);
                  },
                ),

                const SizedBox(height: 20),

                Center(
                  child: AppButton(
                    onPressed: ticketSearchController.isLoading
                        ? null
                        : _searchTickets,
                    child: ticketSearchController.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : Text(
                            'Search Tickets',
                            style: AppTextStyles.semiBold.copyWith(
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                if (ticketSearchController.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      ticketSearchController.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                Column(
                  children: ticketSearchController.tickets.map((ticket) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TicketCard(
                        departureTime: ticket.departureTime,
                        departureCity: ticket.departureCity,
                        arrivalTime: ticket.arrivalTime,
                        arrivalCity: ticket.arrivalCity,
                        busType: ticket.busType,
                        adultPrice: ticket.adultPrice,
                        childPrice: ticket.childPrice,



                        onGetTickets: () {
                          _showTicketConfirmation(ticket,selectedDate,);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
