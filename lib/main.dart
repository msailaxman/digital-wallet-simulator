import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/wallet_provider.dart';

// Screens
import 'screens/add_money_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/send_money_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/transaction_details_screen.dart';
import 'screens/transaction_history_screen.dart';

// Utils
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

// ==============================================================================
// EXPERIMENT 4 & 5: APPLICATION ENTRY POINT, PROVIDER SETUP & MATERIALAPP
// Demonstrates MultiProvider for app-wide state management and named routes
// for screen-to-screen navigation.
// ==============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // Experiment 5: MultiProvider wraps entire widget tree
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const DigitalWalletApp(),
    ),
  );
}

class DigitalWalletApp extends StatelessWidget {
  const DigitalWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Experiment 5 & 6: Consumer listens to ThemeProvider to toggle light/dark theme
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Digital Wallet Simulator',
          debugShowCheckedModeBanner: false,

          // Experiment 6: Light & Dark Theme Configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,

          // Experiment 4: Navigation Routes
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.addMoney: (context) => const AddMoneyScreen(),
            AppRoutes.sendMoney: (context) => const SendMoneyScreen(),
            AppRoutes.transactions: (context) => const TransactionHistoryScreen(),
            AppRoutes.transactionDetails: (context) =>
                const TransactionDetailsScreen(),
            AppRoutes.profile: (context) => const ProfileScreen(),
            AppRoutes.settings: (context) => const SettingsScreen(),
            AppRoutes.contacts: (context) => const ContactsScreen(),
            AppRoutes.paymentSuccess: (context) => const PaymentSuccessScreen(),
          },
        );
      },
    );
  }
}
