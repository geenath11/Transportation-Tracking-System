import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

import '../payment/presentation/screens/payment_screen.dart';

/// Seat selection screen for the Transportation Tracking System app.
/// Flat white background (no floating card) with a seat grid
/// (available / selected / booked) and a bottom "Pay" button.
class BookingSuccessScreen extends StatefulWidget {
  const BookingSuccessScreen({
    super.key,
    this.from = 'Badulla',
    this.to = 'Kandy',
    this.ticketPrice = 400,
    this.totalSeats = 35,
    this.bookedSeats = const {
      14,
      15,
      18,
      19,
    }, // indices of already-booked seats
    required this.arrivalTime,
    required this.departureTime,
    required this.date,
    required this.bustype,
  });

  final String date;
  final String arrivalTime;
  final String departureTime;
  final String from;
  final String to;
  final int ticketPrice;
  final int totalSeats;
  final Set<int> bookedSeats;
  final String bustype;

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  static const Color primaryBlue = AppColors.secondary;

  static const int frontSingleSeats = 1;
  static const int seatsPerSideRow = 2;

  final Set<int> _selectedSeats = {};

  int get _rowCount {
    final remaining = widget.totalSeats - frontSingleSeats;
    return (remaining / (seatsPerSideRow * 2)).ceil();
  }

  void _toggleSeat(int index) {
    if (widget.bookedSeats.contains(index)) return; // booked seats are locked
    setState(() {
      if (_selectedSeats.contains(index)) {
        _selectedSeats.remove(index);
      } else {
        _selectedSeats.add(index);
      }
    });
  }

  Widget _seatBox(int index) {
    final isBooked = widget.bookedSeats.contains(index);
    final isSelected = _selectedSeats.contains(index);

    Color fillColor;
    Widget? child;
    if (isBooked) {
      fillColor = const Color(0xFFB9BEC7);
      child = const Icon(Icons.close, size: 16, color: Colors.white);
    } else if (isSelected) {
      fillColor = primaryBlue;
    } else {
      fillColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => _toggleSeat(index),
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isBooked
                ? Colors.transparent
                : (isSelected ? primaryBlue : const Color(0xFFCBD0D8)),
          ),
        ),
        child: child,
      ),
    );
  }

  List<Widget> _buildRows() {
    int seatIndex = 0;
    final rows = <Widget>[];

    // Front single seat row.
    rows.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [_seatBox(seatIndex++)]),
      ),
    );

    // Remaining rows: left pair, gap, right pair.
    for (var r = 0; r < _rowCount; r++) {
      final leftSeats = <Widget>[];
      for (var i = 0; i < seatsPerSideRow; i++) {
        if (seatIndex < widget.totalSeats) leftSeats.add(_seatBox(seatIndex++));
      }
      final rightSeats = <Widget>[];
      for (var i = 0; i < seatsPerSideRow; i++) {
        if (seatIndex < widget.totalSeats)
          rightSeats.add(_seatBox(seatIndex++));
      }
      if (leftSeats.isEmpty && rightSeats.isEmpty) break;

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: leftSeats),
            const SizedBox(width: 28), // aisle gap
            Row(children: rightSeats),
          ],
        ),
      );
    }
    return rows;
  }

  Widget _routePill(String label, {required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: filled ? primaryBlue : const Color(0xFFCBD0D8),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.semiBold.copyWith(
          color: filled ? Colors.white : Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _legendItem({required Widget box, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        box,
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.regular.copyWith(
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  /// Small circle representing a bus wheel, sitting half-in/half-out of the
  /// seat-map outline.
  Widget _wheel() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.transparent,
        border: Border.all(color: const Color(0xFFC5CDCD), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _selectedSeats.length * widget.ticketPrice;
    final availableSeats =
        widget.totalSeats - widget.bookedSeats.length - _selectedSeats.length;

    // Flat white background, no separate "card" surface -> nothing floats
    // on top of the Scaffold, so there's no white-on-white seam/shadow.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Grey background behind the route
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7F8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const SizedBox(width: 180, height: 50),
                        ),

                        // Route content
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _routePill(widget.from, filled: true),

                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.arrow_forward, size: 16),
                            ),

                            _routePill(widget.to, filled: false),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Ticket Price : Rs ${widget.ticketPrice}',
                    style: AppTextStyles.semiBold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  // Seat map — outlined like a bus body, with small wheel
                  // bumps poking out of the left/right edges.
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Front-pair wheels
                      Positioned(left: -10, top: 36, child: _wheel()),
                      Positioned(right: -10, top: 36, child: _wheel()),
                      // Back-pair wheels
                      Positioned(left: -10, bottom: 36, child: _wheel()),
                      Positioned(right: -10, bottom: 36, child: _wheel()),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const Color(0xFFC5CDCD),
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Seat Available: $availableSeats',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ..._buildRows(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _legendItem(
                                  box: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFCBD0D8),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  label: 'Available seats',
                                ),
                                _legendItem(
                                  box: Container(
                                    width: 16,
                                    height: 16,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB9BEC7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  label: 'Booked Seats',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Selected Seat : ${_selectedSeats.length.toString().padLeft(2, '0')}',
                    style: AppTextStyles.semiBold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 4,
                      ),
                      onPressed: _selectedSeats.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    from: widget.from,
                                    to: widget.to,
                                    ticketPrice: widget.ticketPrice,
                                    selectedSeats: _selectedSeats,
                                    totalPrice: totalPrice,
                                    arrivalTime: widget.arrivalTime,
                                    departureTime: widget.departureTime,
                                    date: widget.date,
                                    bus: widget.bustype,
                                  ),
                                ),
                              );
                            },
                      child: Text(
                        'Payment of Rs $totalPrice',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
