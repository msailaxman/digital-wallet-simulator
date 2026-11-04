import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

// ==============================================================================
// SCREEN 5: ADD MONEY SCREEN
// Demonstrates Experiment 1 (addMoney calculation), Experiment 7 (Forms & Validation),
// Experiment 5 (Provider State Management), and Experiment 8 (AnimatedContainer).
// ==============================================================================

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  // Preset amounts for quick selection
  final List<double> _presetAmounts = [100.0, 500.0, 1000.0, 2000.0];
  double? _selectedPreset;

  // Demo payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'UPI Simulator',
      'title': 'UPI Simulator',
      'subtitle': 'Google Pay / PhonePe / Paytm Simulation',
      'icon': Icons.qr_code_2_rounded,
    },
    {
      'id': 'Debit Card Demo',
      'title': 'Debit / ATM Card (Simulated)',
      'subtitle': 'Visa / Mastercard / RuPay demo',
      'icon': Icons.credit_card_rounded,
    },
    {
      'id': 'Net Banking Demo',
      'title': 'Net Banking (Simulated)',
      'subtitle': 'All major Indian banks supported',
      'icon': Icons.account_balance_rounded,
    },
  ];

  String _selectedPaymentMethod = 'UPI Simulator';
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onPresetSelected(double amount) {
    setState(() {
      _selectedPreset = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  void _handleAddMoney() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount greater than ₹0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate short network delay for realism
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);

      // Experiment 1: Call addMoney()
      final success = walletProvider.addMoney(
        amount: parsedAmount,
        paymentMethod: _selectedPaymentMethod,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        _showSuccessDialog(parsedAmount);
      }
    });
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.successGreen,
                size: 44,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Money Added Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${amount.toStringAsFixed(2)} has been credited to your digital wallet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Mode:'),
                  Text(
                    _selectedPaymentMethod,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Return to Dashboard
              },
              child: const Text('Back to Dashboard'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Money to Wallet'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Balance Indicator
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
                        'Current Wallet Balance:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${walletProvider.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Amount Input Field (Experiment 7)
                CustomTextField(
                  controller: _amountController,
                  label: 'Enter Amount (₹)',
                  hint: '0.00',
                  prefixIcon: Icons.currency_rupee_rounded,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    // Experiment 1: Call validateAmount()
                    return walletProvider.validateAmount(value);
                  },
                  onChanged: (val) {
                    final entered = double.tryParse(val);
                    if (entered != _selectedPreset) {
                      setState(() {
                        _selectedPreset = null;
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Preset Amount Buttons (Experiment 8: AnimatedContainer)
                const Text(
                  'Quick Select Amount',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: _presetAmounts.map((amount) {
                    final isSelected = _selectedPreset == amount;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () => _onPresetSelected(amount),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : theme.cardTheme.color,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : Colors.grey.withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              '+₹${amount.toInt()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // Payment Method Selection Demo
                const Text(
                  'Select Payment Source (Simulated)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                ...List.generate(_paymentMethods.length, (index) {
                  final method = _paymentMethods[index];
                  final isSelected = _selectedPaymentMethod == method['id'];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : Colors.transparent,
                        width: isSelected ? 1.8 : 0,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = method['id'] as String;
                        });
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          method['icon'] as IconData,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      title: Text(
                        method['title'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        method['subtitle'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Radio<String>(
                        value: method['id'] as String,
                        groupValue: _selectedPaymentMethod,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedPaymentMethod = val;
                            });
                          }
                        },
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Add Money Submit Button
                CustomButton(
                  text: 'Proceed to Add Money',
                  isLoading: _isLoading,
                  icon: Icons.add_circle_outline,
                  onPressed: _handleAddMoney,
                ),

                const SizedBox(height: 12),

                Center(
                  child: Text(
                    'Note: All banking operations are simulated locally.',
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
