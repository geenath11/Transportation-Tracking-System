import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import 'package:transportation_tracking_system/core/services/user_profile_service.dart';

import '../widgets/lib/features/payment/presentation/widgets/payment_method_card.dart';

class PaymentScreen extends StatelessWidget {
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

  static const int bookingFee = 20;

  @override
  Widget build(BuildContext context) {
    final passengerName = UserProfileService.instance.name;
    final passengerPhone = UserProfileService.instance.phone;

    final grandTotal = totalPrice + bookingFee;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          'Payment',
          style: AppTextStyles.semiBold.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
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
                  style: AppTextStyles.semiBold.copyWith(fontSize: 18),
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
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Text(
                      date,
                      style: AppTextStyles.semiBold.copyWith(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    // Route and times
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                departureTime,
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                from,
                                style: AppTextStyles.regular.copyWith(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.arrow_forward_rounded, size: 20),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                arrivalTime,
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                to,
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

                    const Divider(height: 1, color: Colors.black12),

                    const SizedBox(height: 16),

                    // Bus
                    _infoRow(label: 'Bus', value: bus),

                    const SizedBox(height: 12),

                    // Passenger
                    _infoRow(label: 'Passenger', value: passengerName),

                    const SizedBox(height: 12),

                    // Phone
                    _infoRow(label: 'Phone', value: passengerPhone),

                    const SizedBox(height: 12),

                    // Seats
                    _infoRow(
                      label: 'Seats',
                      value: selectedSeats.length.toString(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),


              Text(
                'Price Summary',
                style: AppTextStyles.semiBold.copyWith(fontSize: 17),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    _priceRow(
                      'Tickets x ${selectedSeats.length}',
                      'Rs. $totalPrice',
                    ),

                    const SizedBox(height: 12),

                    _priceRow('Booking fee', 'Rs. $bookingFee'),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: Colors.black12),
                    ),

                    _priceRow('Total', 'Rs. $grandTotal', isTotal: true),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const PaymentMethodCard(),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Payment action will go here.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3339EC),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(
                    'Pay Rs. $grandTotal',
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({required String label, required String value}) {
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
            style: AppTextStyles.semiBold.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.semiBold.copyWith(fontSize: 17)
              : AppTextStyles.regular.copyWith(fontSize: 15),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.semiBold.copyWith(fontSize: 18)
              : AppTextStyles.regular.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}
