import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final String ticketId;
  final String bus;
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final String arrivalTime;
  final String passengerName;
  final String passengerPhone;
  final String paymentStatus;
  final String ticketStatus;
  final List<String> selectedSeats;
  final int totalPrice;
  final String userId;
  final DateTime? createdAt;

  const Ticket({
    required this.id,
    required this.ticketId,
    required this.bus,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.arrivalTime,
    required this.passengerName,
    required this.passengerPhone,
    required this.paymentStatus,
    required this.ticketStatus,
    required this.selectedSeats,
    required this.totalPrice,
    required this.userId,
    this.createdAt,
  });

  factory Ticket.fromMap(String id, Map<String, dynamic> map) {
    return Ticket(
      id: id,
      ticketId: map['ticketId'] as String? ?? id,
      bus: map['bus'] as String? ?? '',
      from: map['from'] as String? ?? '',
      to: map['to'] as String? ?? '',
      date: map['date'] as String? ?? '',
      departureTime: map['departureTime'] as String? ?? '',
      arrivalTime: map['arrivalTime'] as String? ?? '',
      passengerName: map['passengerName'] as String? ?? '',
      passengerPhone: map['passengerPhone'] as String? ?? '',
      paymentStatus: map['paymentStatus'] as String? ?? '',
      ticketStatus: map['ticketStatus'] as String? ?? '',
      selectedSeats: (map['selectedSeats'] as List<dynamic>? ?? const [])
          .map((seat) => seat.toString())
          .toList(),
      totalPrice: (map['totalPrice'] as num?)?.toInt() ?? 0,
      userId: map['userId'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  String get route => '$from → $to';

  String get seatsText => selectedSeats.join(', ');

  bool get isPaid => paymentStatus == 'paid';

  bool get isValid => ticketStatus == 'valid';
}
