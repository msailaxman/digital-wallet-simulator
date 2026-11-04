import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';

// ==============================================================================
// SCREEN 10: SETTINGS SCREEN
// Demonstrates Experiment 5 & 6 (Theme Switcher using Provider with ChangeNotifier),
// and Experiment 2 (ListTile, Switch, Cards, Dialogs).
// ==============================================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Experiment 5: ThemeProvider state management
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // Appearance Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Text(
                'APPEARANCE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Dark Theme',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      themeProvider.isDarkMode
                          ? 'Dark mode active (Experiment 6)'
                          : 'Light mode active (Experiment 6)',
                      style: const TextStyle(fontSize: 12),
                    ),
                    secondary: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: AppTheme.primaryBlue,
                    ),
                    value: themeProvider.isDarkMode,
                    onChanged: (val) {
                      // Experiment 5: Provider notifyListeners triggers theme rebuild
                      themeProvider.toggleTheme();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lab Manual Concept Verification (Viva Notes)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Text(
                'LAB EXPERIMENTS (1 TO 10)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    _buildExperimentItem(
                      'Exp 1: Dart Fundamentals',
                      'Variables, functions (addMoney, sendMoney, validateAmount), OOP, null safety',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 2: Flutter Widgets & Layouts',
                      'Text, Icon, Container, Card, Row, Column, Stack, ElevatedButton',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 3: Responsive UI',
                      'MediaQuery, LayoutBuilder, Expanded, Flexible, SafeArea',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 4: Navigation',
                      'Navigator.push, pop, pushNamed, pushReplacement, passing data',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 5: State Management',
                      'Provider with ChangeNotifier (Wallet, Theme) & setState() for local UI',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 6: Custom Widgets & Themes',
                      'WalletBalanceCard, CustomButton, TransactionTile, Light & Dark themes',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 7: Forms & Validation',
                      'Form, TextFormField, GlobalKey<FormState>, email/phone/amount validators',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 8: Flutter Animations',
                      'AnimatedOpacity on Splash, AnimatedContainer on Balance & Presets',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 9: REST API Integration',
                      'http package, jsonDecode(), async/await, jsonplaceholder users API',
                    ),
                    const Divider(height: 16),
                    _buildExperimentItem(
                      'Exp 10: Testing & Debugging',
                      'flutter_test unit tests, widget tests, integration balance tests',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Application Information Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Text(
                'APPLICATION INFORMATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline, color: AppTheme.accentCyan),
                    title: Text('Application Name'),
                    subtitle: Text('Digital Wallet Simulator'),
                    trailing: Text('v1.0.0', style: TextStyle(color: Colors.grey)),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.school_outlined, color: AppTheme.primaryBlue),
                    title: Text('Curriculum'),
                    subtitle: Text('B.Tech CSE - Flutter UI Design Lab'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.currency_rupee, color: AppTheme.successGreen),
                    title: Text('Currency Unit'),
                    subtitle: Text('Indian Rupees (₹)'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sign Out Option
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppTheme.dangerRed),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: AppTheme.dangerRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  AuthService().logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExperimentItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline,
            size: 16, color: AppTheme.successGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
