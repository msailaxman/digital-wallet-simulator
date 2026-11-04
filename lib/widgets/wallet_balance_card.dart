import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

// ==============================================================================
// EXPERIMENT 2, 3, 6 & 8: CUSTOM WALLET BALANCE CARD
// Demonstrates Container, Stack, Row, Column, Card, MediaQuery, and AnimatedContainer.
// Displays the user's available wallet balance in Indian Rupees (₹) and quick actions.
// ==============================================================================

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final String walletId;
  final VoidCallback onAddMoney;
  final VoidCallback onSendMoney;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.walletId,
    required this.onAddMoney,
    required this.onSendMoney,
  });

  @override
  Widget build(BuildContext context) {
    // Experiment 3: MediaQuery for responsive layout sizing
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.walletGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background circles (Experiment 2: Stack)
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Main Card Content (Experiment 2: Column & Padding)
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Wallet ID and Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Wallet ID: $walletId',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Balance Label
                const Text(
                  'Total Available Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                // Dynamic Balance in Rupees (₹) with simple animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '₹${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth < 360 ? 28 : 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Action buttons row (Add Money & Send Money)
                Row(
                  children: [
                    // Add Money Quick Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAddMoney,
                        icon: const Icon(Icons.add_circle_outline, size: 18),
                        label: const Text('Add Money'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryDarkBlue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Send Money Quick Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onSendMoney,
                        icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                        label: const Text('Send Money'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.white38,
                              width: 1.2,
                            ),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
