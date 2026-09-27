import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../data/model/ticket_model.dart';
import '../../data/services/ticket_service.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Ticket',
          style: AppTextStyles.semiBold.copyWith(
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: FutureBuilder<TicketModel?>(
          future: TicketService.instance.getTicket(ticketId),

          builder: (context, snapshot) {
            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Error
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Failed to load ticket.\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ),
              );
            }

            // Ticket not found
            final ticket = snapshot.data;

            if (ticket == null) {
              return Center(
                child: Text(
                  'Ticket not found.',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 17,
                  ),
                ),
              );
            }

            return _TicketContent(ticket: ticket);
          },
        ),
      ),
    );
  }
}

class _TicketContent extends StatelessWidget {
  const _TicketContent({
    required this.ticket,
  });

  final TicketModel ticket;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        children: [
          // Ticket card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // CeyGo title
                Text(
                  'CEYGO',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 25,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'DIGITAL TICKET',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                // QR CODE
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: QrImageView(
                    data: ticket.ticketId,
                    size: 210,
                    backgroundColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  ticket.ticketId,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 26),

                // FROM → TO
                Row(
                  children: [
                    Expanded(
                      child: _LocationInfo(
                        label: 'FROM',
                        location: ticket.from,
                        time: ticket.departureTime,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 22,
                      ),
                    ),

                    Expanded(
                      child: _LocationInfo(
                        label: 'TO',
                        location: ticket.to,
                        time: ticket.arrivalTime,
                        alignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Divider(
                  height: 1,
                  color: Colors.black12,
                ),

                const SizedBox(height: 18),

                // Ticket information
                _InfoRow(
                  label: 'Date',
                  value: ticket.date,
                ),

                _InfoRow(
                  label: 'Bus',
                  value: ticket.bus,
                ),

                _InfoRow(
                  label: 'Seats',
                  value: ticket.selectedSeats.join(', '),
                ),

                _InfoRow(
                  label: 'Passenger',
                  value: ticket.passengerName,
                ),

                _InfoRow(
                  label: 'Phone',
                  value: ticket.passengerPhone,
                ),

                _InfoRow(
                  label: 'Total',
                  value:
                  'Rs. ${ticket.totalPrice.toStringAsFixed(0)}',
                ),

                const SizedBox(height: 18),

                // Status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: ticket.ticketStatus == 'valid'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      ticket.ticketStatus == 'valid'
                          ? 'PAID • VALID'
                          : ticket.ticketStatus.toUpperCase(),
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 13,
                        color: ticket.ticketStatus == 'valid'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Show this QR code to the conductor when boarding.',
            textAlign: TextAlign.center,
            style: AppTextStyles.regular.copyWith(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationInfo extends StatelessWidget {
  const _LocationInfo({
    required this.label,
    required this.location,
    required this.time,
    required this.alignment,
  });

  final String label;
  final String location;
  final String time;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: AppTextStyles.regular.copyWith(
            fontSize: 11,
            color: Colors.black54,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          location,
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
          style: AppTextStyles.semiBold.copyWith(
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          time,
          style: AppTextStyles.regular.copyWith(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.regular.copyWith(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),

          const SizedBox(width: 20),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}