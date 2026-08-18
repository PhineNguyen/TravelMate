import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:frontend/core/auth/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionService.init();
  runApp(const TravelMateApp());
}
