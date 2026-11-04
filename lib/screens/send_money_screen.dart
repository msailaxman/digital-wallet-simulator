import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact_model.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

// ==============================================================================
// SCREEN 6: SEND MONEY SCREEN
// Demonstrates Experiment 1 (sendMoney arithmetic, balance deduction, validation),
// Experiment 7 (Forms & Validation), and Experiment 4 (Navigation).
// ==============================================================================

class SendMoneyScreen extends StatefulWidget {
  final ContactModel? prefilledContact;

  const SendMoneyScreen({super.key, this.prefilledContact});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _recipientNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // If navigated with prefilled contact from REST API Contacts Screen
    if (widget.prefilledContact != null) {
      _recipientNameController.text = widget.prefilledContact!.name;
      _phoneController.text =
          widget.prefilledContact!.phone.replaceAll(RegExp(r'\D'), '');
      if (_phoneController.text.length > 10) {
        _phoneController.text = _phoneController.text.substring(0, 10);
      }
    }
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSendMoney() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    // Validation: Check sufficient balance
    if (parsedAmount > walletProvider.balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Insufficient balance! Available: ₹${walletProvider.balance.toStringAsFixed(2)}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show Confirmation Dialog before deducting money
    _showConfirmationDialog(parsedAmount);
  }

  void _showConfirmationDialog(double amount) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to send this amount?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recipient:'),
                      Text(
                        _recipientNameController.text.trim(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Phone:'),
                      Text(_phoneController.text.trim()),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.dangerRed,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              _executePayment(amount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
            ),
            child: const Text('Confirm & Send'),
          ),
        ],
      ),
    );
  }

  void _executePayment(double amount) {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);

      // Experiment 1: Call sendMoney()
      final success = walletProvider.sendMoney(
        recipientName: _recipientNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        amount: amount,
        description: _descriptionController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Most recent transaction is the debit transaction we just created
        final completedTxn = walletProvider.transactions.first;

        // Experiment 4: Navigate to Payment Success Screen with transaction arguments
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.paymentSuccess,
          arguments: completedTxn,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction failed. Please check wallet balance.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Available Balance Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available Balance:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${walletProvider.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Pick from Contacts Button (Links Experiment 9 to Send Money)
                OutlinedButton.icon(
                  onPressed: () async {
                    // Navigate to Contacts screen and await selected contact
                    final selected = await Navigator.pushNamed(
                      context,
                      AppRoutes.contacts,
                      arguments: true, // indicates contact selection mode
                    );

                    if (selected is ContactModel) {
                      setState(() {
                        _recipientNameController.text = selected.name;
                        _phoneController.text =
                            selected.phone.replaceAll(RegExp(r'\D'), '');
                        if (_phoneController.text.length > 10) {
                          _phoneController.text =
                              _phoneController.text.substring(0, 10);
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.contacts_rounded, size: 18),
                  label: const Text('Pick Contact from REST API (Exp 9)'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Recipient Name Field (Experiment 7)
                CustomTextField(
                  controller: _recipientNameController,
                  label: 'Recipient Name',
                  hint: 'e.g. Rahul Sharma',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Recipient name cannot be empty';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Recipient Phone Number Field (Experiment 7)
                CustomTextField(
                  controller: _phoneController,
                  label: 'Recipient Phone Number',
                  hint: '10-digit mobile number',
                  prefixIcon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number cannot be empty';
                    }
                    final digits = value.replaceAll(RegExp(r'\D'), '');
                    if (digits.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Amount Field (Experiment 7 & 1)
                CustomTextField(
                  controller: _amountController,
                  label: 'Amount to Send (₹)',
                  hint: '0.00',
                  prefixIcon: Icons.currency_rupee_rounded,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    // Experiment 1: validateAmount with checkAvailableBalance = true
                    return walletProvider.validateAmount(
                      value,
                      checkAvailableBalance: true,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Description Field (Optional)
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Payment Note / Description (Optional)',
                  hint: 'e.g. College Project fee, Dinner share',
                  prefixIcon: Icons.notes_rounded,
                  maxLines: 2,
                ),

                const SizedBox(height: 28),

                // Send Money Action Button
                CustomButton(
                  text: 'Send Money Now',
                  isLoading: _isLoading,
                  icon: Icons.send_rounded,
                  onPressed: _handleSendMoney,
                ),

                const SizedBox(height: 12),

                Center(
                  child: Text(
                    'Simulated debit operation. No real money is transferred.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
