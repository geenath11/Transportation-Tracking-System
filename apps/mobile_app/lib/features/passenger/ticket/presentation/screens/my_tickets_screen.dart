import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../data/model/ticket_model.dart';
import '../../data/services/ticket_service.dart';
import 'ticket_screen.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Tickets',
          style: AppTextStyles.semiBold.copyWith(fontSize: 20),
        ),
      ),

      body: SafeArea(
        child: user == null
            ? Center(
                child: Text(
                  'Please sign in to view your tickets.',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              )
            : StreamBuilder<List<TicketModel>>(
                stream: TicketService.instance.getUserTickets(user.uid),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    debugPrint('Failed to load tickets: ${snapshot.error}');

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Failed to load tickets.\nPlease try again.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regular.copyWith(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  }

                  final tickets = snapshot.data ?? [];

                  if (tickets.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.confirmation_number_outlined,
                              size: 70,
                              color: Colors.black26,
                            ),

                            const SizedBox(height: 20),

                            Text(
                              'No Tickets Yet',
                              style: AppTextStyles.semiBold.copyWith(
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Your booked tickets will appear here.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.regular.copyWith(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                    itemCount: tickets.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];

                      return _TicketCard(
                        ticket: ticket,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TicketScreen(ticketId: ticket.ticketId),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final TicketModel ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CEYGO',
                  style: AppTextStyles.semiBold.copyWith(fontSize: 18),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ticket.ticketStatus == 'valid'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticket.ticketStatus.toUpperCase(),
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 11,
                      color: ticket.ticketStatus == 'valid'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _RouteInfo(
                    label: 'FROM',
                    value: ticket.from,
                    time: ticket.departureTime,
                  ),
                ),

                const Icon(Icons.arrow_forward_rounded, size: 20),

                Expanded(
                  child: _RouteInfo(
                    label: 'TO',
                    value: ticket.to,
                    time: ticket.arrivalTime,
                    alignEnd: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(height: 1, color: Colors.black12),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.date,
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

                Text(
                  'Rs. ${ticket.totalPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.semiBold.copyWith(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seats: ${ticket.selectedSeats.join(', ')}',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: Colors.black45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteInfo extends StatelessWidget {
  const _RouteInfo({
    required this.label,
    required this.value,
    required this.time,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final String time;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.regular.copyWith(
            fontSize: 10,
            color: Colors.black45,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: AppTextStyles.semiBold.copyWith(fontSize: 17),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),

        const SizedBox(height: 3),

        Text(
          time,
          style: AppTextStyles.regular.copyWith(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
