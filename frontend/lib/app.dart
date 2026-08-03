import 'package:flutter/material.dart';
import 'package:frontend/features/auth/splash/presentation/pages/SplashPage.dart';

class TravelMateApp extends StatelessWidget {
  const TravelMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F5F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6BB04D),
          primary: const Color(0xFF6BB04D),
          surface: Colors.white,
          background: const Color(0xFFF3F5F9),
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge:
              TextStyle(color: Color(0xFF1A1D2D), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF1A1D2D)),
          bodyMedium: TextStyle(color: Color(0xFF1A1D2D)),
        ),
      ),
      home: const SplashPage(),
    );
  }
}
