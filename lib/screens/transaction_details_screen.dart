import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction_model.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';

// ==============================================================================
// SCREEN 8: TRANSACTION DETAILS SCREEN
// Demonstrates Experiment 4 (Receiving data passed between screens) and
// Experiment 2 & 3 (Flutter Layouts, Cards, Rows, Columns, Responsive design).
// ==============================================================================

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionModel? transaction;

  const TransactionDetailsScreen({super.key, this.transaction});

  @override
  Widget build(BuildContext context) {
    // Experiment 4: Retrieve passed data either from constructor or route arguments
    final txn = transaction ??
        (ModalRoute.of(context)?.settings.arguments as TransactionModel?);

    if (txn == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: const Center(child: Text('No transaction details available.')),
      );
    }

    final isCredit = txn.isCredit;
    final amountColor = isCredit ? AppTheme.successGreen : AppTheme.dangerRed;
    final iconBgColor = isCredit
        ? AppTheme.successGreen.withOpacity(0.12)
        : AppTheme.dangerRed.withOpacity(0.12);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Icon & Type Header
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCredit
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: amountColor,
                  size: 40,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                txn.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '${txn.formattedDate} at ${txn.formattedTime}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 14),

              // Large Amount Display
              Text(
                txn.formattedAmountWithSign,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),

              const SizedBox(height: 8),

              // Status Chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.successGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      txn.status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Detailed Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      // Transaction ID with Copy Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transaction ID',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Row(
                            children: [
                              Text(
                                txn.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy_rounded, size: 16),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.only(left: 6),
                                tooltip: 'Copy ID',
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: txn.id));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Transaction ID copied to clipboard'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      _buildDetailRow(
                        label: isCredit ? 'Received From' : 'Sent To',
                        value: txn.recipientOrSender,
                        isBold: true,
                      ),
                      const Divider(height: 20),

                      _buildDetailRow(
                        label: 'Phone Number',
                        value: txn.phoneNumber,
                      ),
                      const Divider(height: 20),

                      _buildDetailRow(
                        label: 'Payment Method',
                        value: txn.paymentMethod,
                      ),
                      const Divider(height: 20),

                      _buildDetailRow(
                        label: 'Transaction Type',
                        value: isCredit ? 'Credit (+)' : 'Debit (-)',
                      ),
                      const Divider(height: 20),

                      _buildDetailRow(
                        label: 'Note / Description',
                        value: txn.description,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Back Button
              CustomButton(
                text: 'Back',
                icon: Icons.arrow_back,
                isOutlined: true,
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
