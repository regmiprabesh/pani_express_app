import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:pani_express/blocs/auth/auth_bloc.dart';
import 'package:pani_express/blocs/auth/auth_event.dart';
import 'package:pani_express/blocs/auth/auth_state.dart';
import 'package:pani_express/config/size_config.dart';
import 'package:pani_express/utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Start animation and trigger auth check
    _animationController.forward();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    // Check authentication status after a slight delay for splash screen
    Timer(const Duration(seconds: 2), () {
      context.read<AuthBloc>().add(CheckAuthStatus());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize size config for responsive design
    SizeConfig().init(context);

    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Navigate based on auth state
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.phoneLogin);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Water drop animation
              Lottie.asset(
                'assets/animations/water_drop.json',
                width: getProportionateScreenWidth(200),
                height: getProportionateScreenWidth(200),
                controller: _animationController,
                onLoaded: (composition) {
                  _animationController.duration = composition.duration;
                },
                // Apply color override for dark mode
                options: LottieOptions(
                  enableMergePaths: true,
                ),
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: getProportionateScreenHeight(40)),

              // App name with stylish text
              Text(
                localizations.appName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(12)),

              // Tagline
              Text(
                localizations.appTagline,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(50)),

              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
