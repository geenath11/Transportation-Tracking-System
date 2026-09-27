import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/user_profile_service.dart';
import '../../../../core/theme/app_text_styles.dart';

import 'package:transportation_tracking_system/features/payment/presentation/widgets/payment_method_card.dart';

import 'package:transportation_tracking_system/features/ticket/data/model/ticket_model.dart';
import 'package:transportation_tracking_system/features/ticket/data/services/ticket_service.dart';
import 'package:transportation_tracking_system/features/ticket/presentation/screens/ticket_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.date,
    required this.from,
    required this.to,
    required this.ticketPrice,
    required this.selectedSeats,
    required this.totalPrice,
    required this.arrivalTime,
    required this.departureTime,
    required this.bus,
  });

  final String from;
  final String to;
  final int ticketPrice;
  final Set<int> selectedSeats;
  final int totalPrice;
  final String arrivalTime;
  final String departureTime;
  final String date;
  final String bus;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const int bookingFee = 20;

  bool _isProcessing = false;

  Future<void> _completePayment() async {
    if (_isProcessing) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in before purchasing a ticket.'),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Generate a unique ticket ID.
      final ticketId =
          'CEYGO-${DateTime.now().millisecondsSinceEpoch}';

      // Convert Set<int> to List<String>
      // Example: {1, 4, 8} -> ["1", "4", "8"]
      final seats = widget.selectedSeats
          .map((seat) => seat.toString())
          .toList();

      // Create the ticket object.
      final ticket = TicketModel(
        ticketId: ticketId,
        userId: user.uid,

        passengerName: UserProfileService.instance.name,
        passengerPhone: UserProfileService.instance.phone,

        from: widget.from,
        to: widget.to,

        date: widget.date,
        departureTime: widget.departureTime,
        arrivalTime: widget.arrivalTime,

        bus: widget.bus,
        selectedSeats: seats,

        // Include booking fee in the stored total.
        totalPrice: widget.totalPrice + 20,

        // University-project payment simulation.
        paymentStatus: 'paid',

        // Ticket is available for use.
        ticketStatus: 'valid',
      );

      // Save ticket to Firestore.
      await TicketService.instance.createTicket(ticket);

      if (!mounted) return;

      // Go to success screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TicketSuccessScreen(
            ticketId: ticketId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment failed: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final passengerName = UserProfileService.instance.name;
    final passengerPhone = UserProfileService.instance.phone;

    final grandTotal = widget.totalPrice + bookingFee;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          'Payment',
          style: AppTextStyles.semiBold.copyWith(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Trip Summary',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // -------------------------
              // TRIP SUMMARY
              // -------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.date,
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Route and times
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.departureTime,
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.from,
                                style: AppTextStyles.regular.copyWith(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.arrivalTime,
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.to,
                                style: AppTextStyles.regular.copyWith(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Divider(
                      height: 1,
                      color: Colors.black12,
                    ),

                    const SizedBox(height: 16),

                    _infoRow(
                      label: 'Bus',
                      value: widget.bus,
                    ),

                    const SizedBox(height: 12),

                    _infoRow(
                      label: 'Passenger',
                      value: passengerName,
                    ),

                    const SizedBox(height: 12),

                    _infoRow(
                      label: 'Phone',
                      value: passengerPhone,
                    ),

                    const SizedBox(height: 12),

                    _infoRow(
                      label: 'Seats',
                      value: widget.selectedSeats.length.toString(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Price Summary',
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  children: [
                    _priceRow(
                      'Tickets x ${widget.selectedSeats.length}',
                      'Rs. ${widget.totalPrice}',
                    ),

                    const SizedBox(height: 12),

                    _priceRow(
                      'Booking fee',
                      'Rs. $bookingFee',
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Divider(
                        height: 1,
                        color: Colors.black12,
                      ),
                    ),

                    _priceRow(
                      'Total',
                      'Rs. $grandTotal',
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const PaymentMethodCard(),

              const SizedBox(height: 24),

              // -------------------------
              // PAY BUTTON
              // -------------------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : _completePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3339EC),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    'Pay Rs. $grandTotal',
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.regular.copyWith(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
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
    );
  }

  Widget _priceRow(
      String label,
      String value, {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.semiBold.copyWith(
            fontSize: 17,
          )
              : AppTextStyles.regular.copyWith(
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.semiBold.copyWith(
            fontSize: 18,
          )
              : AppTextStyles.regular.copyWith(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}