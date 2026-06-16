import 'package:flutter/material.dart';
// import 'package:frontend/features/auth/splash/presentation/pages/SplashPage.dart';
// import 'package:frontend/features/auth/onboarding/presentation/pages/OnboardPage.dart';
// import 'package:frontend/features/auth/login/presentation/pages/LoginPage.dart';
// import 'package:frontend/features/auth/register/presentation/pages/RegisterPage.dart';
// import 'package:frontend/features/auth/forgot_password/presentation/pages/ForgotPWPage.dart';
// import 'package:frontend/features/trip_planning/home/presentation/pages/HomePage.dart';
// import 'package:frontend/features/trip_planning/templates/presentation/pages/TemplatesPage.dart';
// import 'package:frontend/features/trip_planning/create_trip/presentation/pages/CreateTripPage.dart';
// import 'package:frontend/features/trip_planning/preferences/presentation/pages/PreferencesPage.dart';
// import 'package:frontend/features/trip_details/itinerary/presentation/pages/ItineraryPage.dart';
// import 'package:frontend/features/trip_details/trip_detail/presentation/pages/TripDetailPage.dart';
// import 'package:frontend/features/trip_details/map/presentation/pages/MapPage.dart';
// import 'package:frontend/features/trip_details/weather/presentation/pages/WeatherPage.dart';
// import 'package:frontend/features/trip_details/share/presentation/pages/ShareTripPage.dart';
// import 'package:frontend/features/trip_details/history/presentation/pages/HistoryPage.dart';
// import 'package:frontend/features/finance/budget/presentation/pages/BudgetPage.dart';
// import 'package:frontend/features/finance/expense/presentation/pages/AddExpensePage.dart';
// import 'package:frontend/features/ai_assistant/chat/presentation/pages/AiChatPage.dart';
// import 'package:frontend/features/user_profile/profile/presentation/pages/ProfilePage.dart';
// import 'package:frontend/features/user_profile/notifications/presentation/pages/NotificationsPage.dart';
// import 'package:frontend/features/user_profile/analytics/presentation/pages/AnalyticsPage.dart';

class TravelMateApp extends StatelessWidget {
  const TravelMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // home: const SplashPage(),
      // home: const OnboardPage(),
      // home: const LoginPage(),
      // home: const RegisterPage(),
      // home: const ForgotPWPage(),
      // home: const HomePage(),
      // home: const TemplatesPage(),
      // home: const CreateTripPage(),
      // home: const PreferencesPage(),
      // home: const ItineraryPage(),
      // home: const TripDetailPage(),
      // home: const MapPage(),
      // home: const WeatherPage(),
      // home: const ShareTripPage(),
      // home: const HistoryPage(),
      home: const BudgetPage(), // fix from here
      // home: const AddExpensePage(),
      // home: const AiChatPage(),
      // home: const ProfilePage(),
      // home: const NotificationsPage(),
      // home: const AnalyticsPage(),
    );
  }
}
