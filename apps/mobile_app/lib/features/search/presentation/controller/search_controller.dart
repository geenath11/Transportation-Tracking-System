import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TicketModel {
  final String departureTime;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCity;
  final String busType;
  final int childPrice;
  final int adultPrice;


  TicketModel({
    required this.departureTime,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCity,
    required this.busType,
    required this.adultPrice,
    required this.childPrice,

  });

  factory TicketModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data() ?? {};

    return TicketModel(
      departureTime: data['departureTime']?.toString() ?? '',
      departureCity: data['departureCity']?.toString() ?? '',
      arrivalTime: data['arrivalTime']?.toString() ?? '',
      arrivalCity: data['arrivalCity']?.toString() ?? '',
      busType: data['busType']?.toString() ?? 'Normal',
      adultPrice: (data['adultPrice'] as num?)?.toInt() ?? 0,
      childPrice: (data['childPrice'] as num?)?.toInt() ?? 0,
    );
  }
}

class TicketSearchController extends ChangeNotifier {
  TicketSearchController._();

  static final TicketSearchController instance =
  TicketSearchController._();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ------------------------------------------------------------
  // Search values
  // ------------------------------------------------------------

  String _fromLocation = '';
  String _toLocation = '';
  DateTime? _selectedDate;

  // ------------------------------------------------------------
  // Search results
  // ------------------------------------------------------------

  List<TicketModel> _tickets = [];

  // ------------------------------------------------------------
  // State
  // ------------------------------------------------------------

  bool _isLoading = false;
  String? _errorMessage;

  // ------------------------------------------------------------
  // Getters
  // ------------------------------------------------------------

  String get fromLocation => _fromLocation;

  String get toLocation => _toLocation;

  DateTime? get selectedDate => _selectedDate;

  List<TicketModel> get tickets => List.unmodifiable(_tickets);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // ------------------------------------------------------------
  // Search routes
  // ------------------------------------------------------------

  Future<void> searchTickets() async {
    if (_fromLocation.trim().isEmpty ||
        _toLocation.trim().isEmpty) {
      _errorMessage =
      'Please select departure and arrival locations.';

      _tickets = [];

      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      debugPrint('========================================');
      debugPrint('Searching routes...');
      debugPrint('From: $_fromLocation');
      debugPrint('To: $_toLocation');
      debugPrint('Date: $_selectedDate');

      // --------------------------------------------------------
      // Firestore query
      // --------------------------------------------------------

      final snapshot = await _firestore
          .collection('routes')
          .where(
        'departureCity',
        isEqualTo: _fromLocation.trim(),
      )
          .where(
        'arrivalCity',
        isEqualTo: _toLocation.trim(),
      )
          .get();

      // --------------------------------------------------------
      // Debug result
      // --------------------------------------------------------

      debugPrint(
        'Firestore documents found: ${snapshot.docs.length}',
      );

      // --------------------------------------------------------
      // Convert Firestore documents to TicketModel
      // --------------------------------------------------------

      _tickets = snapshot.docs.map((document) {
        debugPrint(
          'Route document ID: ${document.id}',
        );

        debugPrint(
          'Route data: ${document.data()}',
        );

        return TicketModel.fromFirestore(document);
      }).toList();

      // --------------------------------------------------------
      // Handle empty results
      // --------------------------------------------------------

      if (_tickets.isEmpty) {
        _errorMessage =
        'No routes found for $_fromLocation → $_toLocation';

        debugPrint(
          'No routes found for this route.',
        );
      } else {
        debugPrint(
          '${_tickets.length} route(s) found.',
        );
      }

      debugPrint('========================================');
    } on FirebaseException catch (e) {
      debugPrint('========================================');
      debugPrint('Firestore error');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');
      debugPrint('========================================');

      _tickets = [];

      _errorMessage =
      'Failed to load routes: ${e.message ?? e.code}';
    } catch (e) {
      debugPrint(
        'Unexpected route search error: $e',
      );

      _tickets = [];

      _errorMessage = 'Failed to load routes.';
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // Set departure location
  // ------------------------------------------------------------

  void setFromLocation(String location) {
    _fromLocation = location.trim();

    _errorMessage = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // Set arrival location
  // ------------------------------------------------------------

  void setToLocation(String location) {
    _toLocation = location.trim();

    _errorMessage = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // Set selected date
  // ------------------------------------------------------------

  void setSelectedDate(DateTime date) {
    _selectedDate = date;

    _errorMessage = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // Swap departure and arrival
  // ------------------------------------------------------------

  void swapLocations() {
    final temp = _fromLocation;

    _fromLocation = _toLocation;
    _toLocation = temp;

    _errorMessage = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // Clear ticket results
  // ------------------------------------------------------------

  void clearTickets() {
    _tickets = [];

    _errorMessage = null;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // Clear complete search
  // ------------------------------------------------------------

  void clearSearch() {
    _fromLocation = '';
    _toLocation = '';
    _selectedDate = null;

    _tickets = [];

    _errorMessage = null;

    notifyListeners();
  }
}