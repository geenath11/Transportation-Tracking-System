import 'package:flutter/material.dart';

import '../../features/conductor/home/presentation/conductor_home_page.dart';
import '../../features/driver/home/presentation/driver_home_page.dart';
import '../../features/passenger/home/presentation/screen/passenger_home_page.dart';

class RoleRouter {
  static Widget? getHomeForRole(String? role) {
    switch (role?.trim().toLowerCase()) {
      case 'driver':
        return const DriverHomePage();

      case 'conductor':
        return const ConductorHomePage();

      case 'passenger':
        return const PassengerHomePage();

      default:
        return null;
    }
  }
}
