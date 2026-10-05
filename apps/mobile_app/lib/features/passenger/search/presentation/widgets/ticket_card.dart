import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_colors.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';
import 'package:transportation_tracking_system/features/passenger/home/presentation/data/services/favorite_route_service.dart';

import '../../../../../core/widgets/custom_button.dart';

class TicketCard extends StatefulWidget {
  const TicketCard({
    super.key,
    required this.departureTime,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCity,
    required this.busType,
    required this.onGetTickets,
    required this.adultPrice,
    required this.childPrice,
    required this.routeId,
  });

  final String routeId;
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
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final isFavorite = await FavoriteRouteService.isFavorite(widget.routeId);

      if (!mounted) return;

      setState(() {
        _isFavorite = isFavorite;
        _isLoadingFavorite = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingFavorite = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoadingFavorite) return;

    setState(() {
      _isLoadingFavorite = true;
    });

    try {
      if (_isFavorite) {
        await FavoriteRouteService.removeFavorite(widget.routeId);
      } else {
        await FavoriteRouteService.addFavorite(widget.routeId);
      }

      if (!mounted) return;

      setState(() {
        _isFavorite = !_isFavorite;
        _isLoadingFavorite = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingFavorite = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update favorite route.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 1),
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
                      widget.departureTime,
                      style: AppTextStyles.bold.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.departureCity,
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  tooltip: _isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  icon: _isLoadingFavorite
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite
                              ? AppColors.secondary
                              : Colors.black,
                          size: 25,
                        ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 15),
                child: Icon(Icons.subdirectory_arrow_right_outlined, size: 30),
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
                      widget.arrivalTime,
                      style: AppTextStyles.bold.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.arrivalCity,
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

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
                  text: widget.busType,
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
                  text: 'Rs. ${widget.adultPrice}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' per ticket'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          AppButton(
            borderRadius: 36,
            height: 50,
            width: size.width * .45,
            onPressed: widget.onGetTickets,
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
