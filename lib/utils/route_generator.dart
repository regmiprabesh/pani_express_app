import 'package:flutter/material.dart';
import 'package:pani_express/screens/dashboard_screen.dart';
import 'package:pani_express/screens/otp_verification_screen.dart';
import 'package:pani_express/screens/phone_login_screen.dart';
import 'package:pani_express/screens/profile_screen.dart';
import 'package:pani_express/screens/referrals_screen.dart';
import 'package:pani_express/screens/settings_screen.dart';
import 'package:pani_express/screens/splash_screen.dart';
import 'package:pani_express/screens/user_registration_screen.dart';
import 'package:pani_express/utils/app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.phoneLogin:
        return MaterialPageRoute(builder: (_) => const PhoneLoginScreen());
      case AppRoutes.otpVerification:
        if (args is Map<String, dynamic> && args.containsKey('phoneNumber')) {
          return MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              phoneNumber: args['phoneNumber'],
            ),
          );
        }
        return _errorRoute();
      case AppRoutes.userRegistration:
        return MaterialPageRoute(
            builder: (_) => const UserRegistrationScreen());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.referrals:
        return MaterialPageRoute(builder: (_) => const ReferralsScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        // If there is no such named route in the switch statement
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found!'),
        ),
      );
    });
  }
}
