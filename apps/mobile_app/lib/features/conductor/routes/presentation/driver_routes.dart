import 'package:flutter/material.dart';
import 'package:transportation_tracking_system/core/theme/app_text_styles.dart';

class DriverRoutes extends StatelessWidget {
  const DriverRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Driver Routes', style: AppTextStyles.semiBold.copyWith()),
            ],
          ),
        ),
      ),
    );
  }
}
