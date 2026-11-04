import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';

// ==============================================================================
// SCREEN 1: SPLASH SCREEN
// Demonstrates Experiment 2 (Basic Widgets), Experiment 4 (Navigation),
// and Experiment 8 (Flutter Animations using AnimatedOpacity).
// ==============================================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Experiment 5 & 8: Local UI animation state
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Trigger fade-in animation shortly after first frame
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Navigate to Login Screen after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        // Experiment 4: Navigator.pushReplacementNamed
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.walletGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Experiment 8: Simple fade-in animation using AnimatedOpacity
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: Column(
                  children: [
                    // Wallet App Logo Container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 54,
                        color: AppTheme.primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Application Title
                    const Text(
                      'Digital Wallet',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle / Tagline
                    const Text(
                      'Smart • Fast • Secure Simulator',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Lab Manual Demo Badge
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'B.Tech Flutter UI Design Lab Project',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
