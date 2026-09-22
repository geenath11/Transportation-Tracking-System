import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';
import 'package:transportation_tracking_system/core/widgets/custom_button.dart';
import 'package:transportation_tracking_system/features/booking/booking_success_screen.dart';

class TicketConfirmationSheet extends StatelessWidget {
  const TicketConfirmationSheet({
    super.key,
    this.departureCity = 'Badulla',
    this.arrivalCity = 'Kandy',
    this.departureTime = '08:30 AM',
    this.arrivalTime = '02:15 PM',
    this.busType = 'Normal',
    required this.adultPrice,
    this.date = 'failed to retrieve the date',
    this.duration = '5h 45m',
    this.departureStand = 'Badulla Bus Stand',
    this.arrivalStand = 'Kandy Bus Stand',
    this.seatsAvailable = 24,
    this.totalSeats = 52,
    this.busNumber = 'ND-4521',
    this.childPrice = 300,
  });

  final String departureCity;
  final String arrivalCity;
  final String departureTime;
  final String arrivalTime;
  final String busType;
  final int adultPrice; // used as adult price
  final String date;
  final String duration;
  final String departureStand;
  final String arrivalStand;
  final int seatsAvailable;
  final int totalSeats;
  final String busNumber;
  final int childPrice;

  static const _primary = Color(0xFF1E4FFF);
  static const _darkPill = Color(0xFF2A3547);
  static const _lavenderBg = Color(0xFFEFF1FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildRouteRow(),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const TextSpan(
                        text: '  •  ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      TextSpan(
                        text: 'Duration - $duration',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _lavenderBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _timeBlock(
                          label: 'Departure',
                          time: departureTime,
                          stand: departureStand,
                          icon: Icons.north_east,
                          iconInCircle: true,
                        ),
                      ),
                      Expanded(
                        child: _timeBlock(
                          label: 'Arrival',
                          time: arrivalTime,
                          stand: arrivalStand,
                          icon: Icons.south_west,
                          iconInCircle: false,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.event_seat_outlined,
                        color: _primary, size: 26),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$seatsAvailable seats ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const TextSpan(
                                text: 'available',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Total seats: $totalSeats',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Service Type: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '$busType   '),
                      const TextSpan(
                        text: 'Bus No.: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: busNumber),
                    ],
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 16),

                _pricePill(icon: Icons.person, label: 'Adult', price: adultPrice),
                const SizedBox(height: 10),
                _pricePill(
                    icon: Icons.child_care, label: 'Child', price: childPrice),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child:SizedBox(
                  height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:  Text('Cancel',style: AppTextStyles.bold.copyWith(fontSize: 15),),
                ),
              ),

    ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  onPressed: () {

                    Navigator.pop(context); // 1. close the bottom sheet FIRST
                    Navigator.push( // 2. THEN navigate
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingSuccessScreen(
                          arrivalTime: arrivalTime,
                          departureTime: departureTime,
                          date: date,
                          bustype: busType,
                        ),
                      ),
                    );
                  },
                  borderRadius: 30,
                child: Text('Confirm',style: AppTextStyles.bold.copyWith(fontSize: 15),),),
              ),
            ],
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRouteRow() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                departureCity,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text('···',
              style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          const Icon(Icons.arrow_forward, size: 16, color: Colors.black54),
          const SizedBox(width: 10),
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black26, width: 1.2),
            ),
            child: Center(
              child: Text(
                arrivalCity,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBlock({
    required String label,
    required String time,
    required String stand,
    required IconData icon,
    required bool iconInCircle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(width: 6),
            iconInCircle
                ? Container(
              padding: const EdgeInsets.all(4),
              decoration:
              const BoxDecoration(color: _primary, shape: BoxShape.circle),
              child: Icon(icon, size: 12, color: Colors.white),
            )
                : Icon(icon, size: 18, color: _primary),
          ],
        ),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(stand, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }

  Widget _pricePill({
    required IconData icon,
    required String label,
    required int price,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: _darkPill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(color: Colors.white, fontSize: 15)),
          Text('Rs. $adultPrice',
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

