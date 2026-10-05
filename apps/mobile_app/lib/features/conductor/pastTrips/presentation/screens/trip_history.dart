import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';

class TripHistory extends StatelessWidget {
  const TripHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trip History', style: AppTextStyles.semiBold.copyWith()),
            ],
          ),
        ),
      ),
    );
  }
}
