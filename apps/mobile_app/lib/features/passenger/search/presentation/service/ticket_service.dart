import 'package:cloud_firestore/cloud_firestore.dart';

class TicketService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Set<int>> getBookedSeats({
    required String date,
    required String departureTime,
  }) async {
    final snapshot = await _firestore
        .collection('tickets')
        .where('date', isEqualTo: date)
        .where('departureTime', isEqualTo: departureTime)
        .where('ticketStatus', isEqualTo: 'valid')
        .get();

    final bookedSeats = <int>{};

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final seats = data['selectedSeats'];

      if (seats is List) {
        for (final seat in seats) {
          if (seat is num) {
            bookedSeats.add(seat.toInt());
          } else if (seat is String) {
            final seatNumber = int.tryParse(seat);

            if (seatNumber != null) {
              bookedSeats.add(seatNumber);
            }
          }
        }
      }
    }

    return bookedSeats;
  }
}
