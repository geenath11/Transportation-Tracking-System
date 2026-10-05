import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ticket_model.dart';

class TicketService {
  TicketService._();

  static final TicketService instance = TicketService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTicket(TicketModel ticket) async {
    await _firestore.collection('tickets').doc(ticket.ticketId).set({
      ...ticket.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<TicketModel?> getTicket(String ticketId) async {
    final document = await _firestore.collection('tickets').doc(ticketId).get();

    if (!document.exists) {
      return null;
    }

    return TicketModel.fromMap(document.data()!);
  }

  Future<void> markTicketAsUsed(String ticketId) async {
    await _firestore.collection('tickets').doc(ticketId).update({
      'ticketStatus': 'used',
      'usedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<TicketModel>> getUserTickets(String userId) {
    return _firestore
        .collection('tickets')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TicketModel.fromMap(doc.data());
          }).toList();
        });
  }
}
