import 'package:cloud_firestore/cloud_firestore.dart';
import 'ticket_model.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Ticket?> getTicket(String ticketId) async {
    final document = await _firestore
        .collection('tickets')
        .doc(ticketId.trim())
        .get();

    if (!document.exists) return null;

    return Ticket.fromMap(document.id, document.data()!);
  }
}
