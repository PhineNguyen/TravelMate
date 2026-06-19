import 'package:flutter/material.dart';
// import 'package:frontend/features/ai_assistant/chat/presentation/pages/AiChatPage.dart';
// import 'package:frontend/features/auth/forgot_password/presentation/pages/ResetPwPage.dart';
import 'package:frontend/features/auth/login/presentation/pages/LoginPage.dart';
// import 'package:frontend/features/auth/onboarding/presentation/pages/OnboardPage.dart';
// import 'package:frontend/features/auth/register/presentation/pages/RegisterPage.dart';
// import 'package:frontend/features/auth/splash/presentation/pages/SplashPage.dart';
// import 'package:frontend/features/finance/budget/presentation/pages/BudgetPage.dart';
// import 'package:frontend/features/finance/expense/presentation/pages/AddExpensePage.dart';
// import 'package:frontend/features/trip_details/history/presentation/pages/HistoryPage.dart';
// import 'package:frontend/features/trip_details/itinerary/presentation/pages/ItineraryPage.dart';
// import 'package:frontend/features/trip_details/map/presentation/pages/MapPage.dart';
// import 'package:frontend/features/trip_details/share/presentation/pages/ShareTripPage.dart';
// import 'package:frontend/features/trip_details/trip_detail/presentation/pages/TripDetailPage.dart';
// import 'package:frontend/features/trip_details/weather/presentation/pages/WeatherPage.dart';
// import 'package:frontend/features/trip_planning/create_trip/presentation/pages/CreateTripManunal.dart';
// import 'package:frontend/features/trip_planning/create_trip/presentation/pages/CreateTripPage.dart';
// import 'package:frontend/features/trip_planning/home/presentation/pages/HomePage.dart';
// import 'package:frontend/features/trip_planning/preferences/presentation/pages/PreferencesPage.dart';
// import 'package:frontend/features/trip_planning/templates/presentation/pages/TemplatesPage.dart';
// import 'package:frontend/features/user_profile/analytics/presentation/pages/AnalyticsPage.dart';
// import 'package:frontend/features/user_profile/notifications/presentation/pages/NotificationsPage.dart';
// import 'package:frontend/features/user_profile/profile/presentation/pages/ProfilePage.dart';
//import 'package:frontend/features/navigation/MainNavigator.dart';
//import 'package:frontend/features/trip_planning/home/presentation/pages/HomePage.dart';

class TravelMateApp extends StatelessWidget {
  const TravelMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1423),
      ),
      home: const LoginPage(),
    );
  }
}
