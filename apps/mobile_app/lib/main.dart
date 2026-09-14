import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../core/services/user_profile_service.dart';

import '../app/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await UserProfileService.load();

  runApp(const CeyGoApp());
}
