import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';

// ==============================================================================
// PAYMENT SUCCESS SCREEN
// Demonstrates Experiment 8 (Flutter Animations: AnimatedOpacity, AnimatedContainer)
// and Experiment 4 (Navigation and Data Passing).
// ==============================================================================

class PaymentSuccessScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const PaymentSuccessScreen({super.key, this.transaction});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  // Experiment 8: Animation states
  double _opacity = 0.0;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();
    // Trigger smooth appearance animation
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _scale = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve passed transaction from arguments if not passed in constructor
    final txn = widget.transaction ??
        (ModalRoute.of(context)?.settings.arguments as TransactionModel?);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Experiment 8: Animated Container with Scale & Opacity
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  child: AnimatedScale(
                    scale: _scale,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1FAE5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.successGreen,
                        size: 64,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Your money transfer simulation was completed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 24),

                if (txn != null) ...[
                  // Transaction Summary Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            'Amount Transferred',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${txn.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue,
                            ),
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Paid To:'),
                              Text(
                                txn.recipientOrSender,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Phone:'),
                              Text(txn.phoneNumber),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Transaction ID:'),
                              Text(
                                txn.id,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date & Time:'),
                              Text('${txn.formattedDate}, ${txn.formattedTime}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const Spacer(),

                // View Details Button
                if (txn != null) ...[
                  CustomButton(
                    text: 'View Receipt / Details',
                    isOutlined: true,
                    icon: Icons.receipt_long_rounded,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.transactionDetails,
                        arguments: txn,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Back to Dashboard Button
                CustomButton(
                  text: 'Back to Dashboard',
                  icon: Icons.home_rounded,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
