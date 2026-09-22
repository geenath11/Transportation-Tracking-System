import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

import '../../../../core/widgets/custom_button.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.departureTime,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCity,
    required this.busType,
    required this.onGetTickets,
    required this.adultPrice,
    required  this.childPrice,
  });

  final String departureTime;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCity;
  final String busType;
  final VoidCallback onGetTickets;
  final int adultPrice;
  final int childPrice;
  static const Color brandBlue = Color(0xFF3339EC);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Departure',
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      departureTime,
                      style: AppTextStyles.bold.copyWith(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      departureCity,
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),

                child: Icon(Icons.subdirectory_arrow_right_outlined,size: 30,),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Arrival',
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      arrivalTime,
                      style: AppTextStyles.bold.copyWith(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      arrivalCity,
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          RichText(
            text: TextSpan(
              style: AppTextStyles.regular.copyWith(
                fontSize: 13,
                color: Colors.black87,
              ),
              children: [
                const TextSpan(text: 'Bus Type '),
                const TextSpan(text: '• '),
                TextSpan(
                  text: busType,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          RichText(
            text: TextSpan(
              style: AppTextStyles.regular.copyWith(
                fontSize: 15,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: 'Rs. $adultPrice',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' per ticket'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          AppButton(
            borderRadius: 36,
            onPressed: onGetTickets,
            child: Text(
              'Get Tickets',
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
