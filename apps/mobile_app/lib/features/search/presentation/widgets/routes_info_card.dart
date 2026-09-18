import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

class RouteInfoCard extends StatelessWidget {
  final String routeFrom;
  final String routeTo;
  final String distanceKm;
  final String date;
  final List<TripInfo> trips;

  const RouteInfoCard({
    super.key,
    required this.routeFrom,
    required this.routeTo,
    required this.distanceKm,
    required this.date,
    required this.trips,
  });

  static const Color brandColor = Color(0xFF3339EC);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scale = (size.width / 390).clamp(0.85, 1.15);

    return Padding(
      padding: EdgeInsets.all(16 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'information',
            style: AppTextStyles.bold.copyWith(
              fontSize: 20 * scale,
            ),
          ),
          SizedBox(height: 8 * scale),
          Container(
            padding: EdgeInsets.fromLTRB(
              16 * scale,
              16 * scale,
              16 * scale,
              20 * scale,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40 * scale),
              border: Border.all(
                color: const Color(0xFF007AFF),
                width: 1.5 * scale,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.regular.copyWith(
                      color: Colors.black,
                      fontSize: 12 * scale,
                    ),
                    children: [
                      TextSpan(
                        text: 'Route - ',
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 12 * scale,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(text: '$routeFrom to $routeTo'),
                      TextSpan(
                        text: '   Distance - ',
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 12 * scale,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(text: distanceKm),
                    ],
                  ),
                ),
                SizedBox(height: 6 * scale),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.regular.copyWith(
                      color: Colors.black,
                      fontSize: 12 * scale,
                    ),
                    children: [
                      TextSpan(
                        text: 'Date - ',
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 12 * scale,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(text: date),
                    ],
                  ),
                ),
                SizedBox(height: 10 * scale),
                for (int i = 0; i < trips.length; i++) ...[
                  _TripCard(
                    trip: trips[i],
                    scale: scale,
                  ),
                  if (i != trips.length - 1)
                    SizedBox(height: 14 * scale),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TripInfo {
  final String busType;
  final String routeNumber;
  final String departureTime;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCity;

  const TripInfo({
    required this.busType,
    required this.routeNumber,
    required this.departureTime,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCity,
  });
}

class _TripCard extends StatelessWidget {
  final TripInfo trip;
  final double scale;

  const _TripCard({
    required this.trip,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300 * scale,
      height: 105 * scale,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 125 * scale,
            padding: EdgeInsets.fromLTRB(
              16 * scale,
              10 * scale,
              16 * scale,
              0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF70A0F2),
              borderRadius: BorderRadius.circular(30 * scale),
            ),
            child: Column(
              children: [
                Text(
                  'Bustype - ${trip.busType}',
                  style: AppTextStyles.regular.copyWith(
                    color: Colors.black,
                    fontSize: 15 * scale,
                  ),
                ),
                SizedBox(height: 3 * scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Departure',
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.white,
                        fontSize: 13 * scale,
                      ),
                    ),
                    Text(
                      'Route - ${trip.routeNumber}',
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.white,
                        fontSize: 13 * scale,
                      ),
                    ),
                    Text(
                      'Arrival',
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.white,
                        fontSize: 13 * scale,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 18 * scale,
                vertical: 8 * scale,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(28 * scale),
                border: Border.all(
                  color: const Color(0xFF009EFF),
                  width: 1.5 * scale,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 9 * scale,
                    offset: Offset(0, 7 * scale),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        trip.departureTime,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25 * scale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6 * scale),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3 * scale),
                        child: Text(
                          trip.departureCity,
                          style: AppTextStyles.regular.copyWith(
                            color: Colors.black,
                            fontSize: 14 * scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        trip.arrivalTime,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25 * scale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6 * scale),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3 * scale),
                        child: Text(
                          trip.arrivalCity,
                          style: AppTextStyles.regular.copyWith(
                            color: Colors.black,
                            fontSize: 14 * scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}