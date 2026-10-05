import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';
import 'package:transportation_tracking_system/features/conductor/tickets/data/ticket_model.dart';
import 'package:transportation_tracking_system/features/conductor/tickets/data/ticket_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final TicketService _ticketService = TicketService();

  bool _hasScanned = false;

  String? _lastRejected;
  DateTime? _lastRejectedAt;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isCoolingDown(String value) {
    final at = _lastRejectedAt;
    return _lastRejected == value &&
        at != null &&
        DateTime.now().difference(at) < const Duration(seconds: 2);
  }

  void _markRejected(String value) {
    _lastRejected = value;
    _lastRejectedAt = DateTime.now();
  }

  Future<void> _handleScan(String value) async {
    if (_hasScanned) return;

    final ticketId = value.trim();

    if (_isCoolingDown(ticketId)) return;

    debugPrint('SCANNED QR: "$ticketId"');

    if (!_validateQr(ticketId)) {
      _markRejected(ticketId);
      _showError('Invalid Cey Go QR code.');
      return;
    }

    setState(() => _hasScanned = true);
    await _controller.stop();

    try {
      final Ticket? ticket = await _ticketService.getTicket(ticketId);

      if (!mounted) return;

      if (ticket == null) {
        _markRejected(ticketId);
        await _resumeScanning();
        _showError('Ticket not found.');
        return;
      }

      debugPrint('Ticket found: ${ticket.id} (${ticket.route})');
      _showTicket(ticket);
    } catch (e) {
      debugPrint('Firebase error: $e');

      if (!mounted) return;

      _markRejected(ticketId);
      await _resumeScanning();
      _showError('Unable to validate ticket. Please try again.');
    }
  }

  Future<void> _resumeScanning() async {
    if (!mounted) return;
    setState(() => _hasScanned = false);
    await _controller.start();
  }

  bool _validateQr(String value) {
    final qr = value.trim();

    if (!qr.startsWith('CEYGO-')) return false;

    final number = qr.substring(6);
    return number.isNotEmpty && int.tryParse(number) != null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showTicket(Ticket ticket) {
    final String statusLabel;
    final Color statusColor;
    final IconData statusIcon;

    if (!ticket.isPaid) {
      statusLabel = 'NOT PAID';
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else if (ticket.isValid) {
      statusLabel = 'VALID TICKET';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (ticket.ticketStatus == 'used') {
      statusLabel = 'ALREADY USED';
      statusColor = Colors.orange;
      statusIcon = Icons.warning_amber_rounded;
    } else {
      statusLabel = 'INVALID TICKET';
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor),
                      const SizedBox(width: 10),
                      Text(
                        statusLabel,
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 18,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _ticketRow('Ticket ID', ticket.ticketId),
                const SizedBox(height: 12),
                _ticketRow('Passenger', ticket.passengerName),
                const SizedBox(height: 12),
                _ticketRow('Phone', ticket.passengerPhone),
                const SizedBox(height: 12),
                _ticketRow('Route', ticket.route),
                const SizedBox(height: 12),
                _ticketRow('Bus', ticket.bus),
                const SizedBox(height: 12),
                _ticketRow('Seats', ticket.seatsText),
                const SizedBox(height: 12),
                _ticketRow('Date', ticket.date),
                const SizedBox(height: 12),
                _ticketRow(
                  'Time',
                  '${ticket.departureTime} - ${ticket.arrivalTime}',
                ),
                const SizedBox(height: 12),
                _ticketRow('Price', 'Rs. ${ticket.totalPrice}'),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(_resumeScanning);
  }

  Widget _ticketRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90, child: Text(label, style: AppTextStyles.semiBold)),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: AppTextStyles.regular,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          'Scan Ticket',
          style: AppTextStyles.semiBold.copyWith(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) return;

              final value = capture.barcodes.first.rawValue;

              if (value != null && value.isNotEmpty) {
                _handleScan(value);
              }
            },
          ),
          Positioned(
            top: 30,
            left: 24,
            right: 24,
            child: Column(
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  'Align the QR code within the frame',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semiBold.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Text(
              'Scan the passenger ticket QR code',
              textAlign: TextAlign.center,
              style: AppTextStyles.semiBold.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
