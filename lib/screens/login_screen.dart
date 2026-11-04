import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../services/auth_service.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

// ==============================================================================
// SCREEN 2: LOGIN SCREEN
// Demonstrates Experiment 7 (Forms & Validation), Experiment 4 (Navigation),
// and Experiment 2 & 3 (Widgets, Layout, Responsive UI).
// ==============================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Experiment 7: GlobalKey<FormState> for form validation
  final _formKey = GlobalKey<FormState>();

  // Experiment 7: TextEditingControllers
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Local UI state
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Auto-fill demo credentials to make viva exam demonstrations effortless
  void _fillDemoCredentials() {
    setState(() {
      _emailPhoneController.text = AuthService.demoEmail;
      _passwordController.text = AuthService.demoPassword;
      _errorMessage = null;
    });
  }

  void _handleLogin() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Experiment 7: Form validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = AuthService();
    final success = authService.login(
      _emailPhoneController.text,
      _passwordController.text,
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Update user profile in WalletProvider if needed
        if (authService.currentUser != null) {
          Provider.of<WalletProvider>(context, listen: false).updateUserProfile(
            name: authService.currentUser!.name,
            email: authService.currentUser!.email,
            phoneNumber: authService.currentUser!.phoneNumber,
          );
        }

        // Experiment 4: Navigate to Home screen using Named Route
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        setState(() {
          _errorMessage =
              'Invalid credentials. Use demo credentials or register.';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo & App Name Header
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 40,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Sign in to access your digital wallet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Demo Credentials Info Card for Viva demonstration
                  Card(
                    color: AppTheme.accentCyan.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: AppTheme.accentCyan.withOpacity(0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 18, color: AppTheme.primaryBlue),
                                    SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'Demo Login Credentials',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppTheme.primaryBlue,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: _fillDemoCredentials,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  minimumSize: Size.zero,
                                ),
                                child: const Text(
                                  'Auto-Fill',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Email: student@btech.ac.in\nPassword: password123',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF334155),
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '(Local demo simulator for college lab exam)',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Error Message Banner if login failed
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.dangerRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.dangerRed.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppTheme.dangerRed, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: AppTheme.dangerRed,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email or Phone Input (Experiment 7)
                  CustomTextField(
                    controller: _emailPhoneController,
                    label: 'Email or Phone Number',
                    hint: 'student@btech.ac.in',
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email or phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Input (Experiment 7)
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  CustomButton(
                    text: 'Sign In',
                    isLoading: _isLoading,
                    icon: Icons.login_rounded,
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: 20),

                  // Register Option (Experiment 3: Wrap to avoid layout overflow)
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Experiment 4: Navigator.pushNamed
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Text(
                          'Register Here',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
