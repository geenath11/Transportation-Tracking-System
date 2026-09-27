import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import 'ticket_screen.dart';

class TicketSuccessScreen extends StatelessWidget {
  const TicketSuccessScreen({
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Booking Successful',
          style: AppTextStyles.semiBold.copyWith(
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 60,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Payment Successful!',
                textAlign: TextAlign.center,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 26,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Your CeyGo ticket has been booked successfully.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular.copyWith(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              // Ticket ID
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Text(
                      'Ticket ID',
                      style: AppTextStyles.regular.copyWith(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      ticketId,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Show the QR code on your ticket to the conductor when boarding.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular.copyWith(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const Spacer(),

              // View Ticket button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketScreen(
                          ticketId: ticketId,
                        ),
                      ),
                    );
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
                    'View My Ticket',
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Back to home
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                          (route) => route.isFirst,
                    );
                  },
                  child: Text(
                    'Back to Home',
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 16,
                      color: const Color(0xFF3339EC),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}