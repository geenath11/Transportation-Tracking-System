class TicketModel {
  final String ticketId;
  final String userId;

  final String passengerName;
  final String passengerPhone;

  final String from;
  final String to;

  final String date;
  final String departureTime;
  final String arrivalTime;

  final String bus;
  final List<String> selectedSeats;

  final double totalPrice;

  final String paymentStatus;
  final String ticketStatus;

  TicketModel({
    required this.ticketId,
    required this.userId,
    required this.passengerName,
    required this.passengerPhone,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.arrivalTime,
    required this.bus,
    required this.selectedSeats,
    required this.totalPrice,
    required this.paymentStatus,
    required this.ticketStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'userId': userId,
      'passengerName': passengerName,
      'passengerPhone': passengerPhone,
      'from': from,
      'to': to,
      'date': date,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'bus': bus,
      'selectedSeats': selectedSeats,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
      'ticketStatus': ticketStatus,
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      ticketId: map['ticketId'] ?? '',
      userId: map['userId'] ?? '',
      passengerName: map['passengerName'] ?? '',
      passengerPhone: map['passengerPhone'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      date: map['date'] ?? '',
      departureTime: map['departureTime'] ?? '',
      arrivalTime: map['arrivalTime'] ?? '',
      bus: map['bus'] ?? '',
      selectedSeats: List<String>.from(map['selectedSeats'] ?? []),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      paymentStatus: map['paymentStatus'] ?? '',
      ticketStatus: map['ticketStatus'] ?? '',
    );
  }
}
